{//************************************************************//}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 03/03/2017                                           //}
{//************************************************************//}
unit oData.Dialect.MySQL;

interface

uses System.Classes, System.SysUtils, oData.Interf, oData.Dialect;

type
  TODataDialectMySQL = class(TODataDialect)
  private
  public
    function createQuery(oData: IODataDecode; AFilter: string;
      const AInLineCount: Boolean = false): string; override;
  end;

implementation

{ TODataDialectMySQL }

function TODataDialectMySQL.createQuery(oData: IODataDecode; AFilter: string;
  const AInLineCount: Boolean): string;
begin
  result := inherited;
end;

end.
