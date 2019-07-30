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
  TIntegerMath = record helper for
    integer
    function Add(value: integer): integer;
    function Max(value: integer): integer;
    function Min(value: integer): integer;
    function ToString(): string;
    function Between(a, b: integer): boolean;
    function Sub(value: integer): Double;
    function Format(mask: string): string;
    function DivBy(value: integer): integer;
    function MulBy(value: integer): integer;
    function IIF(b: boolean; value: integer): integer;
    function isValid(value: string): boolean;
    function Equals(value: integer): boolean; overload;
    function Equals(value: string): boolean; overload;
    function clear: integer;
  end;

  TDoubleMath = record helper for
    Double
    function Add(value: Double): Double;
    function Max(value: Double): Double;
    function Min(value: Double): Double;
    function ToString(): string;
    function Between(a, b: Double): boolean;
    function Sub(value: Double): Double;
    function Format(mask: string): string;
    function DivBy(value: Double): Double;
    function MulBy(value: Double): Double;
    function IIF(b: boolean; value: Double): Double;
    function clear: Double;
    function isValid(value: string): boolean;
    function Equals(value: Double): boolean; overload;
    function Equals(value: string): boolean; overload;
  end;

  HideAttribute = class(TCustomAttribute)
  end;

  IFireEventProc = interface
    ['{BBC08E72-6518-4BF8-8BEE-0A46FD8B351C}']
    procedure SetOnEvent(const value: TProc<TObject>);
    procedure FireEvent(Sender: TObject);
  end;

  IObjectAdapted<T> = interface
    ['{6A8BEF14-2F3C-42A4-8B20-9233492170EC}']
    function Invoke: T;
    property This: T read Invoke;
  end;

  IObjectAdapter<T: Class> = interface(TFunc<T>)
    ['{17EB68E7-7212-4AE9-B686-FC4CC3A08F07}']
    property Instance: T read Invoke;
    procedure Null;
    procedure Release;
  end;

  TObjectAdapter<T: Class> = class(TInterfacedObject, IObjectAdapter<T>,
    IInterface, IObjectAdapted<T>)
  private
    FCreated: boolean;
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

  TContinuationAction<T, T1> = reference to function(const arg: T): T1;

  TContinuationOptions = (NotOnCompleted, NotOnFaulted, NotOnCanceled,
    OnlyOnCompleted, OnlyOnFaulted, OnlyOnCanceled);

  TObjectFired = class(System.TObject)
  private
    FOnFireEvent: TProc<TObject>;
    FContinueTo: TContinuationAction<TContinuationOptions, boolean>;
    procedure SetOnFireEvent(const value: TProc<TObject>);
    procedure SetContinueTo(const value
      : TContinuationAction<TContinuationOptions, boolean>);
  public
    function ContinueWith(ASender: TContinuationOptions): boolean; virtual;
    procedure FireEvent; overload;
    procedure FireEvent(Sender: TObject); overload;
    property OnFireEvent: TProc<TObject> read FOnFireEvent write SetOnFireEvent;
    property ContinueTo: TContinuationAction<TContinuationOptions, boolean>
      read FContinueTo write SetContinueTo;
  end;

  TCustomAttributeClass = class of TCustomAttribute;
  TMemberVisibilitySet = set of TMemberVisibility;

  TValueNamed = record
    Name: string;
    value: TValue;
  end;

  TObjectHelper = class helper for TObject
  private
    function GetContextProperties(AName: string): TValue;
    procedure SetContextProperties(AName: string; const value: TValue);
    function GetContextFields(AName: string): TValue;
    procedure SetContextFields(AName: string; const value: TValue);
    function GetContextMethods(AName: String): TRttiMethod;
    class function JsonFromObject(AObject: TObject; AExclude: string = '')
      : TJSONObject; static;
  public
    function acknowledged: integer;
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
    function ToJson(AExclude: string = ''): string; overload;
    function ToJsonObject: TJSONObject; overload;
    procedure FromJson(AJson: string); overload;
    function Clone: System.TObject;
    class function FromJson<T: Class, constructor>(AJson: string): T;
      overload; static;

    // RTTI
    procedure CopyFrom(Obj: TObject;
      const AVisibility: TMemberVisibilitySet = [mvPublished]);
    procedure CopyTo(Obj: TObject);
    function ContextPropertyCount: integer;
    function ContextPropertyName(idx: integer): string;
    property ContextProperties[AName: string]: TValue read GetContextProperties
      write SetContextProperties;
    function IsContextProperty(AName: String): boolean;
    procedure GetContextPropertiesList(AList: TStrings;
      const AVisibility: TMemberVisibilitySet = [mvPublished, mvPublic]);
    procedure GetContextPropertiesItems(AList: TStrings;
      const AVisibility: TMemberVisibilitySet = [mvPublished, mvPublic]);

    function &ContextFieldsCount: integer;
    function &ContextFieldName(idx: integer): string;
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
      params: array of TValue): TValue;
    function WriteTextToFile(AFileName: string; AContent: String): boolean;
  end;

  TTaskList = class(TThreadList)
  private
    FMaxThread: integer;
    procedure SetMaxThread(const value: integer);
  public
    constructor Create;
    procedure DoDestroyThread(value: TObject);
    procedure Run(Proc: TProc);
    property MaxThread: integer read FMaxThread write SetMaxThread;
  end;

  TStingListHelper = Class helper for TStringList
  public
{$IF compilerVersion<32}
    procedure addPair(AName, AValue: String);
{$ENDIF}
    class function New(AText: string; ADelimiter: char = ','): TStringList;
    function AsJsonArray: TJsonArray;
    function AsJsonObject: TJSONObject;
    function ToJson: string;
    function FromJson(AJson: String): TStringList;
  end;

  TDatetimeHelper = record helper for TDatetime
  public
    class function new( aDatetime:string):TDateTime;static;
    function FromISO(ADateIso: string): TDatetime;
    function ToISO: string;
    function ToString:String;
    function ToDate:TDateTime;
    function ToTime:TDateTime;
  end;

