unit System.Json.Helper;

interface




uses System.Classes, System.Types, System.SysUtils,
  System.TypInfo,  System.JSON,
  System.Generics.collections, System.Classes.Helper,
  RegularExpressions {$ifndef BPL}, DBXJsonReflect{$endif};

type

    TJsonRecord<T:Record> = class
      public
       class function ToJson(O: T): string;
       class procedure FromJson(O:T;AJson:string);
    end;

type

  TJsonType = (jtUnknown, jtObject, jtArray, jtString, jtTrue, jtFalse,
    jtNumber, jtDate, jtDateTime, jtBytes, jtNull);

  TJSONObjectHelper = class helper for TJSONObject
  private
    function GetValueBase(chave: string): string;
    procedure SetValueBase(chave: string; const Value: string);

  public
{$IFDEF VER270}
    function ToJSON: string;
{$ENDIF}
    class function GetTypeAsString(AType: TJsonType): string; static;
    class function GetJsonType(AJsonValue: TJsonValue): TJsonType; static;
    class function Stringify(so: TJSONObject): string;
    class function Parse(const dados: string): TJSONObject;
    function V(chave: String): variant;
    function S(chave: string): string;
    function I(chave: string): integer;
    function O(chave: string): TJSONObject; overload;
    function O(index: integer): TJSONObject; overload;
    function F(chave: string): Extended;
    function B(chave: string): boolean;
    function A(chave: string): TJSONArray;
    function AsArray: TJSONArray;
    function Contains(chave: string): boolean;
    function Find(chave: string): TJsonValue; virtual;

{$ifndef BPL}
    function asObject: System.TObject;
    class function FromRecord<T>(rec: T): TJSONObject;
{$endif}
    class function FromObject<T>(AObject: T): TJSONObject; overload;
    function addPair(chave: string; Value: integer): TJSONObject; overload;
    function addPair(chave: string; Value: Double): TJSONObject; overload;
    function addPair(chave: string; Value: TDatetime): TJSONObject; overload;
    property Value[chave: string]: string read GetValueBase write SetValueBase;
    function Coalesce(chave: string; Value: string): TJsonPair;
    // procedure FromRecord<T :record>(rec:T);
  end;

  TJSONArrayHelper = class helper for TJSONArray
  public
    function Length: integer;
    function Find(AJson: string): TJSONObject;
  end;

  TJsonValuesList = class(TObjectList<TJsonPair>)
  private
    function GetNames(AName: string): TJsonPair;
    procedure SetNames(AName: string; const Value: TJsonPair);
  public
    property Names[AName: string]: TJsonPair read GetNames write SetNames;
  end;

  TJSONValueHelper = class helper for TJsonValue
  private
  public
{$IFDEF VER270}
    function ToJSON: string;
{$ENDIF}
    function ToRecord<T>: T; overload;
    function ToRecord<T: Record >(var ARec: T): T; overload;
    class function ToRecord<T: record >(AJson: string): T; overload; static;
    class procedure GetRecordList<T: record >(AList: TJsonValuesList; ARec: T);
    function AsArray: TJSONArray;
    function AsPair: TJsonPair;
    function Datatype: TJsonType;
    function asObject: TJSONObject;
    function AsInteger: integer;
  end;

  TJSONPairHelper = class helper for TJsonPair
  public
    function asObject: TJSONObject;
  end;

  IJson = TJSONObject;
  IJSONArray = TJSONArray;

  TJson = TJSONObject;

function ReadJsonString(const dados: string; chave: string): string;
function ReadJsonInteger(const dados: string; chave: string): integer;
function ReadJsonFloat(const dados: string; chave: string): Extended;
// function ReadJsonObject(const dados: string): IJson;
function JSONstringify(so: IJson): string;
function JSONParse(const dados: string): IJson;

function ISODateTimeToString(ADateTime: TDatetime): string;
function ISODateToString(ADate: TDatetime): string;
function ISOTimeToString(ATime: TTime): string;

function ISOStrToDateTime(DateTimeAsString: string): TDatetime;
function ISOStrToDate(DateAsString: string): TDate;
function ISOStrToTime(TimeAsString: string): TTime;
function JSONStoreError(msg: string): TJsonValue;



implementation

uses db, System.Rtti,  System.DateUtils (*{$ifndef BPL}, Rest.JSON{$endif}*);


