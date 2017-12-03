{ *************************************************************************** }
{ }
{ }
{ Copyright (C) Amarildo Lacerda }
{ }
{ https://github.com/amarildolacerda }
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
unit System.Classes.Helper;

interface

uses System.Classes, System.SysUtils,
  System.Rtti,
  System.Generics.Collections,
  System.TypInfo, System.Json;

const
  ObjAdapterGUID: TGUID = '{09B8DF51-13F9-478C-B592-3B73E65F8698}';

Type

  HideAttribute = class(TCustomAttribute)
  end;

  IFireEventProc = interface
    ['{BBC08E72-6518-4BF8-8BEE-0A46FD8B351C}']
    procedure SetOnEvent(const Value: TProc<TObject>);

    procedure FireEvent(Sender: TObject);
  end;

  IObjectAdapter<T: Class> = interface(TFunc<T>)
    ['{17EB68E7-7212-4AE9-B686-FC4CC3A08F07}']
    property Instance: T read Invoke;
    procedure Null;
    procedure Release;
  end;

  TObjectAdapter<T: Class> = class(TInterfacedObject, IObjectAdapter<T>,
    IInterface)
  private
    FCreated: Boolean;
    FDelegate: TFunc<T>;
    FClass: TClass;
    [weak]
    FInstance: T;
    procedure Initialize;
    function Invoke: T;
    function QueryInterface(const AIID: TGUID; out Obj): HResult;
  public
    constructor Create; overload; virtual;
    constructor Create(AClass: T); overload; virtual;
    Destructor Destroy; override;
    procedure Null;
    procedure Release; virtual;
    [weak]
    class function New: IObjectAdapter<T>; overload;
    [weak]
    class function New(Obj: TObject): IObjectAdapter<T>; overload;
    [weak]
    function InstanceOf(AClass: TClass): IObjectAdapter<T>;
    [weak]
    function DelegateTo(AFunc: TFunc<T>): IObjectAdapter<T>;
  end;

  TStringsHelper = Class helper for TStrings
  public
    Function Items: TStrings;
  end;

  TObjectExt = class(System.TObject)
  private
    FOnFireEvent: TProc<TObject>;
    procedure SetOnFireEvent(const Value: TProc<TObject>);
  public
    procedure FireEvent; overload;
    procedure FireEvent(Sender: TObject); overload;
    property OnFireEvent: TProc<TObject> read FOnFireEvent write SetOnFireEvent;
  end;

  TCustomAttributeClass = class of TCustomAttribute;
  TMemberVisibilitySet = set of TMemberVisibility;

  TValueNamed = record
    name: string;
    Value: TValue;
  end;

  TObjectHelper = class helper for TObject
  private
    function GetContextProperties(AName: string): TValue;
    procedure SetContextProperties(AName: string; const Value: TValue);
    function GetContextFields(AName: string): TValue;
    procedure SetContextFields(AName: string; const Value: TValue);
    function GetContextMethods(AName: String): TRttiMethod;
  public
    // metodos anonimous
    class procedure Using<T>(O: T; Proc: TProc<T>); static;
    class function Anonymous<T: Class>(O: T; Proc: TProc<T>): TObject; static;
    class procedure Run<T: Class>(O: T; Proc: TProc<T>); overload; static;
    class procedure Run(Proc: TProc); overload; static;
    class procedure WaitFor<T: Class>(O: T; Proc: TProc<T>); overload; static;
    class procedure WaitFor(Proc: TProc); overload; static;
    class function Queue<T: Class>(O: T; Proc: TProc<T>): TObject;
      overload; static;
    class procedure Queue(Proc: TProc); overload; static;
    class function Synchronize<T: Class>(O: T; Proc: TProc<T>): TObject;
      overload; static;
    class procedure Synchronize(Proc: TProc); overload; static;
    class procedure RunQueue(Proc: TProc); static;

    // JSON
    function ToJson: string; overload;
    function ToJsonObject: TJsonObject; overload;
    procedure FromJson(AJson: string); overload;
    function Clone: System.TObject;
    class function FromJson<T: Class, constructor>(AJson: string): T;
      overload; static;

    // RTTI
    procedure CopyFrom(Obj: TObject;
      const AVisibility: TMemberVisibilitySet = [mvPublished]);
    procedure CopyTo(Obj: TObject);
    function ContextPropertyCount: Integer;
    function ContextPropertyName(idx: Integer): string;
    property ContextProperties[AName: string]: TValue read GetContextProperties
      write SetContextProperties;
    function IsContextProperty(AName: String): Boolean;
    procedure GetContextPropertiesList(AList: TStrings;
      const AVisibility: TMemberVisibilitySet = [mvPublished, mvPublic]);
    procedure GetContextPropertiesItems(AList: TStrings;
      const AVisibility: TMemberVisibilitySet = [mvPublished, mvPublic]);

    function &ContextFieldsCount: Integer;
    function &ContextFieldName(idx: Integer): string;
    property ContextFields[AName: string]: TValue read GetContextFields
      write SetContextFields;
    procedure &ContextGetFieldsList(AList: TStrings;
      const AVisibility: TMemberVisibilitySet = [mvPublic]);

    class procedure &ContextGetRecordFieldsList<T: Record >(AStrings: TStrings;
      ARec: T; const AVisibility: TMemberVisibilitySet = [mvPublic];
      AFunc: TFunc < string, Boolean >= nil); static;
    class procedure &ContextRecordValuesList<T: Record >
      (AList: TList<TValueNamed>; ARec: T); static;
    class function GetRecordValue<T: Record >(rec: T; aNome: string)
      : TValue; static;

    property ContextMethods[AName: String]: TRttiMethod read GetContextMethods;
    procedure GetContextMethodsList(AList: TStrings;
      const AVisibility: TMemberVisibilitySet = [mvPublic]);

    function ContextHasAttribute(aMethod: TRttiMethod;
      attribClass: TCustomAttributeClass): Boolean;

    function ContextInvokeAttribute(attribClass: TCustomAttributeClass;
      params: array of TValue): Boolean;
    function ContextInvokeMethod(AName: string;
      params: array of TValue): TValue;
  end;

  TTaskList = class(TThreadList)
  private
    FMaxThread: Integer;
    procedure SetMaxThread(const Value: Integer);
  public
    constructor Create;
    procedure DoDestroyThread(Value: TObject);
    procedure Run(Proc: TProc);
    property MaxThread: Integer read FMaxThread write SetMaxThread;
  end;

  TStingListHelper = Class helper for TStringList
  public
{$IF compilerVersion<32}
    procedure addPair(AName, AValue: String);
{$ENDIF}
    class function New(AText: string; ADelimiter: char = ','): TStringList;
    function AsJsonArray: TJsonArray;
    function AsJsonObject: TJsonObject;
    function ToJson: string;
    function FromJson(AJson: String): TStringList;
  end;

implementation

uses {$IF CompilerVersion>28} System.Threading, {$ENDIF}
{$IFNDEF BPL}
  REST.Json,
{$ENDIF}
  System.DateUtils;

class procedure TObjectHelper.Using<T>(O: T; Proc: TProc<T>);
var
  Obj: TObject;
begin
  try
    Proc(O);
  finally
    freeAndNil(O);
  end;
end;

class procedure TObjectHelper.WaitFor(Proc: TProc);
begin
  TObject.WaitFor<TObject>(nil,
    procedure(Sender: TObject)
    begin
      Proc;
    end);
end;

class procedure TObjectHelper.WaitFor<T>(O: T; Proc: TProc<T>);
var
  th: {$IF CompilerVersion>28} ITask; {$ELSE} TThread; {$ENDIF}
begin
  th := {$IF CompilerVersion>28}TTask.Create{$ELSE} TThread.
    CreateAnonymousThread{$ENDIF}
    (
    procedure
    begin
      Proc(O);
    end);
  th.Start;
{$IF CompilerVersion>28}
  th.Wait();
{$ELSE}
  th.WaiFor();
{$ENDIF}
end;

procedure TObjectExt.FireEvent;
begin
  FireEvent(self);
end;

function TObjectHelper.&ContextFieldName(idx: Integer): string;
var
  aCtx: TRttiContext;
begin
  aCtx := TRttiContext.Create;
  try
    result := aCtx.GetType(self.ClassType).GetFields[idx].name;
  finally
    aCtx.Free;
  end;
end;

function TObjectHelper.&ContextFieldsCount: Integer;
var
  aCtx: TRttiContext;
begin
  aCtx := TRttiContext.Create;
  try
    result := High(aCtx.GetType(self.ClassType).GetFields);
  finally
    aCtx.Free;
  end;
end;

procedure TObjectHelper.FromJson(AJson: string);
var
  oJs: TJsonObject;
  lst: TStringList;
  pair: TJsonPair;
  s: string;
begin
{$IFNDEF BPL}
  oJs := TJsonObject.ParseJSONValue(AJson) as TJsonObject;
  lst := TStringList.Create;
  try
    for pair in oJs do
    begin
      ContextProperties[pair.JsonString.Value] := pair.JsonValue.Value;
      ContextFields[pair.JsonString.Value] := pair.JsonValue.Value;
    end;
  finally
    lst.Free;
  end;
{$ENDIF}
end;

function TObjectHelper.Clone: System.TObject;
var
  oJs: TJsonObject;
begin
{$IFNDEF BPL}
  oJs := TJsonObject.ParseJSONValue(ToJson) as TJsonObject;
  TJson.JsonToObject(self, oJs);
{$ENDIF}
  result := self;
end;

class function TObjectHelper.FromJson<T>(AJson: string): T;
begin
{$IFNDEF BPL}
  result := TJson.JsonToObject<T>(AJson);
{$ENDIF}
end;

function TObjectHelper.GetContextFields(AName: string): TValue;
var
  aCtx: TRttiContext;
  AField: TRttiField;
begin
  result := nil;
  aCtx := TRttiContext.Create;
  try
    AField := aCtx.GetType(self.ClassType).GetField(AName);
    if assigned(AField) then
      result := AField.GetValue(self);
  finally
    aCtx.Free;
  end;
end;

procedure TObjectHelper.&ContextGetFieldsList(AList: TStrings;
const AVisibility: TMemberVisibilitySet = [mvPublic]);
var
  aCtx: TRttiContext;
  AFld: TRttiField;
  LAttr: TCustomAttribute;
  LTemAtributo: Boolean;
begin
  AList.clear;
  aCtx := TRttiContext.Create;
  try
    for AFld in aCtx.GetType(self.ClassType).GetFields do
    begin
      if AFld.Visibility in AVisibility then
      begin
        LTemAtributo := false;
        for LAttr in AFld.GetAttributes do
          if LAttr is HideAttribute then
            LTemAtributo := true; // é um Field [HIDE]
        if not LTemAtributo then
          AList.Add(AFld.name);
      end;
    end;
  finally
    aCtx.Free;
  end;
end;

class procedure TObjectHelper.&ContextGetRecordFieldsList<T>(AStrings: TStrings;
ARec: T; const AVisibility: TMemberVisibilitySet = [mvPublic];
AFunc: TFunc < string, Boolean >= nil);
var
  AContext: TRttiContext;
  ARecord: TRttiRecordType;
  AField: TRttiField;
  AJsonValue: TJsonPair;
  AValue: TValue;
  AFieldName: String;
  j: TJsonObject;
  APair: TJsonPair;
  LAttr: TCustomAttribute;
  LContinue: Boolean;
begin
  AContext := TRttiContext.Create;
  try
    ARecord := AContext.GetType(TypeInfo(T)).AsRecord;
    for AField in ARecord.GetFields do
    begin
      if AField.Visibility in AVisibility then
      begin
        LContinue := true;

        for LAttr in AField.GetAttributes do
          if LAttr is HideAttribute then
            LContinue := false; // é um Field [HIDE]

        if assigned(AFunc) and LContinue then
          LContinue := AFunc(AField.name);

        if LContinue then
          AStrings.Add(lowercase(AField.name));
      end;
    end;
  finally
    AContext.Free;
  end;
end;

Class function TObjectHelper.GetRecordValue<T>(rec: T; aNome: string): TValue;
var
  LContext: TRttiContext;
  LRecord: TRttiRecordType;
  LField: TRttiField;
begin
  LContext := TRttiContext.Create;
  try
    LRecord := LContext.GetType(TypeInfo(T)).AsRecord;
    for LField in LRecord.GetFields do
    begin
      if sameText(LField.name, aNome) then
      begin
        result := LField.GetValue(@rec);
        exit;
      end;
    end;
  finally
    LContext.Free;
  end;
end;

function TObjectHelper.GetContextMethods(AName: String): TRttiMethod;
var
  aCtx: TRttiContext;
begin
  aCtx := TRttiContext.Create;
  try
    result := aCtx.GetType(self.ClassType).GetMethod(AName);
  finally
    // ACtx.Free;
  end;
end;

procedure TObjectHelper.GetContextMethodsList(AList: TStrings;
const AVisibility: TMemberVisibilitySet = [mvPublic]);
var
  aMethod: TRttiMethod;
  aCtx: TRttiContext;
  LAttr: TCustomAttribute;
  LTemAtributo: Boolean;
begin
  AList.clear;
  aCtx := TRttiContext.Create;
  try
    for aMethod in aCtx.GetType(self.ClassType).GetMethods do
    begin
      if aMethod.Visibility in AVisibility then
      begin
        LTemAtributo := false;
        for LAttr in aMethod.GetAttributes do
          if LAttr is HideAttribute then
            LTemAtributo := true; // é um Field [HIDE]
        if not LTemAtributo then
          AList.Add(aMethod.name);
      end;
    end;
  finally
    aCtx.Free;
  end;
end;

function TObjectHelper.GetContextProperties(AName: string): TValue;
var
  aCtx: TRttiContext;
  aProperty: TRttiProperty;
begin
  result := nil;
  aCtx := TRttiContext.Create;
  try
    aProperty := aCtx.GetType(self.ClassType).GetProperty(AName);
    if assigned(aProperty) then
      result := aProperty.GetValue(self);
  finally
    aCtx.Free;
  end;
end;

type
  // Adiciona funções ao TValue
  TValueHelper = record helper for TValue
  private
    function IsNumeric: Boolean;
    function IsFloat: Boolean;
    function AsFloat: Extended;
    function IsBoolean: Boolean;
    function IsDate: Boolean;
    function IsDateTime: Boolean;
    function IsDouble: Boolean;
    function AsDouble: Double;
    function IsInteger: Boolean;
  end;

function TValueHelper.IsNumeric: Boolean;
begin
  result := Kind in [tkInteger, tkChar, tkEnumeration, tkFloat,
    tkWChar, tkInt64];
end;

function TValueHelper.IsFloat: Boolean;
begin
  result := Kind = tkFloat;
end;

function TValueHelper.IsBoolean: Boolean;
begin
  result := TypeInfo = System.TypeInfo(Boolean);
end;

function TValueHelper.IsDate: Boolean;
begin
  result := TypeInfo = System.TypeInfo(TDate);
end;

function TValueHelper.IsDateTime: Boolean;
begin
  result := TypeInfo = System.TypeInfo(TDatetime);
end;

function TValueHelper.IsDouble: Boolean;
begin
  result := TypeInfo = System.TypeInfo(Double);
end;

function TValueHelper.IsInteger: Boolean;
begin
  result := TypeInfo = System.TypeInfo(Integer);
end;

function TValueHelper.AsFloat: Extended;
begin
  result := AsType<Extended>;
end;

function TValueHelper.AsDouble: Double;
begin
  result := AsType<Double>;
end;

function ISODateTimeToString(ADateTime: TDatetime): string;
begin
  result := DateToISO8601(ADateTime);
end;

function ISOStrToDateTime(DateTimeAsString: string): TDatetime;
begin
  TryISO8601ToDate(DateTimeAsString, result);
end;

procedure TObjectHelper.GetContextPropertiesItems(AList: TStrings;
const AVisibility: TMemberVisibilitySet);
var
  aCtx: TRttiContext;
  aProperty: TRttiProperty;
  aRtti: TRttiType;
  AValue: TValue;
begin
  AList.clear;
  aCtx := TRttiContext.Create;
  try
    aRtti := aCtx.GetType(self.ClassType);
    for aProperty in aRtti.GetProperties do
    begin
      if aProperty.Visibility in AVisibility then
      begin
        AValue := aProperty.GetValue(self);
        if AValue.IsDate or AValue.IsDateTime then
          AList.Add(aProperty.name + '=' + ISODateTimeToString(AValue.AsDouble))
        else if AValue.IsBoolean then
          AList.Add(aProperty.name + '=' + ord(AValue.AsBoolean).ToString)
        else
          AList.Add(aProperty.name + '=' + AValue.ToString);
      end;
    end;
  finally
    aCtx.Free;
  end;

end;

procedure TObjectHelper.GetContextPropertiesList(AList: TStrings;
const AVisibility: TMemberVisibilitySet = [mvPublished, mvPublic]);
var
  aCtx: TRttiContext;
  aProperty: TRttiProperty;
  aRtti: TRttiType;
begin

  AList.clear;
  aCtx := TRttiContext.Create;
  try
    aRtti := aCtx.GetType(self.ClassType);
    for aProperty in aRtti.GetProperties do
    begin
      if aProperty.Visibility in AVisibility then
        AList.Add(aProperty.name);
    end;
  finally
    aCtx.Free;
  end;

end;

function TObjectHelper.ContextHasAttribute(aMethod: TRttiMethod;
attribClass: TCustomAttributeClass): Boolean;
var
  attributes: TArray<TCustomAttribute>;
  attrib: TCustomAttribute;
begin
  result := false;
  attributes := aMethod.GetAttributes;
  for attrib in attributes do
    if attrib.InheritsFrom(attribClass) then
      exit(true);
end;

function TObjectHelper.ContextInvokeAttribute(attribClass
  : TCustomAttributeClass; params: array of TValue): Boolean;
var
  aCtx: TRttiContext;
  aMethod: TRttiMethod;
begin
  result := false;
  aCtx := TRttiContext.Create;
  try
    for aMethod in aCtx.GetType(self.ClassType).GetMethods do
    begin
      if ContextHasAttribute(aMethod, attribClass) then
      begin
        aMethod.Invoke(self, params);
        result := true;
      end;
    end;
  finally
    aCtx.Free;
  end;

end;

function TObjectHelper.ContextInvokeMethod(AName: string;
params: array of TValue): TValue;
var
  aMethod: TRttiMethod;
begin
  aMethod := ContextMethods[AName];
  if not assigned(aMethod) then
    exit(false);
  try
    if aMethod.MethodKind = mkFunction then
      result := aMethod.Invoke(self, params)
    else
    begin
      result := false;
      aMethod.Invoke(self, params);
      result := true;
    end;
  finally
  end;
end;

function TObjectHelper.IsContextProperty(AName: String): Boolean;
var
  v: TValue;
begin
  v := ContextProperties[AName];
  result := not v.IsEmpty;
end;

function TObjectHelper.ContextPropertyCount: Integer;
var
  aCtx: TRttiContext;
begin
  aCtx := TRttiContext.Create;
  try
    result := High(aCtx.GetType(self.ClassType).GetProperties);
  finally
    aCtx.Free;
  end;
end;

function TObjectHelper.ContextPropertyName(idx: Integer): string;
var
  aCtx: TRttiContext;
begin
  aCtx := TRttiContext.Create;
  try
    result := aCtx.GetType(self.ClassType).GetProperties[idx].name;
  finally
    aCtx.Free;
  end;
end;

class procedure TObjectHelper.ContextRecordValuesList<T>
  (AList: TList<TValueNamed>; ARec: T);
var
  LContext: TRttiContext;
  LRecord: TRttiRecordType;
  LField: TRttiField;
  LNamed: TValueNamed;
begin
  LContext := TRttiContext.Create;
  try
    LRecord := LContext.GetType(TypeInfo(T)).AsRecord;
    for LField in LRecord.GetFields do
    begin
      LNamed.name := LField.name;
      LNamed.Value := LField.GetValue(@ARec);
      AList.Add(LNamed);
    end;
  finally
    LContext.Free;
  end;
end;

procedure TObjectHelper.CopyFrom(Obj: TObject;
const AVisibility: TMemberVisibilitySet = [mvPublished]);
var
  aCtx: TRttiContext;
  aProperty: TRttiProperty;
  aFields: TRttiField;
  aRtti: TRttiType;
  aTrib: TCustomAttribute;
  aVal: TValue;
  skip: Boolean;
begin
  aCtx := TRttiContext.Create;
  try
    aRtti := aCtx.GetType(self.ClassType);
    for aProperty in aRtti.GetProperties do
    begin
      if aProperty.PropertyType.TypeKind in [tkInteger, tkChar, tkFloat,
        tkString, tkWChar, tkLString, tkWString, tkVariant, tkInt64, tkUString]
      then
      begin
        skip := false;
        aVal := Obj.ContextProperties[aProperty.name];
        if aVal.IsEmpty then
          continue;
        for aTrib in aProperty.GetAttributes do
        begin
          if aTrib.ClassName.Contains('hide') then
            skip := true;
        end;
        if skip then
          continue;
        if aProperty.Visibility in AVisibility then
          // usar somente Published para não pegar sujeira.
          aProperty.SetValue(self, aVal);
      end;
    end;
    for aFields in aRtti.GetFields do
    begin
      if aFields.FieldType.TypeKind in [tkInteger, tkChar, tkFloat, tkString,
        tkWChar, tkLString, tkWString, tkVariant, tkInt64, tkUString] then
      begin
        skip := false;
        aVal := Obj.ContextFields[aFields.name];
        if aVal.IsEmpty then
          continue;
        for aTrib in aFields.GetAttributes do
        begin
          if aTrib.ClassName.Contains('hide') then
            skip := true;
        end;
        if skip then
          continue;
        if aFields.Visibility in AVisibility then
          // usar somente Published para não pegar sujeira.
          aFields.SetValue(self, aVal);
      end;
    end;
  finally
    aCtx.Free;
  end;

end;

procedure TObjectHelper.CopyTo(Obj: TObject);
begin
  Obj.CopyFrom(self);
end;

class procedure TObjectHelper.Queue(Proc: TProc);
begin
  TThread.Queue(TThread.CurrentThread,
    procedure
    begin
      Proc;
    end);
end;

class function TObjectHelper.Queue<T>(O: T; Proc: TProc<T>): TObject;
begin
  result := O;
  TThread.Queue(TThread.CurrentThread,
    procedure
    begin
      Proc(O);
    end);
end;

class procedure TObjectHelper.Run(Proc: TProc);
begin
  TObject.Run<TObject>(TThread.CurrentThread,
    procedure(Sender: TObject)
    begin
      Proc;
    end);
end;

class procedure TObjectHelper.Run<T>(O: T; Proc: TProc<T>);
begin
{$IF CompilerVersion>28}
  TTask.Create(
    procedure
    begin
      Proc(O);
    end).Start;
{$ELSE}
  TThread.CreateAnonymousThread(
    procedure
    begin
      Proc(O);
    end).Start;
{$ENDIF}
end;

class procedure TObjectHelper.RunQueue(Proc: TProc);
begin
{$IF CompilerVersion>28}
  TTask.Create(
    procedure
    begin
      TThread.Queue(nil,
        procedure
        begin
          Proc;
        end);
    end).Start;
{$ELSE}
  TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Queue(nil,
        procedure
        begin
          Proc;
        end);
    end).Start;
{$ENDIF}
end;

