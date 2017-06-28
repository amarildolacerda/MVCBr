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

  TActivatorDelegate<TInterface: IMVCBrIOC> = reference to function
    : TInterface;

  TMVCBrIoC = class
  private
    FRaiseIfNotFound: boolean;

  type
    TIoCRegistration<T: IMVCBrIOC> = class
      FGuid: TGuid;
      FName: string;
      FIInterface: PTypeInfo;
      FImplClass: TClass;
      FActivatorDelegate: TActivatorDelegate<T>;
      FIsSingleton: boolean;
      [unsafe]
      FInstance: IMVCBrIoC;
      Destructor Destroy;override;
      function ImplementClass(AImplements: TInterfacedClass)
        : TIoCRegistration<T>;
      function DelegateTo(const ADelegate: TActivatorDelegate<T>)
        : TIoCRegistration<T>;
      function Singleton(const AValue: boolean): TIoCRegistration<T>;
      function isSingleton: boolean;
      function asGuid: TGuid;
      function asName: String;
      function Name(AName: String): TIoCRegistration<T>;
      function Guid(AGuid: TGuid): TIoCRegistration<T>;
    end;

  private

    FContainerInfo: TDictionary<string, TObject>;
    class var FDefault: TMVCBrIoC;
    class var FReleased: boolean;
    class procedure ClassDestroy;
  protected
    function GetInterfaceKey<TInterface>(const AName: string = ''): string;
    function InternalResolve<TInterface: IMVCBrIOC>(out AInterface: TInterface;
      const AName: string = ''): TResolveResult;
    function InternalRegisterType<TInterface: IMVCBrIOC>(const Singleton
      : boolean; const AImplementation: TClass;
      const Delegate: TActivatorDelegate<TInterface>; const Name: string = '')
      : TIoCRegistration<TInterface>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Release;virtual;
    // Default Container
    class function DefaultContainer: TMVCBrIoC;
{$IFDEF DELPHI_XE_UP}
    // Exe's compiled with D2010 will crash when these are used.
    // NOTES: The issue is due to the two generics included in the functions. The constaints also seem to be an issue.
    procedure RegisterType<TInterface: IMVCBrIOC; TImplementation: class>
      (const Name: string = ''); overload;
    procedure RegisterType<TInterface: IMVCBrIOC; TImplementation: class>
      (const Singleton: boolean; const Name: string = ''); overload;
{$ENDIF}
    procedure RegisterType<TInterface: IMVCBrIOC>(const Delegate
      : TActivatorDelegate<TInterface>; const Name: string = ''); overload;
    procedure RegisterType<TInterface: IMVCBrIOC>(const Singleton: boolean;
      const Delegate: TActivatorDelegate<TInterface>;
      const Name: string = ''); overload;
    function RegisterType<TInterface: IMVCBrIOC>(const AName: String)
      : TIoCRegistration<TInterface>; overload;
    procedure AttachInstance(AInstance: IMVCBrIOC);

    procedure RevokeInstance(AInstance: IInterface);

    // Register an instance as a signleton. If there is more than one instance that implements the interface
    // then use the name parameter
    procedure RegisterSingleton<TInterface: IMVCBrIOC>(const Instance
      : TInterface; const Name: string = '');

    // Resolution
    function Resolve<TInterface: IMVCBrIOC>(const Name: string = '')
      : TInterface;
    function GetName(AGuid: TGuid): string;
    function GetGuid(AName: string): TGuid;

    function RegisterInterfaced<TInterface: IMVCBrIOC>(AII: TGuid;
      AClass: TInterfacedClass; AName: String; bSingleton: boolean)
      : TIoCRegistration<IMVCBrIOC>; overload;

    // Returns true if we have such a service.
    function HasService<T: IMVCBrIOC>: boolean;

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
  public
    constructor Create;
    class function CreateInstance(const AClass: TClass): IInterface;
  end;

function GetInterfaceIID(const I: IInterface; var IID: TGuid): boolean;

implementation

{ TActivator }

constructor TClassActivator.Create;
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
  (const Name: string);
begin
  InternalRegisterType<TInterface>(false, TImplementation, nil, name);
end;

procedure TMVCBrIoC.RegisterType<TInterface, TImplementation>(const Singleton
  : boolean; const Name: string);