class procedure TJsonRecord<T>.FromJson(O: T; AJson: string);
var js:TJsonObject;
    AContext  : TRttiContext;
    AField    : TRttiField;
    ARecord   : TRttiRecordType;
    AFldName  : String;
    AValue    : TValue;
begin
   js:= TJsonObject.ParseJSONValue(AJson) as TJsonObject;
   try
    AContext := TRttiContext.Create;
    try
        ARecord := AContext.GetType(TypeInfo(T)).AsRecord;
        for AField in ARecord.GetFields do
        begin
            AFldName := AField.Name;
            AValue := js.GetValue(AFldName);
            AField.SetValue(@O,AValue);
        end;

    finally
      AContext.free;
    end;

   finally
     js.Free;
   end;
end;

class function TJsonRecord<T>.ToJson(O: T): string;
var
    AContext  : TRttiContext;
    AField    : TRttiField;
    ARecord   : TRttiRecordType;
    AFldName  : String;
    AValue    : TValue;
    ArrFields : TArray<TRttiField>;
    i:integer;
    js:TJsonObject;
begin
    js := TJsonObject.Create;
    AContext := TRttiContext.Create;
    try
        ARecord := AContext.GetType(TypeInfo(T)).AsRecord;
        ArrFields := ARecord.GetFields;
        i := 0;
        for AField in ArrFields do
        begin
            AFldName := AField.Name;
            AValue := AField.GetValue(@O);
            try
            if AValue.IsEmpty then
              js.addPair(AFldName,'NULL')
            else
            case AField.FieldType.TypeKind of
               tkInteger,tkInt64:
                    try
                      js.addPair(AFldName,TJSONNumber.Create(Avalue.AsInt64));
                    except
                      js.addPair(AFldName,TJSONNumber.Create(0));
                    end;
               tkEnumeration:
                      js.addPair(AFldName,TJSONNumber.Create(Avalue.AsInteger));
               tkFloat:
                 begin
                    if AField.FieldType.ToString.Equals('TDateTime') then
                      js.addPair(AFldName, FormatDateTime('yyyy-mm-dd HH:nn:ss',  AValue.AsExtended))
                    else
                    if AField.FieldType.ToString.Equals('TDate') then
                      js.addPair(AFldName, FormatDateTime('yyyy-mm-dd',  AValue.AsExtended))
                    else
                    if AField.FieldType.ToString.Equals('TTime') then
                      js.addPair(AFldName, FormatDateTime('HH:nn:ss',  AValue.AsExtended))
                    else
                      try
                        js.addPair(AFldName,TJSONNumber.Create(Avalue.AsExtended));
                      except
                        js.addPair(AFldName,TJSONNumber.Create(0));
                    end;
                 end
            else
               js.addPair(AFldName,AValue.asString)
            end;
            except
              js.addPair(AFldName,'NULL')
            end;

        end;
        result := js.ToString;
    finally
        js.Free;
        AContext.Free;
    end;

end;

var
  LJson: TJson;

type
  TValueHelper = record helper for TValue
  private
    function IsNumeric: boolean;
    function IsFloat: boolean;
    function IsBoolean: boolean;
    function IsDate: boolean;
    function IsDateTime: boolean;
    function IsDouble: boolean;
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

class function TJSONObjectHelper.GetTypeAsString(AType: TJsonType): string;
begin
  case AType of
    jtUnknown:
      result := 'Unknown';
    jtString:
      result := 'String';
    jtTrue, jtFalse:
      result := 'Boolean';
    jtNumber:
      result := 'Extended';
    jtDate:
      result := 'TDate';
    jtDateTime:
      result := 'TDateTime';
    jtBytes:
      result := 'Byte';
  end;
end;

function TJSONObjectHelper.GetValueBase(chave: string): string;
begin
  result := S(chave);
end;

class function TJSONObjectHelper.GetJsonType(AJsonValue: TJsonValue): TJsonType;
var
  LJsonString: TJSONString;