procedure TObjectHelper.SetContextFields(AName: string; const Value: TValue);
var
  AField: TRttiField;
  aCtx: TRttiContext;
begin
  aCtx := TRttiContext.Create;
  try
    AField := aCtx.GetType(self.ClassType).GetField(AName);
    if assigned(AField) then
      AField.SetValue(self, Value);
  finally
    aCtx.Free;
  end;
end;

procedure TObjectHelper.SetContextProperties(AName: string;
const Value: TValue);
var
  aProperty: TRttiProperty;
  aCtx: TRttiContext;
  AValue: TValue;
begin
  aCtx := TRttiContext.Create;
  try
    aProperty := aCtx.GetType(self.ClassType).GetProperty(AName);
    if assigned(aProperty) and aProperty.IsWritable then
      try
        case aProperty.PropertyType.TypeKind of
          tkInteger, tkInt64:
            aProperty.SetValue(self, trunc(Value.AsExtended));
        else
          aProperty.SetValue(self, Value);
        end;
      except
      end;
  finally
    aCtx.Free;
  end;
end;

class procedure TObjectHelper.Synchronize(Proc: TProc);
begin
  TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      Proc
    end);
end;

class function TObjectHelper.Synchronize<T>(O: T; Proc: TProc<T>): TObject;
begin
  result := O;
  TThread.Synchronize(TThread.CurrentThread,
    procedure
    begin
      Proc(O);
    end);
