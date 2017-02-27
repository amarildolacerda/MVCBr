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
    function EncodeFilterSql(AFilter: string): string;virtual;
  public
    function QueryClass: TDatasetClass; virtual;
    function Select: string; virtual;
    function CreateQuery(FParse: IODataParse; AInLineCount:boolean=false): string; virtual;
    function Collection:string;override;

    procedure DecodeODataURL(CTX: TObject); override;
    function GetDataset: TObject; override;

  end;

implementation

{ TODataQuery }

function TODataSQL.Collection: string;
begin
  result := FODataParse.oData.Resource;
end;


function TODataSQL.CreateQuery(FParse: IODataParse; AInLineCount:boolean=false): string;
begin
    result := AdapterAPI.createQuery( FParse.oData, EncodeFilterSql(fParse.oData.Filter),AInLineCount);
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
    FODataParse.parse( TIdURI.URLDecode( url ));
  finally
  end;
end;


function TODataSQL.EncodeFilterSql(AFilter: string): string;
begin
  result := stringReplace(AFilter, ' lt ', ' < ', [rfReplaceAll]);
  result := stringReplace(result, ' ne ', ' <> ', [rfReplaceAll]);
  result := stringReplace(result, ' gt ', ' > ', [rfReplaceAll]);
  result := stringReplace(result, ' ge ', ' >= ', [rfReplaceAll]);
  result := stringReplace(result, ' le ', ' <= ', [rfReplaceAll]);
  result := stringReplace(result, ' eq ', ' = ', [rfReplaceAll]);
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