function ISODateToString(ADate: TDatetime): string;
function ISOTimeToString(ATime: TTime): string;
function ISODateTimeToString(ADateTime: TDatetime): string;
function ISOStrToDateTime(DateTimeAsString: string): TDatetime;
function ISOStrToDate(DateAsString: string): TDate;
function ISOStrToTime(TimeAsString: string): TTime;

implementation

uses {$IF CompilerVersion>28} System.Threading, {$ENDIF}
{$IFNDEF BPL}
  // REST.Json,
{$ENDIF}
  System.DateUtils;

var
  LAccept: integer;

const
  nak = 0;
  ak = 200;

function ISOTimeToString(ATime: TTime): string;
var
  fs: TFormatSettings;
begin
  fs.TimeSeparator := ':';
  result := FormatDateTime('hh:nn:ss', ATime, fs);
end;

function ISODateToString(ADate: TDatetime): string;
begin
  result := FormatDateTime('YYYY-MM-DD', ADate);
end;

function ISODateTimeToString(ADateTime: TDatetime): string;
begin
  result := System.DateUtils.DateToISO8601(ADateTime, false);
end;

function ISOStrToDateTime(DateTimeAsString: string): TDatetime;
var
  rt: boolean;
begin
  rt := false;
  if DateTimeAsString.contains('T') or DateTimeAsString.contains('Z') then
    rt := TryISO8601ToDate(DateTimeAsString, result);
  if not rt then
    result := StrToDateTime(DateTimeAsString);
end;

function ISOStrToTime(TimeAsString: string): TTime;
begin
  result := EncodeTime(StrToInt(Copy(TimeAsString, 1, 2)),
    StrToInt(Copy(TimeAsString, 4, 2)), StrToInt(Copy(TimeAsString, 7, 2)), 0);
end;

function ISOStrToDate(DateAsString: string): TDate;
begin
  result := (trunc(ISOStrToDateTime(DateAsString)));
end;

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

procedure TObjectFired.FireEvent;
begin
  FireEvent(self);
end;

function TObjectHelper.&ContextFieldName(idx: integer): string;
var
  aCtx: TRttiContext;
begin
  aCtx := TRttiContext.Create;
  try
    result := aCtx.GetType(self.ClassType).GetFields[idx].Name;
  finally
    aCtx.Free;
  end;
end;

function TObjectHelper.&ContextFieldsCount: integer;
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
  oJs: TJSONObject;
  lst: TStringList;
  pair: TJsonPair;
  s: string;
