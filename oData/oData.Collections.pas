unit oData.Collections;

interface

uses System.Classes, System.SysUtils, System.Generics.Collections, oData.Interf;

type
  TODataDictionay = class(TInterfacedObject, IODataDecodeParams)
  private
    FList: TDictionary<string, string>;
    FOperators: TStringList;
  public
    constructor create;
    destructor destroy; override;
    procedure AddPair(AKey: string; AValue: string);
    procedure AddOperator(const AOperator: string);
    procedure Clear;
    function Count: integer;
    function ContainKey(AKey: string): boolean;
    function KeyOfIndex(const idx: integer): string;
    function OperatorOfIndex(const idx: integer): string;
    function ValueOfIndex(const idx: integer): string;
  end;

implementation

{ TODataDictionay }

procedure TODataDictionay.AddOperator(const AOperator: string);
begin
  FOperators.Add(AOperator);
end;

procedure TODataDictionay.AddPair(AKey: string; AValue: string);
begin
  FList.Add(AKey, AValue);
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
  FOperators := TStringList.create;
end;

destructor TODataDictionay.destroy;
begin
  FList.Free;
  FOperators.Free;
  inherited;
end;

function TODataDictionay.KeyOfIndex(const idx: integer): string;
begin
  result := FList.Keys.ToArray[idx];
end;

function TODataDictionay.OperatorOfIndex(const idx: integer): string;
begin
  result := FOperators[idx];
end;

function TODataDictionay.ValueOfIndex(const idx: integer): string;
begin
  result := FList.Values.ToArray[idx];
end;

end.
