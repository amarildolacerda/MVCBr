unit UsesFixerParser;

interface

uses
  Classes, SysUtils,
  CastaliaPasLex, CastaliaSimplePasPar, CastaliaPasLexTypes;

type
  TUsesUnit = record
    UnitName: String;
    StartPosition: Integer;
  end;
  TUsesUnitArray = Array of TUsesUnit;

  TUsesFixer = class(TPersistent)
  private
    FEndPos: Integer; // Position of the SemiColon
    FStartPos: Integer; // Position immediately after "Uses"
    FSource: String;
    FUnits: TUsesUnitArray;
    procedure AddUnit(const AUnit: String; const APos: Integer);
    procedure Clear;
    function GetUnit(const AIndex: Integer): TUsesUnit;
    function UnitInClause(const AUnit: String): Boolean;
  public
    destructor Destroy; override;

    procedure AddUnitToUses(const AUnit: String);
    procedure DeleteUnit(const AUnit: String);
    procedure ProcessSource(const ASource: String);

    property Source: String read FSource;
    property Units[const AIndex: Integer]: TUsesUnit read GetUnit;
  end;

implementation

{ TUsesFixer }

procedure TUsesFixer.AddUnit(const AUnit: String; const APos: Integer);
var
  LIndex: Integer;
begin
  LIndex := Length(FUnits);
  SetLength(FUnits, LIndex + 1);
  FUnits[LIndex].UnitName := AUnit;
  FUnits[LIndex].StartPosition := APos - Length(AUnit);
end;

procedure TUsesFixer.AddUnitToUses(const AUnit: String);
var
  LBefore, LAfter: String;
begin
  if (not UnitInClause(AUnit)) then
  begin
    LBefore := Copy(FSource, 1, FStartPos + 1) + #13#10;
    LAfter := '  ' + AUnit + ',' + Copy(FSource, FStartPos + 1, Length(FSource));

    FSource := LBefore + LAfter;
    ProcessSource(LBefore + LAfter);
  end;
end;

procedure TUsesFixer.Clear;
begin
  FSource := '';
  SetLength(FUnits, 0);
end;

procedure TUsesFixer.DeleteUnit(const AUnit: String);
var
  I: Integer;
  LBefore, LAfter: String;
begin
  if UnitInClause(AUnit) then
  begin
    for I := Low(FUnits) to High(FUnits) do
      if UpperCase(AUnit) = UpperCase(FUnits[I].UnitName) then
      begin
        if (High(FUnits) > I + 1) then
        begin
          LBefore := Copy(FSource, 1, FUnits[I].StartPosition);
          LAfter := Copy(FSource, FUnits[I + 1].StartPosition, Length(FSource));
          FSource := LBefore + Lafter;
        end
        else// if I = Length(FUnits) then
        begin
          LBefore := Copy(FSource, 1, FUnits[I].StartPosition - 1);
          if LBefore[Length(LBefore) - 3] = ',' then
            LBefore[Length(LBefore) - 3] := ';';
          LAfter := Copy(FSource, FEndPos + 2, Length(FSource));
          FSource := LBefore + Lafter;
        end;
        Break;
      end;
    ProcessSource(LBefore + Lafter);
  end;
end;

destructor TUsesFixer.Destroy;
begin
  Clear;
  inherited;
end;

function TUsesFixer.GetUnit(const AIndex: Integer): TUsesUnit;
begin
  Result := FUnits[AIndex];
end;

procedure TUsesFixer.ProcessSource(const ASource: String);
var
  LLexer: TmwPasLex;
  LDoneUses: Boolean;
  LUsesItem: String;
begin
  Clear;
  FSource := ASource;
  LLexer := TMwPasLex.Create;
  try
    LLexer.Origin := PChar(FSource);
    LLexer.Init;
    LLexer.Next;
    LDoneUses := False;
    LUsesItem := '';
    while (LLexer.TokenID <> ptNull) and (not LDoneUses) do
    begin
      if LLexer.TokenID = ptUses then
      begin
        FStartPos := LLexer.TokenPos + LLexer.TokenLen;
        LLexer.Next;
        while (LLexer.TokenID <> ptNull) and (LLexer.TokenID <> ptSemiColon) do
        begin
          if LLexer.TokenID in [ptIdentifier, ptPoint] then
            LUsesItem := LUsesItem + LLexer.Token
          else
          begin
            if LUsesItem <> '' then
              AddUnit(LUsesItem, LLexer.TokenPos);
            LUsesItem := '';
          end;
          LLexer.Next;
        end;
        if LLexer.TokenID = ptSemiColon then
          FEndPos := LLexer.TokenPos;
        LDoneUses := True;
      end;
      LLexer.Next;
    end;
  finally
    LLexer.Free;
  end;
end;

function TUsesFixer.UnitInClause(const AUnit: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := Low(FUnits) to High(FUnits) do
    if UpperCase(FUnits[I].UnitName) = UpperCase(AUnit) then
    begin
      Result := True;
      Break;
    end;
end;

end.