begin
{$IFNDEF BPL}
  oJs := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
  lst := TStringList.Create;
  try
    for pair in oJs do
    begin
      ContextProperties[pair.JsonString.value] := pair.JsonValue.value;
      ContextFields[pair.JsonString.value] := pair.JsonValue.value;
    end;
  finally
    lst.Free;
    oJs.Free;
  end;
{$ENDIF}
end;

function TObjectHelper.Clone: System.TObject;
// var
// oJs: TJSONObject;
begin
{$IFNDEF BPL}
  // oJs := TJSONObject.ParseJSONValue(ToJson) as TJSONObject;
  self.FromJson(ToJson);
  // TJson.JsonToObject(self, oJs);
{$ENDIF}
  result := self;
end;

class function TObjectHelper.FromJson<T>(AJson: string): T;
begin
{$IFNDEF BPL}
  result := T(TClass(T).Create);
  result.FromJson(AJson);
  // result := TJson.JsonToObject<T>(AJson);
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
  LTemAtributo: boolean;
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
          AList.Add(AFld.Name);
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
  j: TJSONObject;
  APair: TJsonPair;
  LAttr: TCustomAttribute;
  LContinue: boolean;
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
          if assigned(LAttr) then
            if LAttr is HideAttribute then
              LContinue := false; // é um Field [HIDE]

        if assigned(AFunc) and LContinue then
          LContinue := AFunc(AField.Name);

        if LContinue then
          AStrings.Add(lowercase(AField.Name));
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
      if sameText(LField.Name, aNome) then
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
  LTemAtributo: boolean;
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
          AList.Add(aMethod.Name);
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
  result := TypeInfo = System.TypeInfo(integer);
end;

function TValueHelper.AsFloat: Extended;
begin
  result := AsType<Extended>;
end;

function TValueHelper.AsDouble: Double;
begin
  result := AsType<Double>;
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
          AList.Add(aProperty.Name + '=' + ISODateTimeToString(AValue.AsDouble))
        else if AValue.IsBoolean then
          AList.Add(aProperty.Name + '=' + ord(AValue.AsBoolean).ToString)
        else
          AList.Add(aProperty.Name + '=' + AValue.ToString);
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
        AList.Add(aProperty.Name);
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

function TObjectHelper.IsContextProperty(AName: String): boolean;
var
  v: TValue;
begin
  v := ContextProperties[AName];
  result := not v.IsEmpty;
end;

function TObjectHelper.ContextPropertyCount: integer;
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

function TObjectHelper.ContextPropertyName(idx: integer): string;
var
  aCtx: TRttiContext;
begin
  aCtx := TRttiContext.Create;
  try
    result := aCtx.GetType(self.ClassType).GetProperties[idx].Name;
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
      LNamed.Name := LField.Name;
      LNamed.value := LField.GetValue(@ARec);
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
  skip: boolean;
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
        aVal := Obj.ContextProperties[aProperty.Name];
        if aVal.IsEmpty then
          continue;
        for aTrib in aProperty.GetAttributes do
        begin
          if aTrib.ClassName.contains('hide') then
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
        aVal := Obj.ContextFields[aFields.Name];
        if aVal.IsEmpty then
          continue;
        for aTrib in aFields.GetAttributes do
        begin
          if aTrib.ClassName.contains('hide') then
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

function TObjectHelper.WriteTextToFile(AFileName, AContent: String): boolean;
begin
  result := false;
  try
    with TStringList.Create do
      try
        text := AContent;
        SaveToFile(AFileName);
        result := true;
      finally
        Free;
      end;
  except
    result := false;
  end;
end;

procedure TObjectHelper.SetContextFields(AName: string; const value: TValue);
var
  AField: TRttiField;
  aCtx: TRttiContext;
begin
  LAccept := nak;
  aCtx := TRttiContext.Create;
  try
    AField := aCtx.GetType(self.ClassType).GetField(AName);
    if assigned(AField) then
    begin
      AField.SetValue(self, value);
      LAccept := ak;
    end;
  finally
    aCtx.Free;
  end;
end;

procedure TObjectHelper.SetContextProperties(AName: string;
const value: TValue);
var
  aProperty: TRttiProperty;
  aCtx: TRttiContext;
  AValue: TValue;