begin
  if AJsonValue is TJSONNull then
    result := jtNull
  else  if AJsonValue is TJSONObject then
    result := jtObject
  else if AJsonValue is TJSONArray then
    result := jtArray
  else if (AJsonValue is TJSONNumber) then
    result := jtNumber
  else if AJsonValue is TJSONTrue then
    result := jtTrue
  else if AJsonValue is TJSONFalse then
    result := jtFalse
  else if AJsonValue is TJSONString then
  begin
    LJsonString := (AJsonValue as TJSONString);
    if TRegEx.IsMatch(LJsonString.Value,
      '^([0-9]{4})-?(1[0-2]|0[1-9])-?(3[01]|0[1-9]|[12][0-9])(T| )(2[0-3]|[01][0-9]):?([0-5][0-9]):?([0-5][0-9])$')
    then
      result := jtDateTime
    else if TRegEx.IsMatch(LJsonString.Value,
      '^([0-9]{4})(-?)(1[0-2]|0[1-9])\2(3[01]|0[1-9]|[12][0-9])$') then
      result := jtDate
    else
      result := jtString
  end
  else
    result := jtUnknown;
end;

function JSONParse(const dados: string): IJson;
begin
  result := TJSONObject.ParseJSONValue(dados) as IJson;
end;

function JSONstringify(so: IJson): string;
begin
  result := so.ToJSON;
end;

function ReadJsonFloat(const dados: string; chave: string): Extended;
var
  I: IJson;
begin
  I := JSONParse(dados);
  try
    I.TryGetValue<Extended>(chave, result);
  finally
    I.Free;
  end;
end;

function ReadJsonString(const dados: string; chave: string): string;
var
  j: TJson;
  I: IJson;
  V: string;
begin
  j := JSONParse(dados);
  // usar variavel local para não gerar conflito com Multi_threaded application
  try
    j.TryGetValue<string>(chave, V);
    result := V;
    { case VarTypeToDataType of
      varString: Result := I.S[chave];
      varInt64: Result := IntToStr(I.I[chave]);
      varDouble,varCurrency: Result := FloatToStr(I.F[chave]);
      varBoolean: Result := BoolToStr(  I.B[chave] );
      varDate: Result := DateToStr(I.D[chave]);
      else
      result :=  I.V[chave];
      end; }
  finally
    j.Free;
  end;
end;

(* function ReadJsonObject(const dados: string; chave: string): IJson;
  var
  j: TJson;
  begin
  result := JSONParse(dados);
  { // usar variavel local para não gerar conflito com Multi_threaded application
  try
  result := j.parse(dados);
  finally
  j.Free;
  end;}
  end;
*)
function ReadJsonInteger(const dados: string; chave: string): integer;
var
  j: TJson;
  I: IJson;
begin
  j := JSONParse(dados);
  // usar variavel local para não gerar conflito com Multi_threaded application
  try
    j.TryGetValue<integer>(chave, result);
  finally
    j.Free;
  end;
end;

{$IFNDEF MULTI_THREADED}

function JSON: TJson;
begin
  if not assigned(LJson) then
    LJson := TJson.Create;
  result := LJson;
end;

procedure JSONFree;
begin
  if assigned(LJson) then
    FreeAndNil(LJson);
end;
{$ENDIF}
{ TJSONObjectHelper }

function TJSONObjectHelper.A(chave: string): TJSONArray;
begin
  // result := TJsonArray.Create;
  TryGetValue<TJSONArray>(chave, result);
end;

function TJSONObjectHelper.addPair(chave: string; Value: integer): TJSONObject;
begin
  result := addPair(chave, TJSONNumber.Create(Value));
end;

function TJSONObjectHelper.addPair(chave: string; Value: Double): TJSONObject;
begin
  result := addPair(chave, TJSONNumber.Create(Value));
end;

function TJSONObjectHelper.addPair(chave: string; Value: TDatetime)
  : TJSONObject;
var
  S: string;
begin
  if trunc(Value) <> Value then
    S := ISODateTimeToString(Value)
  else
    S := ISODateToString(Value);
  result := addPair(chave, S);
end;

function TJSONObjectHelper.AsArray: TJSONArray;
begin
  result := TJSONObject.ParseJSONValue(self.ToJSON) as TJSONArray;
end;

function TJSONObjectHelper.B(chave: string): boolean;
begin
  TryGetValue<boolean>(chave, result);
end;

function TJSONObjectHelper.Coalesce(chave, Value: string): TJsonPair;
begin
  if not Contains(chave) then
    addPair(chave, Value); // se nao existe, adiciona;
  result := Get(chave);
end;

function TJSONObjectHelper.Contains(chave: string): boolean;
var
  LJSONValue: TJsonValue;
begin
  LJSONValue := FindValue(chave);
  result := LJSONValue <> nil;
end;