begin
  InternalRegisterType<TInterface>(Singleton, TImplementation, nil, name);
end;
{$ENDIF}

procedure TMVCBrIoC.RegisterType<TInterface>(const Delegate
  : TActivatorDelegate<TInterface>; const Name: string);
begin
  InternalRegisterType<TInterface>(false, nil, Delegate, name);
end;

function TMVCBrIoC.InternalRegisterType<TInterface>(const Singleton: boolean;
  const AImplementation: TClass; const Delegate: TActivatorDelegate<TInterface>;
  const Name: string = ''): TIoCRegistration<TInterface>;
var
  key: string;
  pInfo: PTypeInfo;
  rego: TIoCRegistration<TInterface>;
  o: TObject;
  newName: string;
  newSingleton: boolean;
begin
  result := nil;
  newSingleton := Singleton;
  newName := name;

  pInfo := TypeInfo(TInterface);
{$IFDEF ANDROID}
  if newName = '' then
    key := pInfo.Name.ToString
  else
    key := pInfo.Name.ToString + '_' + newName;
{$ELSE}
  if newName = '' then
    key := string(pInfo.Name{$IFDEF LINUX}.ToString{$ENDIF})
  else
    key := string(pInfo.Name{$IFDEF LINUX}.ToString{$ENDIF}) + '_' + newName;
{$ENDIF}
  key := LowerCase(key);

  if not FContainerInfo.TryGetValue(key, o) then
  begin
    rego := TIoCRegistration<TInterface>.Create;
    rego.FIInterface := pInfo;
    rego.FActivatorDelegate := Delegate;
    rego.FImplClass := AImplementation;
    rego.FIsSingleton := newSingleton;
    FContainerInfo.Add(key, rego);
  end
  else
  begin
    rego := TIoCRegistration<TInterface>(o);
    // cannot replace a singleton that has already been instanciated.
    if rego.FIsSingleton and (rego.FInstance <> nil) then
      raise EIoCException.Create
        (Format('An implementation for type %s with name %s is already registered with IoC',
        [pInfo.Name, newName]));
    rego.FIInterface := pInfo;
    rego.FActivatorDelegate := Delegate;
    rego.FImplClass := AImplementation;
    rego.FIsSingleton := newSingleton;
    FContainerInfo.AddOrSetValue(key, rego);
  end;
  result := rego;
end;

class procedure TMVCBrIoC.ClassDestroy;
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
  FReleased := false;
  FContainerInfo := TDictionary<string, TObject>.Create;
  FRaiseIfNotFound := false;
end;

class function TMVCBrIoC.DefaultContainer: TMVCBrIoC;
begin
  result := nil;
  if FReleased then
    exit;

  if FDefault = nil then
    FDefault := TMVCBrIoC.Create;
  result := FDefault;
end;

destructor TMVCBrIoC.Destroy;
var
  o: TObject;
  rego: TIoCRegistration<IMVCBrIOC>;
begin
  if FContainerInfo <> nil then
  begin
    for o in FContainerInfo.Values do
      if o <> nil then
      begin
        rego := TIoCRegistration<IMVCBrIOC>(o);
        o.Free;
      end;
    FContainerInfo.Free;
    FContainerInfo := nil;
  end;
  FReleased := true;
  inherited;
end;

function TMVCBrIoC.GetInterfaceKey<TInterface>(const AName: string): string;
var
  pInfo: PTypeInfo;
begin
  // By default the key is the interface name unless otherwise found.
  pInfo := TypeInfo(TInterface);
{$IFDEF ANDROID}
  result := pInfo.Name.ToString;
{$ELSE}
  result := string(pInfo.Name{$IFDEF LINUX}.ToString{$ENDIF});
{$ENDIF}
  if (AName <> '') then
    result := result + '_' + AName;

  // All keys are stored in lower case form.
  result := LowerCase(result);
end;

function TMVCBrIoC.GetGuid(AName: string): TGuid;
var
  LName: string;
  rogo: TIoCRegistration<IMVCBrIOC>;
begin
  for LName in FContainerInfo.keys do
    if LName.ToUpper.Equals(AName.ToUpper) then
    begin
      rogo := TIoCRegistration<IMVCBrIOC>(FContainerInfo.items[LName]);
      result := rogo.FGuid;
    end;
end;