end;

function TObjectHelper.ToJson: string;
begin // System.uJson
{$IFNDEF BPL}
  result := TJson.ObjectToJsonString(self);
{$ENDIF}
end;

function TObjectHelper.ToJsonObject: TJsonObject;
begin
{$IFNDEF BPL}
  result := TJson.ObjectToJsonObject(self);
{$ENDIF}
end;

class function TObjectHelper.Anonymous<T>(O: T; Proc: TProc<T>): TObject;
begin
  result := O;
  Proc(O);
end;

{ TObject }

procedure TObjectExt.FireEvent(Sender: TObject);
begin
  if assigned(FOnFireEvent) then
    FOnFireEvent(Sender);
end;

procedure TObjectExt.SetOnFireEvent(const Value: TProc<TObject>);
begin
  FOnFireEvent := Value;
end;

{ TThreadedPool }

constructor TTaskList.Create;
begin
  inherited;
  FMaxThread := 10;
end;

procedure TTaskList.DoDestroyThread(Value: TObject);
begin
  Remove(Value);
end;

{$IF CompilerVersion>28}

type
  TTaskHack = class(TTask, ITask)
  public
    onTerminate: TNotifyEvent;
    Constructor Create(AProc: TProc; AEvent: TNotifyEvent);
    destructor Destroy; override;
  end;