function TJSONObjectHelper.F(chave: string): Extended;
begin
  result := 0;
  if FindValue(chave) <> nil then
    TryGetValue<Extended>(chave, result);
end;

function TJSONObjectHelper.Find(chave: string): TJsonValue;
begin
  result := inherited FindValue(chave);
end;

function TJSONObjectHelper.I(chave: string): integer;
begin
  result := 0;
  if FindValue(chave) <> nil then
    TryGetValue<integer>(chave, result);
end;

function TJSONObjectHelper.O(index: integer): TJSONObject;
var
  pair: TJsonPair;
begin
  result := TJSONObject(Get(index));
end;

function TJSONObjectHelper.O(chave: string): TJSONObject;
var
  V: TJsonValue;
begin
  V := GetValue(chave);
  result := V as TJSONObject;
  // TryGetValue<TJSONObject>(chave, result);
end;

class function TJSONObjectHelper.Parse(const dados: string): TJSONObject;
begin
  result := TJSONObject.ParseJSONValue(dados) as TJSONObject;
end;

{$ifndef BPL}
class function TJSONObjectHelper.FromRecord<T>(rec: T): TJSONObject;
var
  m: TJSONMarshal;
  js: TJsonValue;
begin
  result := TJSONObject.FromObject<T>(rec);
end;
{$endif}

class function TJSONObjectHelper.FromObject<T>(AObject: T): TJSONObject;
var
  typ: TRttiType;
  ctx: TRttiContext;
  field: TRttiField;
  tk: TTypeKind;
  P: Pointer;
  key: String;
  FRecord: TRttiRecordType;
  FMethod: TRttiMethod;
  LAttr: TCustomAttribute;
  LContinue: boolean;
begin
  result := TJSONObject.Create;
  ctx := TRttiContext.Create;
  typ := ctx.GetType(TypeInfo(T));
  P := @AObject;
  for field in typ.GetFields do
  begin
    try
      LContinue := true;
      for LAttr in field.GetAttributes do
      begin
        if LAttr is HideAttribute then
          LContinue := false;
      end;
      if not LContinue then
        continue;

      key := field.Name.ToLower;
      if not(field.Visibility in [mvPublic, mvPublished]) then
        continue;

      tk := field.FieldType.TypeKind;
      case tk of
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
          result.addPair(key, TJSONNumber.Create(field.GetValue(P).AsInteger));
        tkFloat:
          begin // System.Classes.Helper
            if sametext(field.FieldType.Name, 'TDateTime') then
              result.addPair(TJsonPair.Create(key,
                ISODateTimeToString(field.GetValue(P).asExtended)))
            else if sametext(field.FieldType.Name, 'TDate') then
              result.addPair(TJsonPair.Create(key,
                ISODateToString(field.GetValue(P).asExtended)))
            else if sametext(field.FieldType.Name, 'TTime') then
              result.addPair(TJsonPair.Create(key,
                ISOTimeToString(field.GetValue(P).asExtended)))
            else if sametext(field.FieldType.Name, 'TTimeStamp') then
              result.addPair(TJsonPair.Create(key,
                ISODateTimeToString(field.GetValue(P).asExtended)))
            else
              result.addPair(key,
                TJSONNumber.Create(field.GetValue(P).asExtended));
          end
      else
        result.addPair(TJsonPair.Create(key, field.GetValue(P).ToString));
      end;
    except
    end;
  end;

end;

function TJSONObjectHelper.S(chave: string): string;
begin
  TryGetValue<string>(chave, result);
end;

procedure TJSONObjectHelper.SetValueBase(chave: string; const Value: string);
var
  V: TJsonPair;
begin
  V := Get(chave);
  if not assigned(V) then
    addPair(chave, Value)
  else
  begin
    V.JsonValue := TJSONString.Create(Value);
  end;
end;

class function TJSONObjectHelper.Stringify(so: TJSONObject): string;
begin
  result := so.ToJSON;
end;

class function TJSONValueHelper.ToRecord<T>(AJson: string): T;
var
  j: TJsonValue;
begin
  j := TJSONObject.ParseJSONValue(AJson);
  try
    result := (j).ToRecord<T>;
  finally
    j.Free;
  end;
end;

function TJSONValueHelper.ToRecord<T>(var ARec: T): T;
var
  AContext: TRttiContext;
  ARecord: TRttiRecordType;
  AField: TRttiField;
  AJsonValue: TJsonPair;
  AValue: TValue;
  AFieldName: String;
  j: TJSONObject;