function TMVCBrIoC.GetName(AGuid: TGuid): string;
var
  LName: string;
  rogo: TIoCRegistration<IMVCBrIOC>;
  achei: string;
begin
  achei := '';
  for LName in FContainerInfo.keys do
  begin
    rogo := TIoCRegistration<IMVCBrIOC>(FContainerInfo.items[LName]);
    if rogo.FGuid = AGuid then
    begin
      achei := rogo.FName;
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
  //container: TDictionary<string, TObject>;
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
  //container := FContainerInfo;

  if not FContainerInfo.TryGetValue(key, registrationObj) then
  begin
    result := TResolveResult.InterfaceNotRegistered;
    exit;
  end;

  // Get the interface registration class correctly.
  registration := TIoCRegistration<TInterface>(registrationObj);
  bIsSingleton := registration.FIsSingleton;

  bInstanciate := true;

  if bIsSingleton then
  begin
    // If a singleton was registered with this interface then check if it's already been instanciated.
    if registration.FInstance <> nil then
    begin
      // Get AInterface as TInterface
      if registration.FInstance.QueryInterface(GetTypeData(TypeInfo(TInterface))
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
    MonitorEnter(FContainerInfo);
    try
      // If we have a implementing class then used this to activate.
      if registration.FImplClass <> nil then
        resolvedInf := TClassActivator.CreateInstance(registration.FImplClass)
        // Otherwise if there is a activate delegate use this to activate.
      else if registration.FActivatorDelegate <> nil then
      begin
        resolvedInf := registration.FActivatorDelegate();

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
        registration.FInstance := resolvedObj;

        // Reset the registration to show the instance which was created.
        FContainerInfo.AddOrSetValue(key, registration);
      end;
    finally
      MonitorExit(FContainerInfo);
    end;
  end;
end;

procedure TMVCBrIoC.RegisterSingleton<TInterface>(const Instance: TInterface;
  const Name: string);
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
    rego.FIInterface := pInfo;
    rego.FActivatorDelegate := nil;
    rego.FImplClass := nil;
    rego.FIsSingleton := true;
    rego.FInstance := Instance;
    FContainerInfo.Add(key, rego);
  end
  else
    raise EIoCException.Create
      (Format('An implementation for type %s with name %s is already registered with IoC',
      [pInfo.Name, name]));
end;

function TMVCBrIoC.RegisterInterfaced<TInterface>(AII: TGuid;
  AClass: TInterfacedClass; AName: String; bSingleton: boolean)
  : TIoCRegistration<IMVCBrIOC>;
var
  Interf: PInterfaceEntry;
  rego: TIoCRegistration<IMVCBrIOC>;
  key: string;
begin

  Interf := GetInterfaceEntry(AII);

  key := GetInterfaceKey<TInterface>(AName);

  rego := TIoCRegistration<IMVCBrIOC>.Create;
  rego.FGuid := AII;
  rego.FName := AName;
  rego.FIInterface := nil;
  rego.FImplClass := AClass;
  rego.FIsSingleton := bSingleton;
  rego.FInstance := nil;

  rego.FActivatorDelegate := function: IMVCBrIOC
    var
      obj: TInterfacedObject;
    begin
      obj := AClass.Create;
      Supports(obj, AII, result);
    end;
  FContainerInfo.Add(key, rego);

  result := rego;

end;

procedure TMVCBrIoC.RegisterType<TInterface>(const Singleton: boolean;
  const Delegate: TActivatorDelegate<TInterface>; const Name: string);
begin
  InternalRegisterType<TInterface>(Singleton, nil, Delegate, name);
end;

procedure TMVCBrIoC.RevokeInstance(AInstance: IInterface);
var
  LName: string;
  rogo: TIoCRegistration<IMVCBrIOC>;
  achei: string;
  AOrigem, ALocal: TObject;
begin
  if FReleased then
     exit;
  achei := '';
  AOrigem := AInstance as TObject;
  for LName in FContainerInfo.keys do
  begin
    rogo := TIoCRegistration<IMVCBrIOC>(FContainerInfo.items[LName]);
    if assigned(rogo) and assigned(rogo.FInstance) and (rogo.FIsSingleton) then
    begin
      ALocal := rogo.FInstance as TObject;
      if AOrigem.ClassName = ALocal.ClassName then
      begin
        rogo.FInstance := nil;
        Break;
      end;
    end;
  end;
end;

function TMVCBrIoC.Resolve<TInterface>(const Name: string = ''): TInterface;
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
          [pInfo.Name]);
      TResolveResult.ImplNotRegistered:
        errorMsg :=
          Format('The Implementation registered for type %s does not actually implement %s',
          [pInfo.Name, pInfo.Name]);
      TResolveResult.DeletegateFailedCreate:
        errorMsg :=
          Format('The Implementation registered for type %s does not actually implement %s',
          [pInfo.Name, pInfo.Name]);
    else
      // All other error types are treated as unknown until defined here.
      errorMsg :=
        Format('An Unknown Error has occurred for the resolution of the interface %s %s. This is either because a new error type isn''t being handled, '
        + 'or it''s an bug.', [pInfo.Name, name]);
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