Constructor TTaskHack.Create(AProc: TProc; AEvent: TNotifyEvent);
begin
  // inherited create(nil, nil, AProc, TThreadPool.Default, nil);
  inherited Create(AProc, TThreadPool.Default);
  onTerminate := AEvent;
end;

destructor TTaskHack.Destroy;
begin
  if assigned(onTerminate) then
    onTerminate(self);
  inherited Destroy;
end;
{$ENDIF}

procedure TTaskList.Run(Proc: TProc);
var
  T: {$IF CompilerVersion>28} TTaskHack; {$ELSE} TThread; {$ENDIF}
begin
{$IF CompilerVersion>28}
  T := TTaskHack.Create(Proc, DoDestroyThread);
  Add(T);
  (T as ITask).Start;
{$ELSE}
  T := TThread.CreateAnonymousThread(Proc);
  T.onTerminate := DoDestroyThread;
  Add(T);
  T.Start;
{$ENDIF}
end;

procedure TTaskList.SetMaxThread(const Value: Integer);
begin
  FMaxThread := Value;
end;

{ TCollectionHelper }
{
  function TCollectionHelper.ToJson: string;
  var j:TJsonArray;
  i:integer;
  begin
  j := TJsonArray.Create;
  try
  for I := 0 to count-1 do
  j.AddElement( TJson.ObjectToJsonObject(  items[i] )   );
  result := j.ToJSON;
  finally
  j.Free;
  end;
  end;
}
{ TStingListHelper }

