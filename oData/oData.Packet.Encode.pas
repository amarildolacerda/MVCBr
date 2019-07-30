unit oData.Packet.Encode;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Json,
  Data.DB;

type

  TODataJsonPacket = class;

  IODataJsonPacket = interface(TFunc<TODataJsonPacket>)
    ['{88A83ED1-2A49-44B4-B79D-9BB731B9D321}']
  end;

  TODataJsonPacket = class(TInterfacedObject, IODataJsonPacket)
  protected
    FOwned: boolean;
    FJson: TJsonObject;
    function Invoke: TODataJsonPacket;
  public
    constructor Create(AContext: string); overload;
    constructor Create(); overload;
    destructor Destroy; override;
    class function New(AContext: string): IODataJsonPacket;
    function This: TJsonValue;
    function AsJsonObject: TJsonObject;
    function TryGetValue<T>(AChave: string; out AValue: T): boolean;
    function Contexts(AValue: string): TODataJsonPacket; virtual;
    procedure Starts; virtual;
    function Values(AJson: TJsonArray; AOwned: boolean): TODataJsonPacket;
    function addPair(Key, Value: string): TODataJsonPacket;
    function GenValue(AChave: String; AValue: String): TODataJsonPacket;
    function Tops(AValue: integer): TODataJsonPacket;
    function Skips(AValue: integer): TODataJsonPacket;
    function Ends: TODataJsonPacket; virtual;
    procedure Counts(ACount: integer); virtual;
    class function Error(cod: integer; mess: string): string;
  end;

implementation

uses MVCFramework.DataSet.Utils, System.Json.Helper, System.DateUtils;

{ TODataJsonPacket }

function TODataJsonPacket.addPair(Key, Value: string): TODataJsonPacket;
begin
  result := self;
  FJson.addPair(Key, Value);
end;

function TODataJsonPacket.AsJsonObject: TJsonObject;
begin
  result := FJson;
end;

function TODataJsonPacket.Contexts(AValue: string): TODataJsonPacket;
const
  _context = '@odata.context';
var
  js: TJsonPair;
begin
  if TryGetValue<TJsonPair>(_context, js) then
  begin
    // trick for change value
    js.JsonValue.Free;
    js.JsonValue := TJSONString.Create(AValue)
  end
  else
    FJson.addPair(_context, AValue);
end;

procedure TODataJsonPacket.Counts(ACount: integer);
var
  obj: TObject;
const
  _name = '@odata.count';
begin
  obj := FJson.RemovePair(_name);
  if Assigned(obj) then
    freeAndNil(obj);
  FJson.addPair(_name, ACount);
end;

constructor TODataJsonPacket.Create;
begin
  raise exception.Create
    ('Do create with ..create(context,owned) insteadof create');
end;

constructor TODataJsonPacket.Create(AContext: string);
begin
  inherited Create;
  FJson := TJsonObject.Create;
  FOwned := true; // AOwned;
  Contexts(AContext);
  Starts;
end;

destructor TODataJsonPacket.Destroy;
begin
  if Assigned(FJSON) then
    FreeAndNil(FJson);
  inherited;
end;

function TODataJsonPacket.Ends: TODataJsonPacket;
begin
  result := self;
  FJson.addPair('EndsAt', DateToISO8601(now));
end;

class function TODataJsonPacket.Error(cod: integer; mess: string): string;
var
 obj : TJSONObject;
begin
 try
  obj := TJsonObject.Create;
  obj.addPair('Error', cod);
  obj.addPair('Message', mess);
  Result := obj.toString;
 finally
   obj.Free;
 end;
end;

function TODataJsonPacket.GenValue(AChave, AValue: String): TODataJsonPacket;
var
  arr: TJsonArray;
begin
  arr := TJsonArray.Create;
  arr.AddElement(TJsonValue.New(AChave, AValue));
  Values(arr, true);
  Ends;
end;

function TODataJsonPacket.Invoke: TODataJsonPacket;
begin
  result := self;
end;

class function TODataJsonPacket.New(AContext: string): IODataJsonPacket;
begin
  result := TODataJsonPacket.Create(AContext);
end;

function TODataJsonPacket.Skips(AValue: integer): TODataJsonPacket;
begin
  result := self;
  if AValue > 0 then
    FJson.addPair('@odata.skip', AValue);
end;

procedure TODataJsonPacket.Starts;
begin
  FJson.addPair('StartsAt', DateToISO8601(now));
end;

function TODataJsonPacket.This: TJsonValue;
begin
  result := FJson;
end;

function TODataJsonPacket.Tops(AValue: integer): TODataJsonPacket;
begin
  result := self;
  if AValue > 0 then
    FJson.addPair('@odata.top', AValue);
end;

function TODataJsonPacket.TryGetValue<T>(AChave: string; out AValue: T)
  : boolean;
begin
  result := FJson.TryGetValue<T>(AChave, AValue);
end;

function TODataJsonPacket.Values(AJson: TJsonArray; AOwned: boolean)
  : TODataJsonPacket;
begin
  result := self;
  AJson.Owned := AOwned;
  FJson.addPair('value', AJson);
  Counts(AJson.Length);
end;

end.
