unit oData.Collections;

interface

uses System.Classes, System.SysUtils, System.Generics.Collections, OData.Interf;

type
  TODataDictionay = class(TInterfacedObject, IODataDecodeParams)
  private
    FList: TDictionary<string, string>;
  public
    constructor create;
    destructor destroy; override;
    procedure AddPair(AKey: string; AValue: string);
    procedure Clear;
    function Count: integer;
    function ContainKey(AKey: string): boolean;
    function ValueOfIndex(const idx: integer): string;
  end;

implementation


{ TODataDictionay }

procedure TODataDictionay.AddPair(AKey: string; AValue: string);
begin
  FList.add(AKey, AValue);
end;

procedure TODataDictionay.Clear;
begin
  FList.Clear;
end;

function TODataDictionay.ContainKey(AKey: string): boolean;
begin
  result := FList.ContainsKey(AKey);
end;

function TODataDictionay.Count: integer;
begin
  result := FList.Count;
end;

constructor TODataDictionay.create;
begin
  inherited;
  FList := TDictionary<string, string>.create;
end;

destructor TODataDictionay.destroy;
begin
  FList.Free;
  inherited;
end;

function TODataDictionay.ValueOfIndex(const idx: integer): string;
var
  key: string;
  i: integer;
begin
  i := 0;
  result := FList.Values.ToArray[idx];
end;


end.
