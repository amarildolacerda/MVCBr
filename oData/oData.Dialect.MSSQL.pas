{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.Dialect.MSSQL;

interface

uses System.Classes, System.SysUtils, oData.Interf, oData.Dialect;

type
  TODataDialectMSSQL = class(TODataDialect)
  private
    function TopCmdAfterSelectStmt(nTop, nSkip: integer): string; override;
    function TopCmdAfterFromStmt(nTop, nSkip: integer): string; override;
    function TopCmdStmt: string; override;
    function SkipCmdStmt: string; override;
    procedure CreateTopSkip(var Result: string; nTop, nSkip: integer); override;
    function AfterCreateSQL(var SQL: string):boolean; override;

  public
    function createGETQuery(oData: IODataDecode; AFilter: string;
      const AInLineCount: Boolean = false): string; override;
  end;

implementation

uses oData.ServiceModel;

{ TODataDialectFirebird }

{
  Exemplo de TOP e SKIP
  select top 10 * from
  (
  select
  ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS iRowNumber , *
  from ctgrupo
  ) cte
  where cte.irowNumber>1
}

function TODataDialectMSSQL.AfterCreateSQL(var SQL: string): boolean;
var s:string;
begin
  // inherited;
  s := '';
  if FTop>0 then
    s := ' top '+intToStr(FTop);
  if FSkip>0 then
    Sql := 'select '+s+' * from ('+sql+') cte where cte.IRowNumber > '+IntTostr(FSkip);

  result := (FTop>0) or (FSkip>0);

end;

function TODataDialectMSSQL.createGETQuery(oData: IODataDecode; AFilter: string;
  const AInLineCount: Boolean): string;
begin
  Result := inherited;
end;

function TODataDialectMSSQL.SkipCmdStmt: string;
begin
  Result := ' ';
end;

function TODataDialectMSSQL.TopCmdAfterFromStmt(nTop, nSkip: integer): string;
begin
  Result := '';
end;

procedure TODataDialectMSSQL.CreateTopSkip(var Result: string;
  nTop, nSkip: integer);
begin
  FSkip := nSkip;
  FTop := nTop;
  // mySql/firebird;
  Result := TopCmdStmt + nTop.ToString + ' ';
   if nSkip > 0 then
    Result := ' ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS iRowNumber, ';

end;

function TODataDialectMSSQL.TopCmdAfterSelectStmt(nTop, nSkip: integer): string;
begin
  CreateTopSkip(Result, nTop, nSkip);
end;

function TODataDialectMSSQL.TopCmdStmt: string;
begin
  Result := ' top ';
end;

end.