begin
  LAccept := nak;
  aCtx := TRttiContext.Create;
  try
    aProperty := aCtx.GetType(self.ClassType).GetProperty(AName);
    if assigned(aProperty) and aProperty.isWritable then
      try
        case aProperty.PropertyType.TypeKind of
          tkClass, tkInterface:
            ;
          tkInteger, tkInt64:
            aProperty.SetValue(self, trunc(value.AsExtended));
          tkFloat:
            if value.IsNumeric then
              aProperty.SetValue(self, value.AsFloat)
            else if (value.asString.contains('T') or
              (value.asString.contains('Z'))) then
              aProperty.SetValue(self, ISOStrToDateTime(value.asString))
            else
              aProperty.SetValue(self, StrToFloat(value.asString));
        else
          aProperty.SetValue(self, value);
        end;
        LAccept := ak;
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

class function TObjectHelper.JsonFromObject(AObject: TObject;
AExclude: string = ''): TJSONObject;
var
  typ: TRttiType;
  ctx: TRttiContext;
  field: TRttiField;
  aProperty: TRttiProperty;
  tk: TTypeKind;
  // P: Pointer;
  key: String;
  FRecord: TRttiRecordType;
  FMethod: TRttiMethod;
  LAttr: TCustomAttribute;
  LContinue: boolean;
  AValue: TValue;
begin

  AExclude := (';' + AExclude + ';').Replace(',', ';').ToLower;

  result := TJSONObject.Create;
  ctx := TRttiContext.Create;
  typ := ctx.GetType(AObject.ClassType);
  // P := @AObject;
  for field in typ.GetFields do
  begin
    try
      if not(field.Visibility in [mvPublic, mvPublished]) then
        continue;
      LContinue := true;
      for LAttr in field.GetAttributes do
      begin
        if LAttr is HideAttribute then
          LContinue := false;
      end;
      if not LContinue then
        continue;

      key := field.Name.ToLower;
      if key.Equals('refcount') then
        continue;

      if AExclude.contains(';' + key + ';') then
        continue;

      tk := field.FieldType.TypeKind;
      case tk of
        tkClass, tkInterface:
          ;
        tkEnumeration: // boolean
          begin
            AValue := aProperty.GetValue(AObject);
            if AValue.IsBoolean then
              if AValue.AsBoolean then
                result.addPair(key, TJSONTrue.Create)
              else
                result.addPair(key, TJsonFalse.Create);
          end;
        tkRecord:
          begin
            (* FRecord := ctx.GetType(field.GetValue(P).TypeInfo).AsRecord ;
              FMethod := FRecord.GetMethod('asJson');
              if assigned(FMethod) then
              begin
              result.AddPair(key,fMethod.asJson );
              end; *)
          end;
        tkInteger:
          result.addPair(key, TJSONNumber.Create(field.GetValue(AObject)
            .AsInteger));

        tkFloat:
          begin // System.Classes.Helper
            if sameText(field.FieldType.Name, 'TDateTime') then
              result.addPair(TJsonPair.Create(key,
                ISODateTimeToString(field.GetValue(AObject).AsExtended)))
            else if sameText(field.FieldType.Name, 'TDate') then
              result.addPair(TJsonPair.Create(key,
                ISODateToString(field.GetValue(AObject).AsExtended)))
            else if sameText(field.FieldType.Name, 'TTime') then
              result.addPair(TJsonPair.Create(key,
                ISOTimeToString(field.GetValue(AObject).AsExtended)))
            else if sameText(field.FieldType.Name, 'TTimeStamp') then
              result.addPair(TJsonPair.Create(key,
                ISODateTimeToString(field.GetValue(AObject).AsExtended)))
            else
              result.addPair(key, TJSONNumber.Create(field.GetValue(AObject)
                .AsExtended));
          end;
        tkString, tkUString, tkChar, tkWChar, tkLString,
          tkWString { , tkWideChar,
          tkWideString } :
          result.addPair(TJsonPair.Create(key, field.GetValue(AObject)
            .ToString.Trim));
      end;
    except
    end;
  end;

  for aProperty in typ.GetProperties do
  begin
    if aProperty.Visibility in [mvPublic, mvPublished] then
    begin
      LContinue := true;
      for LAttr in aProperty.GetAttributes do
      begin
        if LAttr is HideAttribute then
          LContinue := false;
      end;
      if not LContinue then
        continue;
      try
        key := aProperty.Name.ToLower;

        if key.Equals('refcount') then
          continue;
        if AExclude.contains(';' + key + ';') then
          continue;

        tk := aProperty.PropertyType.TypeKind;
        case tk of
          tkClass, tkInterface:
            ;
          tkEnumeration: // boolean
            begin
              AValue := aProperty.GetValue(AObject);
              if AValue.IsBoolean then
                if AValue.AsBoolean then
                  result.addPair(key, TJSONTrue.Create)
                else
                  result.addPair(key, TJsonFalse.Create);
            end;
          tkRecord:
            begin
              (* FRecord := ctx.GetType(field.GetValue(P).TypeInfo).AsRecord ;
                FMethod := FRecord.GetMethod('asJson');
                if assigned(FMethod) then
                begin
                result.AddPair(key,fMethod.asJson );
                end; *)
            end;
          tkInteger:
            result.addPair(key, TJSONNumber.Create(aProperty.GetValue(AObject)
              .AsInteger));
          tkFloat:
            begin // System.Classes.Helper
              if sameText(aProperty.PropertyType.Name, 'TDateTime') then
                result.addPair(TJsonPair.Create(key,
                  ISODateTimeToString(aProperty.GetValue(AObject).AsExtended)))
              else if sameText(aProperty.PropertyType.Name, 'TDate') then
                result.addPair(TJsonPair.Create(key,
                  ISODateToString(aProperty.GetValue(AObject).AsExtended)))
              else if sameText(aProperty.PropertyType.Name, 'TTime') then
                result.addPair(TJsonPair.Create(key,
                  ISOTimeToString(aProperty.GetValue(AObject).AsExtended)))
              else if sameText(aProperty.PropertyType.Name, 'TTimeStamp') then
                result.addPair(TJsonPair.Create(key,
                  ISODateTimeToString(aProperty.GetValue(AObject).AsExtended)))
              else
                result.addPair(key,
                  TJSONNumber.Create(aProperty.GetValue(AObject).AsExtended));
            end;
          tkString, tkUString, tkChar, tkWChar, { tkLString, } tkWString { ,
            tkWideChar, tkWideString } :

            result.addPair(TJsonPair.Create(key, aProperty.GetValue(AObject)
              .ToString));
        end;
      except
      end;

    end;
  end;

