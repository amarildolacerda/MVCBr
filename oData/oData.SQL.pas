{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.SQL;

interface

uses System.Classes, System.SysUtils, Data.DB,
  idURI, System.JSON, oData.ServiceModel,
  oData.Interf, oData.Dialect,
  oData.ProxyBase, oData.parse,
  MVCFramework;

type

  TODataSQL = class(TODataBase)
  private
  protected
    FResource: IJsonODastaServiceResource;
    function EncodeFilterSql(AFilter: string): string; virtual;
  public
    function QueryClass: TDatasetClass; virtual;
    function Select: string; virtual;
    function CreateQuery(FParse: IODataParse; AInLineCount: boolean = false)
      : string; virtual;
    function createSearchFields(FParse: IODataParse; const ASearch: String;
      const fields: string): String; virtual;
    function CreateDeleteQuery(FParse: IODataParse; AJsonBody: TJsonValue)
      : string; virtual;
    function CreatePOSTQuery(FParse: IODataParse; AJsonBody: TJsonValue)
      : string; virtual;
    function CreatePATCHQuery(FParse: IODataParse; AJsonBody: TJsonValue)
      : string; virtual;
    function Collection: string; override;

    procedure DecodeODataURL(CTX: TObject); override;

    function GetDataset(var JSONResponse: TJSONObject): TObject; override;
    function ExecuteDelete(ABody: string; var JSONResponse: TJSONObject)
      : Integer; override;

  end;

implementation

uses oData.JSON, oData.Engine;

{ TODataQuery }

function TODataSQL.Collection: string;
begin
  result := FODataParse.oData.Resource;
end;

function TODataSQL.CreateDeleteQuery(FParse: IODataParse;
  AJsonBody: TJsonValue): string;
begin
  result := AdapterAPI.CreateDeleteQuery(FParse.oData, AJsonBody);
  FResource := AdapterAPI.GetResource as IJsonODastaServiceResource;
end;

function TODataSQL.CreatePATCHQuery(FParse: IODataParse;
  AJsonBody: TJsonValue): string;
var
  LJson: IJsonObject;
  LRowState: string;
const
   cRowState = 'rowstate';
   cModified = 'modified';
   cDeleted = 'deleted';
   cInserted = 'inserted';
begin
  LJson := TInterfacedJsonObject.New(AJsonBody);
  if LJson.JsonObject.TryGetValue<string>(cRowState, LRowState) then
  begin
    if LRowState = cModified then
      result := AdapterAPI.CreatePATCHQuery(FParse.oData, AJsonBody)
    else if LRowState = cDeleted then
      result := AdapterAPI.CreateDeleteQuery(FParse.oData, AJsonBody)
    else if LRowState = cInserted then
      result := AdapterAPI.CreatePOSTQuery(FParse.oData, AJsonBody)
    else
      raise Exception.Create(tODataError.Create(500, 'RowState inválido'));
  end
  else
    result := AdapterAPI.CreatePATCHQuery(FParse.oData, AJsonBody);
  FResource := AdapterAPI.GetResource as IJsonODastaServiceResource;
end;

function TODataSQL.CreatePOSTQuery(FParse: IODataParse;
  AJsonBody: TJsonValue): string;
begin
  result := AdapterAPI.CreatePOSTQuery(FParse.oData, AJsonBody);
  FResource := AdapterAPI.GetResource as IJsonODastaServiceResource;
end;

function TODataSQL.CreateQuery(FParse: IODataParse;
  AInLineCount: boolean = false): string;
begin
  result := AdapterAPI.CreateQuery(FParse.oData,
    EncodeFilterSql(FParse.oData.Filter), AInLineCount);
  FResource := AdapterAPI.GetResource as IJsonODastaServiceResource;

end;

function TODataSQL.createSearchFields(FParse: IODataParse;
  const ASearch: String; const fields: string): String;
var
  str: TStringList;
  i: Integer;
  LSearch:string;
begin
  LSearch := stringReplace(TIdURI.URLDecode(ASearch),'''','',[rfReplaceAll]);
  result := '';
  if fields = '' then
    exit;

    

  str := TStringList.Create;
  try
    str.Delimiter := ',';
    str.DelimitedText := fields;
    for i := 0 to str.Count - 1 do
    begin
      if result <> '' then
        result := result + ' or ';
      result := result + str[i] + ' like (''%' + LSearch + '%'')';
    end;
  finally
    str.Free;
  end;
end;

procedure TODataSQL.DecodeODataURL(CTX: TObject);
var
  url: string;
begin
  inherited;
  FODataParse := TODataParse.Create;
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

function TODataSQL.ExecuteDelete(ABody: string;
  var JSONResponse: TJSONObject): Integer;
begin
  result := 0;
end;

function TODataSQL.GetDataset(var JSONResponse: TJSONObject): TObject;
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
