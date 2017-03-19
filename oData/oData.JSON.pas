{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.JSON;

interface

Uses System.Classes, System.SysUtils, System.JSON, System.JSON.Helper;

type

  IJsonObject = interface
    ['{C4AB29A2-0F6B-4430-BBB1-F9EA6A460B88}']
    function JSON: TJsonValue;
    function AsArray: TJsonArray;
    function JSONObject: TJSONObject;
    function JsonValue: TJsonValue;
  end;

  TInterfacedJsonObject = class(TInterfacedObject, IJsonObject)
  protected
    FJson: TJsonValue;
    FOwned: Boolean;
  public
    class function New(AJson: TJsonValue; AOwned: Boolean = false): IJsonObject;
    destructor destroy; override;
    function JSONObject: TJSONObject;
    function JSON: TJsonValue;
    function AsArray: TJsonArray;
    function JsonValue: TJsonValue;

    class function GetJsonType(AJsonValue: TJsonValue): TJsonType;
      overload; static;
    class function GetJsonType(AJsonValue: TJsonPair): TJsonType;
      overload; static;
  end;

implementation

uses System.RegularExpressions;

class function TInterfacedJsonObject.GetJsonType(AJsonValue: TJsonValue)
  : TJsonType;
begin
   result := TJSONObject.GetJsonType(aJsonValue);
end;

{ TInterfacedJsonObject }

function TInterfacedJsonObject.AsArray: TJsonArray;
begin
  JSON.TryGetValue<TJsonArray>(Result);
end;

destructor TInterfacedJsonObject.destroy;
begin
  if FOwned then
    FreeAndNil(FOwned);
  inherited;
end;

class function TInterfacedJsonObject.GetJsonType(AJsonValue: TJsonPair)
  : TJsonType;
var
  j: TJsonValue;
begin
  Result := GetJsonType(AJsonValue.JsonValue);
end;

function TInterfacedJsonObject.JSON: TJsonValue;
begin
  Result := FJson;
end;

function TInterfacedJsonObject.JSONObject: TJSONObject;
begin
  Result := FJson as TJSONObject;
end;

function TInterfacedJsonObject.JsonValue: TJsonValue;
begin
  Result := FJson;
end;

class function TInterfacedJsonObject.New(AJson: TJsonValue;
  AOwned: Boolean = false): IJsonObject;
var
  jo: TInterfacedJsonObject;
begin
  jo := TInterfacedJsonObject.create;
  jo.FJson := AJson;
  jo.FOwned := AOwned;
  Result := jo;
end;

end.
