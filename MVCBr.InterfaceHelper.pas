{
  Auth:  http://stackoverflow.com/questions/39584234/how-to-obtain-rtti-from-an-interface-reference-in-delphi
}
unit MVCBr.InterfaceHelper;

interface

{$DEFINE DUNITX}
{$IFDEF VER330}
{$UNDEF DUNITX}
{$ENDIF}

uses System.Rtti, System.TypInfo, System.Generics.Collections, System.SysUtils;

{$IFNDEF BPL}

type
  TInterfaceHelper = record
  strict private
  type
    TInterfaceTypes = TDictionary<TGUID, TRttiInterfaceType>;

    class var FInterfaceTypes: TInterfaceTypes;
    class var Cached: Boolean;
    class var Caching: Boolean;
    class procedure WaitIfCaching; static;
    class procedure CacheIfNotCachedAndWaitFinish; static;
    class constructor Create;
    class destructor Destroy;
  public
    // refresh cached RTTI in a background thread  (eg. when new package is loaded)
    class procedure RefreshCache; static;

    // get RTTI from interface
    class function GetType(AIntf: IInterface): TRttiInterfaceType;
      overload; static;
    class function GetType(AGUID: TGUID): TRttiInterfaceType; overload; static;
    class function GetType(AIntfInTValue: TValue): TRttiInterfaceType;
      overload; static;

    // get type name from interface
    class function GetTypeName(AIntf: IInterface): String; overload; static;
    class function GetTypeName(AGUID: TGUID): String; overload; static;
    class function GetQualifiedName(AIntf: IInterface): String;
      overload; static;
    class function GetQualifiedName(AGUID: TGUID): String; overload; static;

    // get methods
    class function GetMethods(AIntf: IInterface): TArray<TRttiMethod>; static;
    class function GetMethod(AIntf: IInterface; const MethodName: String)
      : TRttiMethod; static;

    // Invoke method
    class function InvokeMethod(AIntf: IInterface; const MethodName: String;
      const Args: array of TValue): TValue; overload; static;
    class function InvokeMethod(AIntfInTValue: TValue; const MethodName: String;
      const Args: array of TValue): TValue; overload; static;
  end;
{$ENDIF}

implementation

{$IFNDEF BPL}

uses System.Classes,
  System.SyncObjs {$IFDEF DUNITX}, DUnitX.Utils{$ENDIF};

{ TInterfaceHelper }

class function TInterfaceHelper.GetType(AIntf: IInterface): TRttiInterfaceType;
var
  ImplObj: TObject;
  LGUID: TGUID;
  LIntfType: TRttiInterfaceType;
  TempIntf: IInterface;
begin
  Result := nil;

  try
    // As far as I know, the cast will fail only when AIntf is obatined from OLE Object
    // Is there any other cases?
    ImplObj := AIntf as TObject;
  except
    // for interfaces obtained from OLE Object
    Result := TRttiContext.Create.GetType(TypeInfo(System.IDispatch))
      as TRttiInterfaceType;
    Exit;
  end;

{$IFDEF DUNITX}
  // for interfaces obtained from TRawVirtualClass (for exmaple IOS & Android & Mac interfaces)
  if ImplObj.ClassType.InheritsFrom(TRawVirtualClass) then
  begin
    LGUID := ImplObj.GetField('FIIDs').GetValue(ImplObj).AsType < TArray <
      TGUID >> [0];
    Result := GetType(LGUID);
  end
  // for interfaces obtained from TVirtualInterface
  else if ImplObj.ClassType.InheritsFrom(TVirtualInterface) then
  begin
    LGUID := ImplObj.GetField('FIID').GetValue(ImplObj).AsType<TGUID>;
    Result := GetType(LGUID);
  end
  else {$ENDIF}
  // for interfaces obtained from Delphi object
  // The code is taken from Remy Lebeau's answer at http://stackoverflow.com/questions/39584234/how-to-obtain-rtti-from-an-interface-reference-in-delphi/
  begin
    for LIntfType in (TRttiContext.Create.GetType(ImplObj.ClassType)
      as TRttiInstanceType).GetImplementedInterfaces do
    begin
      if ImplObj.GetInterface(LIntfType.GUID, TempIntf) then
      begin
        if AIntf = TempIntf then
        begin
          Result := LIntfType;
          Exit;
        end;
      end;
    end;
  end;
end;

class constructor TInterfaceHelper.Create;
begin
  if not assigned(FInterfaceTypes) then
    FInterfaceTypes := TInterfaceTypes.Create;
  Cached := False;
  Caching := False;
  RefreshCache;
end;

class destructor TInterfaceHelper.Destroy;
begin
  if assigned(FInterfaceTypes) then
    FInterfaceTypes.Free;
  FInterfaceTypes := nil;
