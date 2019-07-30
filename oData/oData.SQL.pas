{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.SQL;

interface

uses System.Classes, System.SysUtils, Data.DB,
  idURI, oData.ServiceModel, System.JSON.Helper,
  oData.Interf, oData.Dialect, System.JSON,
  oData.ProxyBase, oData.parse,
  MVCFramework;

type

  TODataSQL = class(TODataBase)
  private
  protected
    FResource: IJsonODataServiceResource;
    function EncodeFilterSql(AFilter: string): string; overload; virtual;
    function LocalCreatePATCHQuery(FParse: IODataParse; AJsonBody: TJsonValue;
      AKeys: string; ALocalResource: TObject): string; virtual;
  public
    destructor Destroy; override;

    function GetConnection(ADataset: TDataset): TObject; virtual;
    function GetPrimaryKey(AConnection: TObject; ACollection: string)
      : string; virtual;

    procedure CreateEntitiesSchema(ADataset: TDataset;
      var JSONResponse: TJsonObject); overload; virtual;
    procedure CreateEntitiesSchema(ACollection: string; var AKey: string;
      ADataset: TDataset; var JSONResponse: TJsonObject); overload; virtual;

    function QueryClass: TDatasetClass; virtual;
    function Select: string; virtual;
    function CreateGETQuery(FParse: IODataParse; AInLineCount: boolean = false)
      : string; virtual;
    function CreateSearchFields(FParse: IODataParse; const ASearch: String;
      const fields: string): String; virtual;
    function CreateDeleteQuery(FParse: IODataParse; AJsonBody: TJsonValue;
      AKeys: string): string; virtual;
    function CreatePOSTQuery(FParse: IODataParse; AJsonBody: TJsonValue)
      : string; virtual;

    function CreatePATCHQuery(FParse: IODataParse; AJsonBody: TJsonValue;
      AKeys: string): string; virtual;
    function Collection: string; override;

    procedure DecodeODataURL(CTX: TObject); override;
    procedure ParseURL(AUrl: string); virtual;

    function ExecuteGET(AJsonBody: TJsonValue; out JSONResponse: TJsonObject)
      : TObject; override;
    function ExecuteDELETE(ABody: string; var JSONResponse: TJsonObject)
      : Integer; override;

  end;

implementation

uses oData.JSON, oData.Engine;

{ TODataQuery }

function TODataSQL.Collection: string;
begin
  result := FODataParse.oData.Resource;
end;

function TODataSQL.CreateDeleteQuery(FParse: IODataParse; AJsonBody: TJsonValue;
  AKeys: string): string;
begin
  result := AdapterAPI.CreateDeleteQuery(FParse.oData, AJsonBody, AKeys, nil);
  FResource := AdapterAPI.GetResource as IJsonODataServiceResource;
end;

procedure TODataSQL.CreateEntitiesSchema(ADataset: TDataset;
  var JSONResponse: TJsonObject);
var
  sKey: string;
begin
  sKey := FResource.primaryKey;
  if sKey = '' then
    sKey := FResource.KeyID;
  CreateEntitiesSchema(FResource.Collection, sKey, ADataset, JSONResponse);
  if FResource.primaryKey = '' then
    FResource.primaryKey := sKey;
end;

procedure TODataSQL.CreateEntitiesSchema(ACollection: string; var AKey: string;
  ADataset: TDataset; var JSONResponse: TJsonObject);
var
  fld: TField;
  jp: TJsonPair;
  jv: TJsonObject;
  ja: TJsonArray;
  LJv: TJsonObject;
  AName: String;
  sl: TStringList;
  s: string;
begin
  if (AKey = '') and (ACollection <> '') then
    AKey := GetPrimaryKey(GetConnection(ADataset), ACollection);
  if AKey <> '' then
  begin
    ja := TJsonArray.create;
    sl := TStringList.create;
    try
      sl.Delimiter := ',';
      sl.DelimitedText := AKey;
      for s in sl do
      begin
        ja.add(s);
      end;
      JSONResponse.AddPair(TJsonPair.create('keys', ja));
    finally
      sl.free;
    end;
  end;

  jv := TJsonObject.create;
  for fld in ADataset.fields do
  begin
    AName := fld.FieldName.ToLower;
    LJv := TJsonObject.create;
    case fld.DataType of
      ftInteger:
        begin
          LJv.AddPair(TJsonPair.create('Type', 'Int32'));
        end;
      ftSmallint, ftShortint, ftWord:
        begin
          LJv.AddPair(TJsonPair.create('Type', 'Int16'));
        end;
      ftLargeint:
        begin
          LJv.AddPair(TJsonPair.create('Type', 'Int64'));
        end;
      ftCurrency, ftBCD, ftFMTBcd:
        begin
          LJv.AddPair(TJsonPair.create('Type', 'Decimal'));
          LJv.AddPair(TJsonPair.create('Precision',
            TJSONNumber.create(TFloatField(fld).Precision)));
        end;
      ftFloat, ftSingle:
        begin
          LJv.AddPair(TJsonPair.create('Type', 'Float'));
          LJv.AddPair(TJsonPair.create('Precision',
            TJSONNumber.create(TFloatField(fld).Precision)));
          LJv.AddPair(TJsonPair.create('Scale', TJSONNumber.create(5)));
        end;
      fttime:
        begin
          LJv.AddPair(TJsonPair.create('Type', 'Time'));
        end;
      ftBlob:
        begin
          LJv.AddPair(TJsonPair.create('Type', 'Binary'));
        end;
      ftTimeStamp, ftDate, ftDatetime:
        begin
          LJv.AddPair(TJsonPair.create('Type', 'DateTime'));
        end;
      ftBoolean:
        begin
          LJv.AddPair(TJsonPair.create('Type', 'Boolean'));
        end;
      ftString, ftFixedChar, ftWideString:
        begin
          LJv.AddPair(TJsonPair.create('Type', 'String'));
          LJv.AddPair(TJsonPair.create('MaxLength',
            TJSONNumber.create(fld.Size)));
        end;
      ftMemo:
        begin
          LJv.AddPair(TJsonPair.create('Type', 'String'));
          LJv.AddPair(TJsonPair.create('MaxLength',
            TJSONNumber.create(255 * 255)));
        end;
      ftGUID:
        begin
          LJv.AddPair(TJsonPair.create('Type', 'String'));
          LJv.AddPair(TJsonPair.create('MaxLength', TJSONNumber.create(36)));
        end;

    end;

    if fld.Required then
      LJv.AddPair(TJsonPair.create('Nullable', 'false'));
    // else  // nao precisa mandar se � TRUE.
    // ja.AddElement(TJsonObject.create(TJsonPair.create('Nullable', 'true')));

    jv.AddPair(TJsonPair.create(AName, LJv));
  end;
  jp := TJsonPair.create('properties', jv);
  JSONResponse.AddPair(jp);
end;

function TODataSQL.CreatePATCHQuery(FParse: IODataParse; AJsonBody: TJsonValue;
  AKeys: string): string;
var
  LJson: IJsonObject;
  LRowState: string;
begin
  LJson := TInterfacedJson.New(AJsonBody.ToString,True);
  if LJson.JsonObject.TryGetValue<string>(cODataRowState, LRowState) then
  begin
    if (LRowState = cODataModified) or (LRowState = cODataModifiedORInserted)
    then
      result := LocalCreatePATCHQuery(FParse, AJsonBody, AKeys, nil)
    else if LRowState = cODataDeleted then
      result := AdapterAPI.CreateDeleteQuery(FParse.oData, AJsonBody,
        AKeys, nil)
    else if LRowState = cODataInserted then
      result := AdapterAPI.CreatePOSTQuery(FParse.oData, AJsonBody, nil)
    else
      raise Exception.create(tODataError.create(500, 'RowState inv�lido'));
  end
  else
    result := LocalCreatePATCHQuery(FParse, AJsonBody, AKeys, nil);
  FResource := AdapterAPI.GetResource as IJsonODataServiceResource;
end;

function TODataSQL.LocalCreatePATCHQuery(FParse: IODataParse;
  AJsonBody: TJsonValue; AKeys: string; ALocalResource: TObject): string;
var
  LJson: IJsonObject;
  LRowState: string;
begin
  LJson := TInterfacedJson.New(AJsonBody.ToString, True);
  if LJson.JsonObject.TryGetValue<string>(cODataRowState, LRowState) then
  begin
    if (LRowState = cODataModified) or (LRowState = cODataModifiedORInserted)
    then
      result := AdapterAPI.CreatePATCHQuery(FParse.oData, AJsonBody, AKeys,
        ALocalResource)
    else if LRowState = cODataDeleted then
      result := AdapterAPI.CreateDeleteQuery(FParse.oData, AJsonBody, AKeys,
        ALocalResource)
    else if LRowState = cODataInserted then
      result := AdapterAPI.CreatePOSTQuery(FParse.oData, AJsonBody,
        ALocalResource)
    else
      raise Exception.create(tODataError.create(500, 'RowState inv�lido'));
  end
  else
    result := AdapterAPI.CreatePATCHQuery(FParse.oData, AJsonBody, AKeys, nil);
  if not assigned(ALocalResource) then
    FResource := AdapterAPI.GetResource as IJsonODataServiceResource;
end;

function TODataSQL.CreatePOSTQuery(FParse: IODataParse;
  AJsonBody: TJsonValue): string;
begin
  result := AdapterAPI.CreatePOSTQuery(FParse.oData, AJsonBody, nil);
  FResource := AdapterAPI.GetResource as IJsonODataServiceResource;
end;

function TODataSQL.CreateGETQuery(FParse: IODataParse;
  AInLineCount: boolean = false): string;
var
  oData: TODataDecodeAbstract;
begin
  oData := FParse.oData;
  result := AdapterAPI.CreateGETQuery(oData, EncodeFilterSql(oData.Filter),
    AInLineCount);
  FResource := AdapterAPI.GetResource as IJsonODataServiceResource;

end;

function TODataSQL.CreateSearchFields(FParse: IODataParse;
  const ASearch: String; const fields: string): String;
var
  str: TStringList;
  i: Integer;
  LSearch: string;
begin
  LSearch := stringReplace(TIdURI.URLDecode(ASearch), '''', '', [rfReplaceAll]);
  result := '';
  if fields = '' then
    exit;

  str := TStringList.create;
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
    str.free;
  end;
end;

procedure TODataSQL.DecodeODataURL(CTX: TObject);
var
  url: string;
begin
  inherited;
  try
    url := FCTX.Request.PathInfo;
    { if FCTX.Request.QueryStringParams.Count > 0 then
      begin
      url := url + '?' + FCTX.Request.RawWebRequest.Query;
      end; }
    FODataParse.ParseURL(url);
    FODataParse.parseURLParams(FCTX.Request.RawWebRequest.Query);
  finally
  end;
end;

destructor TODataSQL.Destroy;
begin
  FResource := nil;
  inherited;
end;

function TODataSQL.EncodeFilterSql(AFilter: string): string;
begin
  result := TODataParse.OperatorToString(AFilter);
end;

function TODataSQL.ExecuteDELETE(ABody: string;
  var JSONResponse: TJsonObject): Integer;
begin
  result := 0;
end;

function TODataSQL.ExecuteGET(AJsonBody: TJsonValue;
  out JSONResponse: TJsonObject): TObject;
begin
  result := nil;
end;

function TODataSQL.GetConnection(ADataset: TDataset): TObject;
begin
  result := nil;
end;

function TODataSQL.GetPrimaryKey(AConnection: TObject;
  ACollection: string): string;
begin
  result := '';
end;

procedure TODataSQL.ParseURL(AUrl: string);
begin
  FODataParse.ParseURL(AUrl);
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
