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

uses System.Classes, System.SysUtils, System.Rtti,
  System.Generics.Collections,
  System.TypInfo, System.Json;

Type

  HideAttribute = class(TCustomAttribute)
  end;

  IFireEventProc = interface
    ['{BBC08E72-6518-4BF8-8BEE-0A46FD8B351C}']
    procedure SetOnEvent(const Value: TProc<TObject>);
    procedure FireEvent(Sender: TObject);
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
    function ContextPropertyCount: Integer;
    function ContextPropertyName(idx: Integer): string;
    property ContextProperties[AName: string]: TValue read GetContextProperties
      write SetContextProperties;
    function IsContextProperty(AName: String): boolean;
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
      AFunc: TFunc < string, boolean >= nil); static;
    class procedure &ContextRecordValuesList<T: Record >
      (AList: TList<TValueNamed>; ARec: T); static;
    class function GetRecordValue<T: Record >(rec: T; aNome: string)
      : TValue; static;

    property ContextMethods[AName: String]: TRttiMethod read GetContextMethods;
    procedure GetContextMethodsList(AList: TStrings;
      const AVisibility: TMemberVisibilitySet = [mvPublic]);

    function ContextHasAttribute(aMethod: TRttiMethod;
      attribClass: TCustomAttributeClass): boolean;

    function ContextInvokeAttribute(attribClass: TCustomAttributeClass;
      params: array of TValue): boolean;
    function ContextInvokeMethod(AName: string;
      params: array of TValue): boolean;

  end;

  TTaskList = class(TThreadList)
  private
    FMaxThread: Integer;
    procedure SetMaxThread(const Value: Integer);
  public
    constructor create;
    procedure DoDestroyThread(Value: TObject);
    procedure Run(Proc: TProc);
    property MaxThread: Integer read FMaxThread write SetMaxThread;
  end;

  {TFontHelper = class helper for TFont
  end;
  }
implementation

uses {$IF CompilerVersion>28} System.Threading, {$ENDIF} System.DateUtils,
  REST.Json;

class procedure TObjectHelper.Using<T>(O: T; Proc: TProc<T>);
var
  obj: TObject;
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
  th := {$IF CompilerVersion>28}TTask.create{$ELSE} TThread.
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
  aCtx := TRttiContext.create;
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
  aCtx := TRttiContext.create;
  try
    result := High(aCtx.GetType(self.ClassType).GetFields);
  finally
    aCtx.Free;
  end;
end;

procedure TObjectHelper.FromJson(AJson: string);
var
  oJs: TJsonObject;
begin
  oJs := TJsonObject.ParseJSONValue(AJson) as TJsonObject;
  TJson.JsonToObject(self, oJs);
end;

function TObjectHelper.Clone: System.TObject;
var
  oJs: TJsonObject;
begin
  oJs := TJsonObject.ParseJSONValue(ToJson) as TJsonObject;
  TJson.JsonToObject(self, oJs);
  result := self;
end;

class function TObjectHelper.FromJson<T>(AJson: string): T;
begin
  result := TJson.JsonToObject<T>(AJson);
end;

function TObjectHelper.GetContextFields(AName: string): TValue;
var
  aCtx: TRttiContext;
  AField: TRttiField;
begin
  result := nil;
  aCtx := TRttiContext.create;
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
  LTemAtributo: boolean;
begin
  AList.clear;
  aCtx := TRttiContext.create;
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
AFunc: TFunc < string, boolean >= nil);
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
  LContinue: boolean;
begin
  AContext := TRttiContext.create;
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
  LContext := TRttiContext.create;
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
  aCtx := TRttiContext.create;
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
  LTemAtributo: boolean;
begin
  AList.clear;
  aCtx := TRttiContext.create;
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
  aCtx := TRttiContext.create;
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
    function IsNumeric: boolean;
    function IsFloat: boolean;
    function AsFloat: Extended;
    function IsBoolean: boolean;
    function IsDate: boolean;
    function IsDateTime: boolean;
    function IsDouble: boolean;
    function AsDouble: Double;
    function IsInteger: boolean;
  end;

function TValueHelper.IsNumeric: boolean;
begin
  result := Kind in [tkInteger, tkChar, tkEnumeration, tkFloat,
    tkWChar, tkInt64];
end;

function TValueHelper.IsFloat: boolean;
begin
  result := Kind = tkFloat;
end;

function TValueHelper.IsBoolean: boolean;
begin
  result := TypeInfo = System.TypeInfo(boolean);
end;

function TValueHelper.IsDate: boolean;
begin
  result := TypeInfo = System.TypeInfo(TDate);
end;

function TValueHelper.IsDateTime: boolean;
begin
  result := TypeInfo = System.TypeInfo(TDatetime);
end;

function TValueHelper.IsDouble: boolean;
begin
  result := TypeInfo = System.TypeInfo(Double);
end;

function TValueHelper.IsInteger: boolean;
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
  aCtx := TRttiContext.create;
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
  aCtx := TRttiContext.create;
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
attribClass: TCustomAttributeClass): boolean;
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
  : TCustomAttributeClass; params: array of TValue): boolean;
var
  aCtx: TRttiContext;
  aMethod: TRttiMethod;
begin
  result := false;
  aCtx := TRttiContext.create;
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
params: array of TValue): boolean;
var
  aMethod: TRttiMethod;
begin
  result := false;
  aMethod := ContextMethods[AName];
  if not assigned(aMethod) then
    exit(false);
  try
    aMethod.Invoke(self, params);
    result := true;
  finally
  end;
end;

function TObjectHelper.IsContextProperty(AName: String): boolean;
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
  aCtx := TRttiContext.create;
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
  aCtx := TRttiContext.create;
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
  LContext := TRttiContext.create;
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
  TTask.create(
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
  TTask.create(
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
  aCtx := TRttiContext.create;
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
  aCtx := TRttiContext.create;
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
  result := TJson.ObjectToJsonString(self);
end;

function TObjectHelper.ToJsonObject: TJsonObject;
begin
  result := TJson.ObjectToJsonObject(self);
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

constructor TTaskList.create;
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
    Constructor create(AProc: TProc; AEvent: TNotifyEvent);
    destructor destroy; override;
  end;

Constructor TTaskHack.create(AProc: TProc; AEvent: TNotifyEvent);
begin
  // inherited create(nil, nil, AProc, TThreadPool.Default, nil);
  inherited create(AProc, TThreadPool.Default);
  onTerminate := AEvent;
end;

destructor TTaskHack.destroy;
begin
  if assigned(onTerminate) then
    onTerminate(self);
  inherited destroy;
end;
{$ENDIF}

procedure TTaskList.Run(Proc: TProc);
var
  T: {$IF CompilerVersion>28} TTaskHack; {$ELSE} TThread; {$ENDIF}
begin
{$IF CompilerVersion>28}
  T := TTaskHack.create(Proc, DoDestroyThread);
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
end.