end;

class function TInterfaceHelper.GetQualifiedName(AIntf: IInterface): String;
var
  LType: TRttiInterfaceType;
begin
  Result := string.Empty;
  LType := GetType(AIntf);
  if assigned(LType) then
    Result := LType.QualifiedName;
end;

class function TInterfaceHelper.GetMethod(AIntf: IInterface;
  const MethodName: String): TRttiMethod;
var
  LType: TRttiInterfaceType;
begin
  Result := nil;
  LType := GetType(AIntf);
  if assigned(LType) then
    Result := LType.GetMethod(MethodName);
end;

class function TInterfaceHelper.GetMethods(AIntf: IInterface)
  : TArray<TRttiMethod>;
var
  LType: TRttiInterfaceType;
begin
  Result := [];
  LType := GetType(AIntf);
  if assigned(LType) then
    Result := LType.GetMethods;
end;

class function TInterfaceHelper.GetQualifiedName(AGUID: TGUID): String;
var
  LType: TRttiInterfaceType;
begin
  Result := string.Empty;
  LType := GetType(AGUID);
  if assigned(LType) then
    Result := LType.QualifiedName;
end;

class function TInterfaceHelper.GetType(AGUID: TGUID): TRttiInterfaceType;
begin
  CacheIfNotCachedAndWaitFinish;
  Result := FInterfaceTypes.Items[AGUID];
end;

class function TInterfaceHelper.GetTypeName(AGUID: TGUID): String;
var
  LType: TRttiInterfaceType;
begin
  Result := string.Empty;
  LType := GetType(AGUID);
  if assigned(LType) then
    Result := LType.Name;
end;

class function TInterfaceHelper.InvokeMethod(AIntfInTValue: TValue;
  const MethodName: String; const Args: array of TValue): TValue;
var
  LMethod: TRttiMethod;
  LType: TRttiInterfaceType;
begin
  LType := GetType(AIntfInTValue);
  if assigned(LType) then
    LMethod := LType.GetMethod(MethodName);
  if not assigned(LMethod) then
    raise Exception.Create('Method not found');
  Result := LMethod.Invoke(AIntfInTValue, Args);
end;

class function TInterfaceHelper.InvokeMethod(AIntf: IInterface;
  const MethodName: String; const Args: array of TValue): TValue;
var
  LMethod: TRttiMethod;
begin
  LMethod := GetMethod(AIntf, MethodName);
  if not assigned(LMethod) then
    raise Exception.Create('Method not found');
  Result := LMethod.Invoke(TValue.From<IInterface>(AIntf), Args);
end;

class function TInterfaceHelper.GetTypeName(AIntf: IInterface): String;
var
  LType: TRttiInterfaceType;
begin
  Result := string.Empty;
  LType := GetType(AIntf);
  if assigned(LType) then
    Result := LType.Name;
end;

class procedure TInterfaceHelper.RefreshCache;
var
  LTypes: TArray<TRttiType>;
begin
  WaitIfCaching;

  FInterfaceTypes.Clear;
  Cached := False;
  Caching := True;
{$IFNDEF SERVICE}
  TThread.CreateAnonymousThread(
    procedure
    var
      LType: TRttiType;
      LIntfType: TRttiInterfaceType;
    begin
      LTypes := TRttiContext.Create.GetTypes;

      try
        for LType in LTypes do
        begin
          if TThread.Current.CheckTerminated = False then
          begin
            if LType.TypeKind = TTypeKind.tkInterface then
            begin
              LIntfType := (LType as TRttiInterfaceType);
              if TIntfFlag.ifHasGuid in LIntfType.IntfFlags then
              begin
                FInterfaceTypes.AddOrSetValue(LIntfType.GUID, LIntfType);
              end;
            end;
          end;
        end;
      except
      end;

      Caching := False;
      Cached := True;
    end).Start;
{$ENDIF}
end;

class procedure TInterfaceHelper.WaitIfCaching;
begin
  if Caching then
    TSpinWait.SpinUntil(
      function: Boolean
      begin
        Result := Cached;
      end);
end;

class procedure TInterfaceHelper.CacheIfNotCachedAndWaitFinish;
begin
  if Cached then
    Exit
  else if not Caching then
  begin
    RefreshCache;
    WaitIfCaching;
  end
  else
    WaitIfCaching;
end;

class function TInterfaceHelper.GetType(AIntfInTValue: TValue)
  : TRttiInterfaceType;
var
  LType: TRttiType;
begin
  Result := nil;
  {$ifdef DUNITX}
  LType := AIntfInTValue.RttiType;
  {$ENDIF}
  if LType is TRttiInterfaceType then
    Result := LType as TRttiInterfaceType;
end;
{$ENDIF}

end.