function TStingListHelper.AsJsonArray: TJsonArray;
var
  i: Integer;
begin
  result := TJsonArray.Create;
  for i := 0 to count - 1 do
    result.Add(self[i]);
end;

{$IF compilerVersion<32}

procedure TStingListHelper.addPair(AName, AValue: String);
begin
  self.Add(AName + '=' + AValue);
end;
{$ENDIF}

function TStingListHelper.AsJsonObject: TJsonObject;
var
  i: Integer;
begin
  result := TJsonObject.Create;
  for i := 0 to count - 1 do
    result.addPair(self.Names[i], self.ValueFromIndex[i]);
end;

function TStingListHelper.FromJson(AJson: String): TStringList;
var
  p: TJsonPair;
  j: TJsonObject;
begin
  result := self;
  j := TJsonObject.ParseJSONValue(AJson) as TJsonObject;
  try
    for p in j do
    begin
      self.addPair(p.JsonString.Value, p.JsonValue.Value);
    end;
  finally
    j.Free;
  end;
end;

class function TStingListHelper.New(AText: string; ADelimiter: char = ',')
  : TStringList;
begin
  result := TStringList.Create;
  result.Delimiter := ADelimiter;
  result.DelimitedText := AText;
end;

function TStingListHelper.ToJson: string;
begin
  with AsJsonObject do
    try
      result := ToJson;
    finally
      Free;
    end;
