unit oData.Packet.Decode;

interface

uses System.Classes, System.sysUtils, System.JSON;

type
  TODataJsonDecode = class;

  IODataJsonDecode = interface(TFunc<TODataJsonDecode>)
    ['{8640D0EF-EA37-4308-ABFF-FA0EC5A49370}']
  end;

  TODataJsonDecode = class(TInterfacedObject, IODataJsonDecode)
  private
    FendAt: TDatetime;
    Fcount: integer;
    Fvalue: TJsonArray;
    Fproperties: TJsonValue;
    Fkeys: string;
    FstartAt: TDatetime;
    procedure Setcount(const Value: integer);
    procedure SetendAt(const Value: TDatetime);
    procedure Setkeys(const Value: string);
    procedure Setproperties(const Value: TJsonValue);
    procedure SetstartAt(const Value: TDatetime);
    procedure Setvalue(const Value: TJsonArray);
  protected
    function Invoke: TODataJsonDecode;
    procedure InternalDecode(AJSON: TJsonValue);
  public
    destructor Destroy; override;
    class function Decode(JSON: TJsonValue): IODataJsonDecode;
    class function New(AJson: string): IODataJsonDecode; overload;
    class function New(AJson: TJsonValue): IODataJsonDecode; overload;
    property count: integer read Fcount write Setcount;
    property startsAt: TDatetime read FstartAt write SetstartAt;
    property endsAt: TDatetime read FendAt write SetendAt;
    property Value: TJsonArray read Fvalue write Setvalue;
    property keys: string read Fkeys write Setkeys;
    property properties: TJsonValue read Fproperties write Setproperties;
  end;

implementation

uses System.DateUtils;

{ TODataJsonDecode }

class function TODataJsonDecode.Decode(JSON: TJsonValue): IODataJsonDecode;
var
  r: TODataJsonDecode;
begin
  r := TODataJsonDecode.Create;
  r.InternalDecode(JSON);
  result := r;
end;

destructor TODataJsonDecode.Destroy;
begin
  FreeAndNil(Fvalue);
  FreeAndNil(Fproperties);
  inherited;
end;

procedure TODataJsonDecode.InternalDecode(AJSON: TJsonValue);
var
  p: TJsonPair;
begin
  for p in (AJSON as TJsonObject) do
  begin
    if p.JsonString.Value.Equals('@odata.count') then
      Fcount := strToIntDef(p.JsonValue.value,0)
    else if p.JsonString.Value.Equals('StartsAt') then
      FstartAt := ISO8601ToDate(p.JsonValue.Value)
    else if p.JsonString.Value.Equals('EndsAt') then
      FEndAt := ISO8601ToDate(p.JsonValue.Value)
    else if p.JsonString.Value.Equals('keys') then
      Fkeys := p.JsonValue.Value
    else if p.JsonString.Value.Equals('properties') then
      Fproperties := TJsonObject.ParseJSONValue(p.JsonValue.Value)
    else if p.JsonString.Value.Equals('value') then
      FValue := TJsonObject.ParseJSONValue(p.JsonValue.Value) as TJsonArray;

  end;
end;

function TODataJsonDecode.Invoke: TODataJsonDecode;
begin
  result := self;
end;

class function TODataJsonDecode.New(AJson: string): IODataJsonDecode;
var
  r: TODataJsonDecode;
  j: TJsonValue;
begin
  r := TODataJsonDecode.Create;
  j := TJsonObject.ParseJSONValue(AJson);
  try
    r.InternalDecode(j);
    result := r;
  finally
    j.Free;
  end;
end;

class function TODataJsonDecode.New(AJson: TJsonValue): IODataJsonDecode;
var
  r: TODataJsonDecode;
begin
  r := TODataJsonDecode.Create;
  r.InternalDecode(AJson);
  result := r;
end;

procedure TODataJsonDecode.Setcount(const Value: integer);
begin
  Fcount := Value;
end;

procedure TODataJsonDecode.SetendAt(const Value: TDatetime);
begin
  FendAt := Value;
end;

procedure TODataJsonDecode.Setkeys(const Value: string);
begin
  Fkeys := Value;
end;

procedure TODataJsonDecode.Setproperties(const Value: TJsonValue);
begin
  Fproperties := Value;
end;

procedure TODataJsonDecode.SetstartAt(const Value: TDatetime);
begin
  FstartAt := Value;
end;

procedure TODataJsonDecode.Setvalue(const Value: TJsonArray);
begin
  Fvalue := Value;
end;

end.