begin
  AContext := TRttiContext.Create;
  try

    ARecord := AContext.GetType(TypeInfo(T)).AsRecord;
    j := self as TJSONObject;
    for AField in ARecord.GetFields do
    begin
      try
        AFieldName := lowercase(AField.Name);
        if FindValue(AFieldName) = nil then
          continue;
        AJsonValue := j.Get(AFieldName);

        case AField.FieldType.TypeKind of
          tkFloat: // Also for TDateTime !
            begin
              if sametext(AField.FieldType.Name, 'TDateTime') then
                AValue := ISOStrToDateTime(AJsonValue.JsonValue.Value)
              else if sametext(AField.FieldType.Name, 'TTime') then
                AValue := ISOStrToTime(AJsonValue.JsonValue.Value)
              else
                AValue := StrToFloatDef(AJsonValue.JsonValue.Value, 0);
              AField.SetValue(@ARec, AValue);
            end;
          tkInteger:
            begin
              AValue := AJsonValue.JsonValue.Value;
              AField.SetValue(@ARec, AValue);
            end;
          tkUString, tkLString:
            begin
              AValue := AJsonValue.JsonValue.Value;
              AField.SetValue(@ARec, AValue);
            end;
        else
          if sametext(AField.FieldType.Name, 'Boolean') then
          begin
            AValue := sametext(AJsonValue.JsonValue.Value, 'true');
            AField.SetValue(@ARec, AValue);
          end;
          // You should add other types as well
        end;
      except
      end;
    end;
  finally
    AContext.Free;
  end;
  result := ARec;

end;

function TJSONValueHelper.ToRecord<T>(): T;
var
  AContext: TRttiContext;
  ARecord: TRttiRecordType;
  AField: TRttiField;
  AJsonValue: TJsonPair;
  AValue: TValue;
  AFieldName: String;
  j: TJSONObject;
begin
  AContext := TRttiContext.Create;
  try
    ARecord := AContext.GetType(TypeInfo(T)).AsRecord;
    j := self as TJSONObject;
    for AField in ARecord.GetFields do
    begin
      try
        AFieldName := lowercase(AField.Name);
        if FindValue(AFieldName) = nil then
          continue;
        AJsonValue := j.Get(AFieldName);

        case AField.FieldType.TypeKind of
          tkFloat: // Also for TDateTime !
            begin
              if sametext(AField.FieldType.Name, 'TDateTime') then
                AValue := ISOStrToDateTime(AJsonValue.JsonValue.Value)
              else if sametext(AField.FieldType.Name, 'TTime') then
                AValue := ISOStrToTime(AJsonValue.JsonValue.Value)
              else
                AValue := StrToFloatDef(AJsonValue.JsonValue.Value, 0);
              AField.SetValue(@result, AValue);
            end;
          tkInteger:
            begin
              AValue := AJsonValue.JsonValue.Value;
              AField.SetValue(@result, AValue);
            end;
          tkUString, tkLString:
            begin
              AValue := AJsonValue.JsonValue.Value;
              AField.SetValue(@result, AValue);
            end;
        else
          if sametext(AField.FieldType.Name, 'Boolean') then
          begin
            AValue := sametext(AJsonValue.JsonValue.Value, 'true');
            AField.SetValue(@result, AValue);
          end;
          // You should add other types as well
        end;
      except
      end;
    end;
  finally
    AContext.Free;
  end;
end;

function TJSONObjectHelper.V(chave: String): variant;
var
  V: string;
begin
  TryGetValue<string>(chave, V);
  result := V;
end;

{$ifndef BPL}
function TJSONObjectHelper.asObject: System.TObject;
var
  m: TJSONunMarshal;
begin
  m := TJSONunMarshal.Create;
  try
    result := m.Unmarshal(self);
  finally
    m.Free;
  end;
end;
{$endif}

{$IFDEF VER270}

function TJSONObjectHelper.ToJSON: string;
begin
  result := ToString;
end;
{$ENDIF}
{ TJSONArrayHelper }

function TJSONArrayHelper.Find(AJson: string): TJSONObject;
var
  j: TJSONObject;
  it: TJsonValue;
  P: TJsonPair;
  r: boolean;
  tmp: TJSONObject;
