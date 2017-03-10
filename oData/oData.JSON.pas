{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.JSON;

interface

Uses System.Classes, System.SysUtils, System.JSON;

type

  IJsonObject = interface
    ['{C4AB29A2-0F6B-4430-BBB1-F9EA6A460B88}']
    function JSON: TJsonValue;
    function AsArray: TJsonArray;
    function JSONObject: TJSONObject;
    function JsonValue:TJsonValue;
  end;


  TJsonType = (jtUnknown, jtObject, jtArray, jtString, jtTrue, jtFalse,
    jtNumber, jtDate, jtDateTime, jtBytes);

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
    function JsonValue:TJsonValue;

    class function GetJsonType(AJsonValue: TJsonValue): TJsonType;overload; static;
    class function GetJsonType(AJsonValue: TJsonPair): TJsonType;overload; static;
  end;



implementation

uses System.RegularExpressions;

class function TInterfacedJsonObject.GetJsonType(AJsonValue: TJsonValue): TJsonType;
var
  LJsonString: TJSONString;
begin

  if AJsonValue is TJSONObject then
    Result := jtObject
  else if AJsonValue is TJsonArray then
    Result := jtArray
  else if (AJsonValue is TJSONNumber) then
    Result := jtNumber
  else if AJsonValue is TJSONTrue then
    Result := jtTrue
  else if AJsonValue is TJSONFalse then
    Result := jtFalse
  else if AJsonValue is TJSONString then
  begin
    LJsonString := (AJsonValue as TJSONString);
    if TRegEx.IsMatch(LJsonString.Value,
      '^([0-9]{4})-?(1[0-2]|0[1-9])-?(3[01]|0[1-9]|[12][0-9])(T| )(2[0-3]|[01][0-9]):?([0-5][0-9]):?([0-5][0-9])$')
    then
      Result := jtDateTime
    else if TRegEx.IsMatch(LJsonString.Value,
      '^([0-9]{4})(-?)(1[0-2]|0[1-9])\2(3[01]|0[1-9]|[12][0-9])$') then
      Result := jtDate
    else
      Result := jtString
  end
  else
    Result := jtUnknown;
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

class function TInterfacedJsonObject.GetJsonType(
  AJsonValue: TJsonPair): TJsonType;
var j:TJsonValue;
begin
    result := getjsonType(AJsonValue.JsonValue );
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
   result:= FJson;
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
