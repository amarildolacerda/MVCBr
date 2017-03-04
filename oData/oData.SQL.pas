{//************************************************************//}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 03/03/2017                                           //}
{//************************************************************//}
unit oData.SQL;

interface

uses System.Classes, System.SysUtils, Data.DB,
  idURI,
  oData.Interf, oData.Dialect,
  oData.ProxyBase, oData.parse,
  MVCFramework;

type

  TODataSQL = class(TODataBase)
  private
  protected
    function EncodeFilterSql(AFilter: string): string; virtual;
  public
    function QueryClass: TDatasetClass; virtual;
    function Select: string; virtual;
    function CreateQuery(FParse: IODataParse; AInLineCount: boolean = false)
      : string; virtual;
    function CreateDeleteQuery(FParse: IODataparse; AJson:string): string;virtual;
    function CreatePOSTQuery(FParse: IODataparse; AJson:string): string;virtual;

    function Collection: string; override;

    procedure DecodeODataURL(CTX: TObject); override;


    function GetDataset: TObject; override;
    function ExecuteDelete(ABody:string):Integer;override;


  end;

implementation

{ TODataQuery }

function TODataSQL.Collection: string;
begin
  result := FODataParse.oData.Resource;
end;

function TODataSQL.CreateDeleteQuery(FParse: IODataparse; AJson:string): string;
begin
   result := AdapterAPI.createDeleteQuery(FParse.oData,AJson);
end;

function TODataSQL.CreatePOSTQuery(FParse: IODataparse; AJson: string): string;
begin
   result := AdapterAPI.createPOSTQuery(FParse.oData,AJson);
end;

function TODataSQL.CreateQuery(FParse: IODataParse;
  AInLineCount: boolean = false): string;
begin
  result := AdapterAPI.CreateQuery(FParse.oData,
    EncodeFilterSql(FParse.oData.Filter), AInLineCount);
end;

procedure TODataSQL.DecodeODataURL(CTX: TObject);
var
  url: string;
begin
  inherited;
  FODataParse := TODataParse.create;
  try
    url := FCTX.Request.PathInfo;
    if FCTX.Request.QueryStringParams.Count > 0 then
    begin
      url := url + '?' + FCTX.Request.RawWebRequest.Query;
    end;
    FODataParse.parse(url);
  finally
  end;
end;

function TODataSQL.EncodeFilterSql(AFilter: string): string;
begin
  result := TODataParse.OperatorToString(AFilter);
end;


function TODataSQL.ExecuteDelete(ABody:string): Integer;
begin
  result := 0;
end;

function TODataSQL.GetDataset: TObject;
begin
  result := nil;
end;

function TODataSQL.QueryClass: TDatasetClass;
begin
  result := nil;
end;

function TODataSQL.Select: string;
begin
  result := FODataParse.oData.Select;
  if result = '' then
    result := '*';
end;

{ TODataSQLDialec }

end.