end;

function TObjectHelper.ToJson(AExclude: string = ''): string;
var
  j: TJSONObject;
begin // System.uJson
{$IFNDEF BPL}
  // result := TJson.ObjectToJsonString(self);
  j := self.JsonFromObject(self, AExclude);
  try
    result := j.ToJson;
  finally
    j.Free;
  end;
{$ENDIF}
end;

function TObjectHelper.ToJsonObject: TJSONObject;
begin
{$IFNDEF BPL}
  // result := TJson.ObjectToJsonObject(self);
  result := self.JsonFromObject(self);
{$ENDIF}
end;

function TObjectHelper.acknowledged: integer;
begin
  result := LAccept;
end;

class function TObjectHelper.Anonymous<T>(O: T; Proc: TProc<T>): TObject;
begin
  result := O;
  Proc(O);
end;

{ TObject }

function TObjectFired.ContinueWith(ASender: TContinuationOptions): boolean;
begin
  if assigned(FContinueTo) then
    result := FContinueTo(ASender);
end;

procedure TObjectFired.FireEvent(Sender: TObject);
begin
  if assigned(FOnFireEvent) then
    FOnFireEvent(Sender);
end;

procedure TObjectFired.SetContinueTo(const value
  : TContinuationAction<TContinuationOptions, boolean>);
begin
  FContinueTo := value;
end;

procedure TObjectFired.SetOnFireEvent(const value: TProc<TObject>);
begin
  FOnFireEvent := value;
end;

{ TThreadedPool }

constructor TTaskList.Create;
begin
  inherited;
  FMaxThread := 10;
end;

procedure TTaskList.DoDestroyThread(value: TObject);
begin
  Remove(value);
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

procedure TTaskList.SetMaxThread(const value: integer);
begin
  FMaxThread := value;
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
  i: integer;
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

function TStingListHelper.AsJsonObject: TJSONObject;
var
  i: integer;
begin
  result := TJSONObject.Create;
  for i := 0 to count - 1 do
    result.addPair(self.Names[i], self.ValueFromIndex[i]);