begin
  result := nil;
  j := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
  for it in self do
  begin
    tmp := it as TJSONObject;
    r := true;
    for P in j do
    begin
      if not tmp.Contains(P.JsonString.Value) then
      begin
        r := false;
        exit;
      end;
      r := r and sametext(tmp.GetValue<string>(P.JsonString.Value),
        it.GetValue<string>(P.JsonString.Value));
    end;
    if r then
    begin
      result := tmp;
      exit;
    end;
  end;
end;

function TJSONArrayHelper.Length: integer;
begin
  result := Count;
end;

{ TJSONValueHelper }
{$IFDEF VER270}

function TJSONValueHelper.ToJSON: string;
begin
  result := ToString;
end;
{$ENDIF}
{ TJSONValueHelper }

function TJSONValueHelper.AsArray: TJSONArray;
begin
  result := self as TJSONArray;
end;

function TJSONValueHelper.AsInteger: integer;
begin
  TryGetValue<integer>(result);
end;

function TJSONValueHelper.asObject: TJSONObject;
begin
  result := self as TJSONObject;
end;

function TJSONValueHelper.AsPair: TJsonPair;
begin
  result := TJsonPair(self);
end;

function TJSONValueHelper.Datatype: TJsonType;
begin
  result := TJSONObject.GetJsonType(self);
end;

class procedure TJSONValueHelper.GetRecordList<T>
  (AList: TJsonValuesList; ARec: T);
var
  AContext: TRttiContext;
  ARecord: TRttiRecordType;
  AField: TRttiField;
  AJsonValue: TJsonPair;
  AValue: TValue;
  AFieldName: String;
  j: TJSONObject;
  APair: TJsonPair;
begin
  AContext := TRttiContext.Create;
  try
    ARecord := AContext.GetType(TypeInfo(T)).AsRecord;
    for AField in ARecord.GetFields do
    begin
      AFieldName := lowercase(AField.Name);
      AValue := AField.GetValue(@ARec);
      APair := nil;
      case AField.FieldType.TypeKind of
        tkInteger, tkFloat, tkInt64:
          APair := TJsonPair.Create(AFieldName,
            TJSONNumber.Create(AValue.asExtended));
        tkString, tkWString, tkLString, tkChar, tkWChar, tkUString:
          APair := TJsonPair.Create(AFieldName, AValue.AsString);
      else
        if sametext(AField.FieldType.Name, 'Boolean') then
        begin
          APair := TJsonPair.Create(AFieldName,
            TJSONBool.Create(AValue.AsBoolean));
        end;
      end;
      if assigned(APair) then
        AList.Add(APair);
    end;
  finally
    AContext.Free;
  end;

end;

{ TJSONPairHelper }

function TJSONPairHelper.asObject: TJSONObject;
begin
  result := (self.JsonValue) as TJSONObject;
end;

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
begin
  if  DateTimeAsString.Contains('T') then
    result := System.DateUtils.ISO8601ToDate(DateTimeAsString)
  else
    result := StrToDateTime(DateTimeAsString);
end;

function ISOStrToTime(TimeAsString: string): TTime;
begin
  result := EncodeTime(StrToInt(Copy(TimeAsString, 1, 2)),
    StrToInt(Copy(TimeAsString, 4, 2)), StrToInt(Copy(TimeAsString, 7, 2)), 0);
end;

function ISOStrToDate(DateAsString: string): TDate;
begin
  result := System.DateUtils.ISO8601ToDate(DateAsString);
end;

function JSONStoreError(msg: string): TJsonValue;
var
  js: TJSONObject;
begin
  js := TJSONObject.Create;
  js.addPair('error', msg);
  js.addPair('ok', 'false');
  result := js;
end;

{ TJsonValuesList }

function TJsonValuesList.GetNames(AName: string): TJsonPair;
var
  I: integer;
  fld: string;
begin
  result := nil;
  fld := lowercase(AName);
  for I := 0 to Count - 1 do
    if sametext(Items[I].JsonString.Value, fld) then
    begin
      result := Items[I];
      exit;
    end;
end;

procedure TJsonValuesList.SetNames(AName: string; const Value: TJsonPair);
var
  I: integer;
  fld: string;
begin
  fld := lowercase(AName);
  for I := 0 to Count - 1 do
    if sametext(Items[I].JsonString.Value, fld) then
    begin
      Items[I] := Value;
      exit;
    end;
end;

initialization

finalization

{$IFNDEF MULTI_THREADED}
  JSONFree;
{$ENDIF}

end.