end;

{ TClassAdapter<T> }

constructor TObjectAdapter<T>.Create(AClass: T);
begin
  inherited Create;
  FInstance := AClass;
  if assigned(AClass) then
    InstanceOf(AClass.ClassType)
  else
    InstanceOf(TClass(T));
end;

constructor TObjectAdapter<T>.Create;
begin
  Create(nil);
end;

function TObjectAdapter<T>.DelegateTo(AFunc: TFunc<T>): IObjectAdapter<T>;
begin
  result := self;
  FDelegate := AFunc;
end;

destructor TObjectAdapter<T>.Destroy;
begin
  freeAndNil(FInstance);
  inherited;
end;

procedure TObjectAdapter<T>.Initialize;
var
  Obj: TObject;
begin
  if not assigned(FInstance) then
  begin
    if assigned(FDelegate) then
      Obj := FDelegate()
    else
      Obj := FClass.Create;
    FInstance := T(Obj);
    FCreated := assigned(FInstance);
  end;
end;

function TObjectAdapter<T>.InstanceOf(AClass: TClass): IObjectAdapter<T>;
begin
  result := self;
  FClass := AClass;
end;

function TObjectAdapter<T>.Invoke: T;
begin
  Initialize;
  result := FInstance;
end;

class function TObjectAdapter<T>.New(Obj: TObject): IObjectAdapter<T>;
var
  XObj: TObjectAdapter<T>;
begin
  XObj := TObjectAdapter<T>.Create(nil);
  XObj.InstanceOf(TClass(T));
  XObj.FInstance := T(Obj);
  result := XObj;
end;

procedure TObjectAdapter<T>.Null;
begin
  FInstance := nil;
  FCreated := false;
end;

function TObjectAdapter<T>.QueryInterface(const AIID: TGUID; out Obj): HResult;
begin
  if IsEqualGUID(AIID, ObjAdapterGUID) then
  begin
    Initialize;
  end;
  result := inherited QueryInterface(AIID, Obj);
end;

procedure TObjectAdapter<T>.Release;
begin
  freeAndNil(FInstance);
  FCreated := false;
end;

class function TObjectAdapter<T>.New: IObjectAdapter<T>;
var
  Obj: TObjectAdapter<T>;
begin
  Obj := TObjectAdapter<T>.Create(nil);
  Obj.InstanceOf(TClass(T));
  result := Obj;
end;

{ TStringsHelper }

function TStringsHelper.Items: TStrings;
begin
  result := self;
end;

end.