end;

function TStingListHelper.FromJson(AJson: String): TStringList;
var
  P: TJsonPair;
  j: TJSONObject;
begin
  result := self;
  j := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
  try
    for P in j do
    begin
      self.addPair(P.JsonString.value, P.JsonValue.value);
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

{ TDoubleMath }

function TDoubleMath.Add(value: Double): Double;
begin
  self := self + value;
  exit(self);
end;

function TDoubleMath.Between(a, b: Double): boolean;
begin
  result := (self >= a) and (self <= b);
end;

function TDoubleMath.clear: Double;
begin
  self := 0;
  exit(self);
end;

function TDoubleMath.DivBy(value: Double): Double;
begin
  self := self / value;
  exit(self);
end;

function TDoubleMath.Equals(value: string): boolean;
begin
  result := isValid(value);
  if result then
    result := Equals(StrToFloat(value));
end;

function TDoubleMath.Equals(value: Double): boolean;
begin
  result := self = value;
end;

function TDoubleMath.Format(mask: string): string;
begin
  result := FormatFloat(mask, self);
end;

function TDoubleMath.IIF(b: boolean; value: Double): Double;
begin
  if b then
    self := value;
  exit(self);

end;

function TDoubleMath.isValid(value: string): boolean;
begin
  result := true;
  try
    StrToFloat(value);
  except
    result := false;
  end;
end;

function TDoubleMath.Max(value: Double): Double;
begin
  if self > value then
    self := value;
  exit(self);
end;

function TDoubleMath.Min(value: Double): Double;
begin
  if self < value then
    self := value;
  exit(self);
end;

function TDoubleMath.MulBy(value: Double): Double;
begin
  self := self * value;
  exit(self);
end;

function TDoubleMath.Sub(value: Double): Double;
begin
  self := self - value;
  exit(self);
end;

function TDoubleMath.ToString: string;
begin
  exit(FloatToStr(self));
end;

{ TIntegerMath }

function TIntegerMath.Add(value: integer): integer;
begin
  self := self + value;
  exit(self);
end;

function TIntegerMath.Between(a, b: integer): boolean;
begin
  result := (self >= a) and (self <= b);
end;

function TIntegerMath.clear: integer;
begin
  self := 0;
  exit(self);

end;

function TIntegerMath.DivBy(value: integer): integer;
begin
  self := self div value;
  exit(self);
end;

function TIntegerMath.Equals(value: string): boolean;
begin
  result := false;
  if isValid(value) then
    result := Equals(strToIntDef(value, 0));
end;

function TIntegerMath.Equals(value: integer): boolean;
begin
  result := self = value;
end;

function TIntegerMath.Format(mask: string): string;
begin
  result := FormatFloat(mask, self);
end;

function TIntegerMath.IIF(b: boolean; value: integer): integer;
begin
  if b then
    self := value;
  exit(self);
end;

function TIntegerMath.isValid(value: string): boolean;
var
  r: integer;
begin
  result := value <> '';
  try
    r := StrToInt(value);
  except
    result := false;
  end;
end;

function TIntegerMath.Max(value: integer): integer;
begin
  if self > value then
    self := value;
  exit(self);
end;

function TIntegerMath.Min(value: integer): integer;
begin
  if self < value then
    self := value;
  exit(self);
end;

function TIntegerMath.MulBy(value: integer): integer;
begin
  self := round(self * value);
  exit(self);
end;

function TIntegerMath.Sub(value: integer): Double;
begin
  self := self - value;
  exit(self);
end;

function TIntegerMath.ToString: string;
begin
  result := IntToStr(self);
end;

{ TDatetimeHelper }

function TDatetimeHelper.fromISO(ADateIso: string): TDatetime;
begin
  self := ISOStrToDateTime(ADateIso);
  result := self;
end;

class function TDatetimeHelper.new(aDatetime: string): TDateTime;
begin
  result.fromIso(ADateTime);
end;

function TDatetimeHelper.ToDate: TDateTime;
begin
  result := round(self);
end;

function TDatetimeHelper.toISO: string;
begin
  result := ISODateTimeToString(self);
end;

function TDatetimeHelper.ToString: String;
begin
    result := DateTimeToStr(self);
end;

function TDatetimeHelper.ToTime: TDateTime;
begin
  result := self - trunc(self);
end;

end.
