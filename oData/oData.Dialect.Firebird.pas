{//************************************************************//}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 03/03/2017                                           //}
{//************************************************************//}
unit oData.Dialect.Firebird;

interface

uses System.Classes, System.SysUtils, oData.Interf, oData.Dialect;

type
  TODataDialectFirebird = class(TODataDialect)
  private
      function TopCmdAfterSelectStmt(nTop, nSkip: integer): string; override;
    function TopCmdAfterFromStmt(nTop, nSkip: integer): string; override;
    function TopCmdStmt: string; override;
    function SkipCmdStmt: string; override;
  public
    function createGETQuery(oData: IODataDecode; AFilter: string;
      const AInLineCount: Boolean = false): string; override;
  end;

implementation

uses oData.ServiceModel;

{ TODataDialectFirebird }



function TODataDialectFirebird.createGETQuery(oData: IODataDecode; AFilter: string;
  const AInLineCount: Boolean): string;
begin
   result := inherited;
end;


function TODataDialectFirebird.SkipCmdStmt: string;
begin
     result := ' skip ';
end;

function TODataDialectFirebird.TopCmdAfterFromStmt(nTop,
  nSkip: integer): string;
begin
  result := '';
end;

function TODataDialectFirebird.TopCmdAfterSelectStmt(nTop,
  nSkip: integer): string;
begin
   CreateTopSkip(result,nTop,nSkip);
end;

function TODataDialectFirebird.TopCmdStmt: string;
begin
  result := ' first ';
end;

end.
