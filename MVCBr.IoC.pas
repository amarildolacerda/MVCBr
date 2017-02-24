{ *************************************************************************** }
{ }
{ Simple.IoC }
{ }
{ Copyright (C) 2013 Vincent Parrett }
{ }
{ http://www.finalbuilder.com }
{ }
{ }
{ *************************************************************************** }
{ }
{ Licensed under the Apache License, Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. }
{ You may obtain a copy of the License at }
{ }
{ http://www.apache.org/licenses/LICENSE-2.0 }
{ }
{ Unless required by applicable law or agreed to in writing, software }
{ distributed under the License is distributed on an "AS IS" BASIS, }
{ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{ See the License for the specific language governing permissions and }
{ limitations under the License. }
{ }
{ *************************************************************************** }

unit MVCBr.IoC;

/// A Simple IoC container. Does not do Dependency Injects.

interface

uses
  Generics.Collections,
  TypInfo,
  Rtti,
  MVCBr.Interf,
  SysUtils;

{ .$I 'SimpleIoC.inc' }
{$DEFINE DELPHI_XE_UP }

type
  TResolveResult = (Unknown, Success, InterfaceNotRegistered, ImplNotRegistered,
    DeletegateFailedCreate);

  TActivatorDelegate<TInterface: IInterface> = reference to function
    : TInterface;

  TMVCBrIoC = class
  private
    FRaiseIfNotFound: boolean;

  type
    TIoCRegistration<T: IInterface> = class
      Guid: TGuid;
      name: string;
      IInterface: PTypeInfo;
      ImplClass: TClass;
      ActivatorDelegate: TActivatorDelegate<T>;
      IsSingleton: boolean;
      Instance: IInterface;
    end;

  private

    FContainerInfo: TDictionary<string, TObject>;
    class var FDefault: TMVCBrIoC;
    class destructor ClassDestroy;
  protected
    function GetInterfaceKey<TInterface>(const AName: string = ''): string;
    function InternalResolve<TInterface: IInterface>(out AInterface: TInterface;
      const AName: string = ''): TResolveResult;
    procedure InternalRegisterType<TInterface: IInterface>(const singleton
      : boolean; const AImplementation: TClass;
      const delegate: TActivatorDelegate<TInterface>; const name: string = '');
  public
    constructor Create;
    destructor Destroy; override;
    // Default Container
    class function DefaultContainer: TMVCBrIoC;
{$IFDEF DELPHI_XE_UP}
    // Exe's compiled with D2010 will crash when these are used.
    // NOTES: The issue is due to the two generics included in the functions. The constaints also seem to be an issue.
    procedure RegisterType<TInterface: IInterface; TImplementation: class>
      (const name: string = ''); overload;
    procedure RegisterType<TInterface: IInterface; TImplementation: class>
      (const singleton: boolean; const name: string = ''); overload;
{$ENDIF}
    procedure RegisterType<TInterface: IInterface>(const delegate
      : TActivatorDelegate<TInterface>; const name: string = ''); overload;
    procedure RegisterType<TInterface: IInterface>(const singleton: boolean;
      const delegate: TActivatorDelegate<TInterface>;
      const name: string = ''); overload;

    procedure RevokeInstance(AInstance: IInterface);

    // Register an instance as a signleton. If there is more than one instance that implements the interface
    // then use the name parameter
    procedure RegisterSingleton<TInterface: IInterface>(const Instance
      : TInterface; const name: string = '');

    // Resolution
    function Resolve<TInterface: IInterface>(const name: string = '')
      : TInterface;
    function GetName(AGuid: TGuid): string;

    { procedure RegisterController(AII: TGuid; AClass: TControllerClass;
      AName: String;bSingleton:boolean);
    } procedure RegisterInterfaced<TInterface: IInterface>(AII: TGuid;
      AClass: TInterfacedClass; AName: String; bSingleton: boolean); overload;

    // Returns true if we have such a service.
    function HasService<T: IInterface>: boolean;

    // Empty the Container.. usefull for testing only!
    procedure Clear;

    property RaiseIfNotFound: boolean read FRaiseIfNotFound
      write FRaiseIfNotFound;
    property ContainerInfo: TDictionary<string, TObject> read FContainerInfo;
  end;

  EIoCException = class(Exception);
  EIoCRegistrationException = class(EIoCException);
  EIoCResolutionException = class(EIoCException);

  // Makes sure virtual constructors are called correctly. Just using a class reference will not call the overriden constructor!
  // See http://stackoverflow.com/questions/791069/how-can-i-create-an-delphi-object-from-a-class-reference-and-ensure-constructor
  TClassActivator = class
  private
    class var FRttiCtx: TRttiContext;
    class constructor Create;
  public
    class function CreateInstance(const AClass: TClass): IInterface;
  end;

function GetInterfaceIID(const I: IInterface; var IID: TGuid): boolean;

implementation

{ TActivator }

class constructor TClassActivator.Create;
begin
  TClassActivator.FRttiCtx := TRttiContext.Create;
end;

class function TClassActivator.CreateInstance(const AClass: TClass): IInterface;
var
  rType: TRttiType;
  method: TRttiMethod;
begin
  result := nil;

  rType := FRttiCtx.GetType(AClass);
  if not(rType is TRttiInstanceType) then
    exit;

  for method in TRttiInstanceType(rType).GetMethods do
  begin
    if method.IsConstructor and (Length(method.GetParameters) = 0) then
    begin
      result := method.Invoke(TRttiInstanceType(rType).MetaclassType, [])
        .AsInterface;
      Break;
    end;
  end;

end;

function TMVCBrIoC.HasService<T>: boolean;
begin
  result := Resolve<T> <> nil;
end;

{$IFDEF DELPHI_XE_UP}

procedure TMVCBrIoC.RegisterType<TInterface, TImplementation>
  (const name: string);
begin
  InternalRegisterType<TInterface>(false, TImplementation, nil, name);
end;

procedure TMVCBrIoC.RegisterType<TInterface, TImplementation>(const singleton
  : boolean; const name: string);
begin
  InternalRegisterType<TInterface>(singleton, TImplementation, nil, name);
end;
{$ENDIF}

procedure TMVCBrIoC.RegisterType<TInterface>(const delegate
  : TActivatorDelegate<TInterface>; const name: string);
begin
  InternalRegisterType<TInterface>(false, nil, delegate, name);
end;

procedure TMVCBrIoC.InternalRegisterType<TInterface>(const singleton: boolean;
  const AImplementation: TClass; const delegate: TActivatorDelegate<TInterface>;
  const name: string = '');
var
  key: string;
  pInfo: PTypeInfo;
  rego: TIoCRegistration<TInterface>;
  o: TObject;
  newName: string;
  newSingleton: boolean;
begin
  newSingleton := singleton;
  newName := name;

  pInfo := TypeInfo(TInterface);
{$IFDEF ANDROID}
  if newName = '' then
    key := pInfo.name.ToString
  else
    key := pInfo.name.ToString + '_' + newName;
{$ELSE}
  if newName = '' then
    key := string(pInfo.name)
  else
    key := string(pInfo.name) + '_' + newName;
{$ENDIF}
  key := LowerCase(key);

  if not FContainerInfo.TryGetValue(key, o) then
  begin
    rego := TIoCRegistration<TInterface>.Create;
    rego.IInterface := pInfo;
    rego.ActivatorDelegate := delegate;
    rego.ImplClass := AImplementation;
    rego.IsSingleton := newSingleton;
    FContainerInfo.Add(key, rego);
  end
  else
  begin
    rego := TIoCRegistration<TInterface>(o);
    // cannot replace a singleton that has already been instanciated.
    if rego.IsSingleton and (rego.Instance <> nil) then
      raise EIoCException.Create
        (Format('An implementation for type %s with name %s is already registered with IoC',
        [pInfo.name, newName]));
    rego.IInterface := pInfo;
    rego.ActivatorDelegate := delegate;
    rego.ImplClass := AImplementation;
    rego.IsSingleton := newSingleton;
    FContainerInfo.AddOrSetValue(key, rego);
  end;
end;

class destructor TMVCBrIoC.ClassDestroy;
begin
  if FDefault <> nil then
    FDefault.Free;
end;

procedure TMVCBrIoC.Clear;
begin
  FContainerInfo.Clear;
end;

constructor TMVCBrIoC.Create;
begin
  FContainerInfo := TDictionary<string, TObject>.Create;
  FRaiseIfNotFound := false;
end;

class function TMVCBrIoC.DefaultContainer: TMVCBrIoC;
begin
  if FDefault = nil then
    FDefault := TMVCBrIoC.Create;

  result := FDefault;
end;

destructor TMVCBrIoC.Destroy;
var
  o: TObject;
begin
  if FContainerInfo <> nil then
  begin
    for o in FContainerInfo.Values do
      if o <> nil then
        o.Free;

    FContainerInfo.Free;
  end;
  inherited;
end;

function TMVCBrIoC.GetInterfaceKey<TInterface>(const AName: string): string;
var
  pInfo: PTypeInfo;
begin
  // By default the key is the interface name unless otherwise found.
  pInfo := TypeInfo(TInterface);
{$IFDEF ANDROID}
  result := pInfo.name.ToString;
{$ELSE}
  result := string(pInfo.name);
{$ENDIF}
  if (AName <> '') then
    result := result + '_' + AName;

  // All keys are stored in lower case form.
  result := LowerCase(result);
end;

function TMVCBrIoC.GetName(AGuid: TGuid): string;
var
  LName: string;
  rogo: TIoCRegistration<IController>;
  achei: string;
begin
  achei := '';
  for LName in FContainerInfo.keys do
  begin
    rogo := TIoCRegistration<IController>(FContainerInfo.items[LName]);
    if rogo.Guid = AGuid then
    begin
      achei := rogo.name;
      Break;
    end;
  end;
  result := achei;
end;

function TMVCBrIoC.InternalResolve<TInterface>(out AInterface: TInterface;
  const AName: string): TResolveResult;
var
  key: string;
  errorMsg: string;
  container: TDictionary<string, TObject>;
  registrationObj: TObject;
  registration: TIoCRegistration<TInterface>;
  resolvedInf: IInterface;
  resolvedObj: TInterface;
  bIsSingleton: boolean;
  bInstanciate: boolean;
begin
  AInterface := Default (TInterface);
  result := TResolveResult.Unknown;

  // Get the key for the interace we are resolving and locate the container for that key.
  key := GetInterfaceKey<TInterface>(AName);
  container := FContainerInfo;

  if not container.TryGetValue(key, registrationObj) then
  begin
    result := TResolveResult.InterfaceNotRegistered;
    exit;
  end;

  // Get the interface registration class correctly.
  registration := TIoCRegistration<TInterface>(registrationObj);
  bIsSingleton := registration.IsSingleton;

  bInstanciate := true;

  if bIsSingleton then
  begin
    // If a singleton was registered with this interface then check if it's already been instanciated.
    if registration.Instance <> nil then
    begin
      // Get AInterface as TInterface
      if registration.Instance.QueryInterface(GetTypeData(TypeInfo(TInterface))
        .Guid, AInterface) <> 0 then
      begin
        result := TResolveResult.ImplNotRegistered;
        exit;
      end;

      bInstanciate := false;
    end;
  end;

  if bInstanciate then
  begin
    // If the instance hasn't been instanciated then we need to lock and instanciate
    MonitorEnter(container);
    try
      // If we have a implementing class then used this to activate.
      if registration.ImplClass <> nil then
        resolvedInf := TClassActivator.CreateInstance(registration.ImplClass)
        // Otherwise if there is a activate delegate use this to activate.
      else if registration.ActivatorDelegate <> nil then
      begin
        resolvedInf := registration.ActivatorDelegate();

        if resolvedInf = nil then
        begin
          result := TResolveResult.DeletegateFailedCreate;
          exit;
        end;
      end;

      // Get AInterface as TInterface
      if resolvedInf.QueryInterface(GetTypeData(TypeInfo(TInterface)).Guid,
        resolvedObj) <> 0 then
      begin
        result := TResolveResult.ImplNotRegistered;
        exit;
      end;

      AInterface := resolvedObj;

      if bIsSingleton then
      begin
        registration.Instance := resolvedObj;

        // Reset the registration to show the instance which was created.
        container.AddOrSetValue(key, registration);
      end;
    finally
      MonitorExit(container);
    end;
  end;
end;

procedure TMVCBrIoC.RegisterSingleton<TInterface>(const Instance: TInterface;
  const name: string);
var
  key: string;
  pInfo: PTypeInfo;
  rego: TIoCRegistration<TInterface>;
  o: TObject;
begin
  pInfo := TypeInfo(TInterface);
  key := GetInterfaceKey<TInterface>(name);

  if not FContainerInfo.TryGetValue(key, o) then
  begin
    rego := TIoCRegistration<TInterface>.Create;
    rego.IInterface := pInfo;
    rego.ActivatorDelegate := nil;
    rego.ImplClass := nil;
    rego.IsSingleton := true;
    rego.Instance := Instance;
    FContainerInfo.Add(key, rego);
  end
  else
    raise EIoCException.Create
      (Format('An implementation for type %s with name %s is already registered with IoC',
      [pInfo.name, name]));
end;

procedure TMVCBrIoC.RegisterInterfaced<TInterface>(AII: TGuid;
  AClass: TInterfacedClass; AName: String; bSingleton: boolean);
var
  Interf: PInterfaceEntry;
  rego: TIoCRegistration<IUnknown>;
  key: string;
begin

  Interf := GetInterfaceEntry(AII);

  key := GetInterfaceKey<TInterface>(AName);

  rego := TIoCRegistration<IUnknown>.Create;
  rego.Guid := AII;
  rego.name := AName;
  rego.IInterface := nil;
  rego.ImplClass := AClass;
  rego.IsSingleton := bSingleton;
  rego.Instance := nil;

  rego.ActivatorDelegate := function: IUnknown
    var
      obj: TInterfacedObject;
    begin
      obj := AClass.Create;
      Supports(obj, AII, result);
    end;
  FContainerInfo.Add(key, rego);

end;

procedure TMVCBrIoC.RegisterType<TInterface>(const singleton: boolean;
  const delegate: TActivatorDelegate<TInterface>; const name: string);
begin
  InternalRegisterType<TInterface>(singleton, nil, delegate, name);
end;

procedure TMVCBrIoC.RevokeInstance(AInstance: IInterface);
var
  LName: string;
  rogo: TIoCRegistration<IUnknown>;
  achei: string;
  AOrigem, ALocal: TObject;
begin
  achei := '';
  AOrigem := AInstance as TObject;
  for LName in FContainerInfo.keys do
  begin
    rogo := TIoCRegistration<IUnknown>(FContainerInfo.items[LName]);
    if assigned(rogo) and assigned(rogo.Instance) and (rogo.IsSingleton) then
    begin
      ALocal := rogo.Instance as TObject;
      if AOrigem.ClassName = ALocal.ClassName then
      begin
        rogo.Instance := nil;
        Break;
      end;
    end;
  end;
end;

function TMVCBrIoC.Resolve<TInterface>(const name: string = ''): TInterface;
var
  resolveResult: TResolveResult;
  errorMsg: string;
  pInfo: PTypeInfo;
begin
  pInfo := TypeInfo(TInterface);
  resolveResult := InternalResolve<TInterface>(result, name);

  // If we don't have a resolution and the caller wants an exception then throw one.
  if (result = nil) and (FRaiseIfNotFound) then
  begin
    case resolveResult of
      TResolveResult.Success:
        ;
      TResolveResult.InterfaceNotRegistered:
        errorMsg := Format('No implementation registered for type %s',
          [pInfo.name]);
      TResolveResult.ImplNotRegistered:
        errorMsg :=
          Format('The Implementation registered for type %s does not actually implement %s',
          [pInfo.name, pInfo.name]);
      TResolveResult.DeletegateFailedCreate:
        errorMsg :=
          Format('The Implementation registered for type %s does not actually implement %s',
          [pInfo.name, pInfo.name]);
    else
      // All other error types are treated as unknown until defined here.
      errorMsg :=
        Format('An Unknown Error has occurred for the resolution of the interface %s %s. This is either because a new error type isn''t being handled, '
        + 'or it''s an bug.', [pInfo.name, name]);
    end;

    raise EIoCResolutionException.Create(errorMsg);
  end;
end;

function GetInterfaceEntry2(const I: IInterface): PInterfaceEntry;
var
  Instance: TObject;
  InterfaceTable: PInterfaceTable;
  j: integer;
  CurrentClass: TClass;
begin
  Instance := I as TObject;
  if assigned(Instance) then
  begin
    CurrentClass := Instance.ClassType;
    while assigned(CurrentClass) do
    begin
      InterfaceTable := CurrentClass.GetInterfaceTable;
      if assigned(InterfaceTable) then
        for j := 0 to InterfaceTable.EntryCount - 1 do
        begin
          result := @InterfaceTable.Entries[j];
          if result.IOffset <> 0 then
          begin
            if Pointer(NativeInt(Instance) + result^.IOffset) = Pointer(I) then
              exit;
          end;
          // TODO: implement checking interface implemented via implements delegation
          // see System.TObject.GetInterface/System.InvokeImplGetter
        end;
      CurrentClass := CurrentClass.ClassParent
    end;
  end;
  result := nil;
end;

function GetInterfaceIID(const I: IInterface; var IID: TGuid): boolean;
var
  InterfaceEntry: PInterfaceEntry;
begin
  InterfaceEntry := GetInterfaceEntry2(I);
  result := assigned(InterfaceEntry);
  if result then
    IID := InterfaceEntry.IID;
end;

end.