function TMVCBrIoC.RegisterType<TInterface>(const AName: String)
  : TIoCRegistration<TInterface>;
var
  Interf: PInterfaceEntry;
  key: string;
begin

  key := GetInterfaceKey<TInterface>(AName);

  result := TIoCRegistration<TInterface>.Create;
  result.FName := AName;
  result.FIInterface := nil;
  result.FIsSingleton := true;
  result.FInstance := nil;

  FContainerInfo.Add(key, result);

end;


procedure TMVCBrIoC.Release;
var
  o: TObject;
  rogo: TIoCRegistration<IMVCBrIOC>;
  resolvedObj: TObject;
begin
  for o in FContainerInfo.values do
  begin
    rogo := TIoCRegistration<IMVCBrIOC>(o);
    if assigned(rogo.FInstance) then
       rogo.FInstance.release;
    rogo.FInstance := nil;
  end;
end;

procedure TMVCBrIoC.AttachInstance(AInstance: IMVCBrIOC);
var
  o: TObject;
  rogo: TIoCRegistration<IMVCBrIOC>;
  resolvedObj: TObject;

begin
  for o in FContainerInfo.values do
  begin
    rogo := TIoCRegistration<IMVCBrIOC>(o);
    resolvedObj := AInstance as TObject;
    if (not assigned(rogo.FInstance)) and assigned(rogo.FImplClass) and
      (sametext(rogo.FImplClass.ClassName, resolvedObj.ClassName)) and
      (rogo.isSingleton) then
    begin
      rogo.FInstance := AInstance;
      break;
    end;
  end;
end;



{ TMVCBrIoC.TIoCRegistration<T> }

function TMVCBrIoC.TIoCRegistration<T>.asGuid: TGuid;
begin
  result := FGuid;
end;

function TMVCBrIoC.TIoCRegistration<T>.asName: String;
begin
  result := FName;
end;

function TMVCBrIoC.TIoCRegistration<T>.DelegateTo(const ADelegate
  : TActivatorDelegate<T>): TIoCRegistration<T>;
begin
  result := self;
  FActivatorDelegate := ADelegate;
end;

destructor TMVCBrIoC.TIoCRegistration<T>.Destroy;
begin
  if assigned(FInstance) then
    FInstance.release;
  FInstance := nil;
  inherited;
end;

function TMVCBrIoC.TIoCRegistration<T>.Guid(AGuid: TGuid): TIoCRegistration<T>;
begin
  result := self;
  FGuid := AGuid;
end;

function TMVCBrIoC.TIoCRegistration<T>.ImplementClass
  (AImplements: TInterfacedClass): TIoCRegistration<T>;
begin
  result := self;

  FActivatorDelegate := function: T
    var
      obj: TInterfacedObject;
    begin
      obj := AImplements.Create;
      Supports(obj, FGuid, result);
    end;

  FImplClass := AImplements;

end;

function TMVCBrIoC.TIoCRegistration<T>.isSingleton: boolean;
begin
  result := FIsSingleton;
end;

function TMVCBrIoC.TIoCRegistration<T>.Name(AName: String): TIoCRegistration<T>;
begin
  result := self;
  FName := AName;
end;

function TMVCBrIoC.TIoCRegistration<T>.Singleton(const AValue: boolean)
  : TIoCRegistration<T>;
begin
  FIsSingleton := AValue;
  result := self;
end;

initialization

finalization

 TMVCBrIoC.ClassDestroy;

end.
