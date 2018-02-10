{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.Dialect.Firebird;

interface

uses System.Classes, System.SysUtils, oData.Interf, oData.Dialect;

{$DEFINE ROWS_TO}

type
  TODataDialectFirebird = class(TODataDialect)
  private
    function TopCmdAfterSelectStmt(nTop, nSkip: integer): string; override;
    function TopCmdAfterFromStmt(nTop, nSkip: integer): string; override;
    function TopCmdAfterAtEndOfStmt(nTop, nSkip: integer): string; override;

    function TopCmdStmt: string; override;
    function SkipCmdStmt: string; override;
  public
    function createGETQuery(oData: TODataDecodeAbstract; AFilter: string;
      const AInLineCount: Boolean = false): string; override;
  end;

implementation
uses oData.ServiceModel;

{ TODataDialectFirebird }

function TODataDialectFirebird.createGETQuery(oData: TODataDecodeAbstract;
  AFilter: string; const AInLineCount: Boolean): string;
begin
  result := inherited;
end;

function TODataDialectFirebird.SkipCmdStmt: string;
begin
 {$ifdef ROWS_TO}
  result := ' to ';
 {$else}
  result := ' skip ';
 {$endif}
end;

function TODataDialectFirebird.TopCmdAfterAtEndOfStmt(nTop,
  nSkip: integer): string;
var ARows,ATo:integer;
begin
  result := '';
{$IFDEF ROWS_TO}
  ARows := nTop;
  ATo := 0;
  if nSkip>0 then
  begin
     ARows := nSkip+1;
     ATo := nSkip + nTop;
  end;
  CreateTopSkip(result, ARows, ATo);
{$ENDIF}

end;

function TODataDialectFirebird.TopCmdAfterFromStmt(nTop,
  nSkip: integer): string;
begin
  result := '';
end;

function TODataDialectFirebird.TopCmdAfterSelectStmt(nTop,
  nSkip: integer): string;
begin
  result := '';
{$IFNDEF ROWS_TO}
  CreateTopSkip(result, nTop, nSkip);
{$ENDIF}
end;

function TODataDialectFirebird.TopCmdStmt: string;
begin
{$IFDEF ROWS_TO}
  result := ' rows ';
{$ELSE}
  result := ' first ';
{$ENDIF}
end;

end.
