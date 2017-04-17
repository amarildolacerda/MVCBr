{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit oData.SQL.FireDAC;

interface

uses
  System.Classes, System.SysUtils, Data.Db, oData.SQL, System.JSON,
  MVCBr.Interf,
  FireDAC.Comp.Client;

type
  TODataFiredacQuery = class(TODataSQL)
  private
    FQuery: TFdQuery;
    FConnection: TFDConnection;
    procedure SetConnection(const Value: TFDConnection);
  public
    destructor destroy; override;
    function GetPrimaryKey(AConnection: TObject; ACollection: string)
      : string; override;
    function GetConnection(ADataset: TDataset): TObject; override;

    function QueryClass: TDataSetclass; override;
    property Connection: TFDConnection read FConnection write SetConnection;
    function ExecuteGET(AJsonBody: TJsonValue; var JSONResponse: TJSONObject)
      : TObject; override;
    function ExecuteDELETE(ABody: string; var JSONResponse: TJSONObject)
      : Integer; override;
    function ExecutePOST(ABody: string; var JSONResponse: TJSONObject)
      : Integer; override;
    function ExecutePATCH(ABody: string; var JSONResponse: TJSONObject)
      : Integer; override;

    procedure CreateExpandCollections(AQuery: TObject); override;

  end;

implementation

uses System.Rtti, idURI, oData.ServiceModel, oData.JSON, oData.engine;
{ TODataFiredacQuery }

procedure TODataFiredacQuery.CreateExpandCollections(AQuery: TObject);
begin
  inherited;

end;

destructor TODataFiredacQuery.destroy;
begin
  freeAndNil(FQuery);
  inherited;
end;

function TODataFiredacQuery.ExecuteDELETE(ABody: string;
  var JSONResponse: TJSONObject): Integer;
var
  AJson: string;
  js: IJsonObject;
  isArray: boolean;
  ji: TJsonValue;
  iLin:Integer;
begin
  inherited;
  iLin:=0;
  isArray := false;
  AJson := ABody;
  if ABody <> '' then
  begin
    js := TInterfacedJsonObject.New(TJSONObject.ParseJSONValue(ABody), false);
    if (not assigned(js)) or (not assigned(js.JSON)) then
      raise Exception.Create
        ('JSON string inválido, revisar o body da mensagem');
    isArray := js.JSON is TJsonArray;
  end;

  result := 0;
  freeAndNil(FQuery);

  FResource := AdapterAPI.GetResource(FODataParse.oData.Resource)
    as IJsonODataServiceResource;

  FQuery := QueryClass.Create(nil) as TFdQuery;
  FQuery.Connection.StartTransaction;
  try
    if isArray then
    begin
      for ji in js.AsArray do
      begin
        inc(iLin);
        FQuery.SQL.Text := CreateDeleteQuery(FODataParse, ji,
          GetPrimaryKey(FQuery.Connection, FResource.collection));
        FQuery.ExecSQL;
        result := result + FQuery.RowsAffected;
      end;

    end
    else
    begin
      inc(iLin);
      if js = nil then
        FQuery.SQL.Text := CreateDeleteQuery(FODataParse, nil,
          GetPrimaryKey(FQuery.Connection, FResource.collection))
      else
        FQuery.SQL.Text := CreateDeleteQuery(FODataParse, js.JsonValue,
          GetPrimaryKey(FQuery.Connection, FResource.collection));
      FQuery.ExecSQL;
      result := result + FQuery.RowsAffected;
    end;
    FQuery.Connection.Commit;
  except
    on e: Exception do
    begin
      FQuery.Connection.Rollback;
      result := 0;
      if e.Message.StartsWith('{') then
        raise
      else
        raise Exception.Create(TODataError.Create(501,'Linha: '+iLin.toString+', '+ e.Message));
    end;
  end;
end;

{

  if n > 0 then
  begin
  r := '"@odata.id":"OData/OData.svc/' + FOData.Collection+'('+   ('teresa')",
  // "@odata.editLink":"serviceRoot/People('teresa')",
  end;


}
function TODataFiredacQuery.ExecutePATCH(ABody: string;
  var JSONResponse: TJSONObject): Integer;
var
  AJson: string;
  jo: TJsonValue;
  js: IJsonObject;
  isArray: boolean;
  ji: TJsonValue;
  sKeys: string;
  iLin:integer;
begin
  inherited;
  iLin := 0;
  isArray := false;
  AJson := ABody;
  if ABody <> '' then
  begin
    jo := TJSONObject.ParseJSONValue(ABody);
    if assigned(jo) then
    begin
      js := TInterfacedJsonObject.New(jo, false);
      if (not assigned(js)) or (not assigned(js.JSON)) then
        raise Exception.Create
          ('JSON string inválido, revisar o body da mensagem');
      isArray := js.JSON is TJsonArray;
    end;
  end;

  FResource := AdapterAPI.GetResource(FODataParse.oData.Resource)
    as IJsonODataServiceResource;

  result := 0;
  freeAndNil(FQuery);
  FQuery := QueryClass.Create(nil) as TFdQuery;
  FQuery.Connection.StartTransaction;
  try
    if isArray then
    begin
      for ji in js.AsArray do
      begin
        inc(iLin);
        if not assigned(FResource) then
          FResource := AdapterAPI.GetResource(FODataParse.oData.Resource)
            as IJsonODataServiceResource;
        sKeys := GetPrimaryKey(FQuery.Connection, FResource.collection);
        if sKeys = '' then
          sKeys := FResource.keyID;
        FQuery.SQL.Text := CreatePATCHQuery(FODataParse, ji, sKeys);
        FQuery.ExecSQL;
        result := result + FQuery.RowsAffected;
      end;

    end
    else
    begin
      inc(iLin);
      FQuery.SQL.Text := CreatePATCHQuery(FODataParse, js.JsonValue,
        GetPrimaryKey(FQuery.Connection, FResource.collection));
      FQuery.ExecSQL;
      result := result + FQuery.RowsAffected;
    end;
    FQuery.Connection.Commit;
  except
    on e: Exception do
    begin
      FQuery.Connection.Rollback;
      result := 0;
      if e.Message.StartsWith('{') then
        raise
      else
        raise Exception.Create(TODataError.Create(501, 'Linha: '+iLin.ToString+', '+ e.Message));
    end;
  end;
end;

function TODataFiredacQuery.ExecutePOST(ABody: string;
  var JSONResponse: TJSONObject): Integer;
var
  AJson: string;
  js: IJsonObject;
  isArray: boolean;
  ji: TJsonValue;
  iLin:integer;
begin
  inherited;
  iLin := 0;
  isArray := false;
  AJson := ABody;
  if ABody <> '' then
  begin
    js := TInterfacedJsonObject.New(TJSONObject.ParseJSONValue(ABody), false);
    if (not assigned(js)) or (not assigned(js.JSON)) then
      raise Exception.Create
        ('JSON string inválido, revisar o body da mensagem');
    isArray := js.JSON is TJsonArray;
  end;

  FResource := AdapterAPI.GetResource(FODataParse.oData.Resource)
    as IJsonODataServiceResource;

  result := 0;
  freeAndNil(FQuery);
  FQuery := QueryClass.Create(nil) as TFdQuery;
  FQuery.Connection.StartTransaction;
  try

    if isArray then
    begin
      for ji in js.AsArray do
      begin
        inc(iLin);
        FQuery.SQL.Text := CreatePOSTQuery(FODataParse, ji);
        FQuery.ExecSQL;
        result := result + FQuery.RowsAffected;
      end;

    end
    else
    begin
      inc(iLin);
      FQuery.SQL.Text := CreatePOSTQuery(FODataParse, js.JsonValue);
      FQuery.ExecSQL;
      result := result + FQuery.RowsAffected;
    end;
    FQuery.Connection.Commit;
  except
    on e: Exception do
    begin
      FQuery.Connection.Rollback;
      result := 0;
      if e.Message.StartsWith('{') then
        raise
      else
        raise Exception.Create(TODataError.Create(501, 'Linha: '+iLin.ToString+', '+e.Message));
    end;
  end;
end;

function TODataFiredacQuery.GetConnection(ADataset: TDataset): TObject;
begin
  result := TFdQuery(ADataset).Connection;
end;

function TODataFiredacQuery.GetPrimaryKey(AConnection: TObject;
  ACollection: string): string;
var
  qry: TFdQuery;
  str: TStringList;
begin
  result := '';
  if ACollection = '' then
  begin
    exit;
  end;
  str := TStringList.Create;
  try
    if assigned(AConnection) then
    begin
      TFDConnection(AConnection).GetKeyFieldNames('', '', ACollection, '', str);
      str.Delimiter := ',';
      result := StringReplace(str.DelimitedText, '"', '',
        [rfReplaceAll]).ToLower;
    end
    else
    begin
      qry := QueryClass.Create(nil) as TFdQuery;
      try
        if assigned(qry.Connection) then
          qry.Connection.GetKeyFieldNames('', '', ACollection, '', str);
      finally
        qry.Free;
      end;
    end;
  finally
    str.Free;
  end;

end;

function TODataFiredacQuery.ExecuteGET(AJsonBody: TJsonValue;
  var JSONResponse: TJSONObject): TObject;
var
  i: Integer;
  v: TValue;
  n: Integer;
begin
  InLineRecordCount := -1;
  freeAndNil(FQuery);
  FQuery := QueryClass.Create(nil) as TFdQuery;
  FQuery.FetchOptions.RowsetSize := 0;
  result := FQuery;

  try
    if (FODataParse.oData.count = 'true') and
      ((FODataParse.oData.Skip > 0) or (FODataParse.oData.Top > 0)) then
    begin
      FQuery.SQL.Text := CreateGETQuery(FODataParse, true);
      FQuery.Open;
      InLineRecordCount := FQuery.FieldByName('N__Count').AsInteger;
      FQuery.Close;
    end;

    FQuery.SQL.Text := CreateGETQuery(FODataParse);

    if FODataParse.oData.Search <> '' then
    begin
      FQuery.Filter := createSearchFields(FODataParse, FODataParse.oData.Search,
        FResource.searchFields);
      FQuery.Filtered := FQuery.Filter <> '';
    end;

    // criar NextedDataset -   $expand  command
    if (FODataParse.oData.Expand <> '') and
      (not(FODataParse.oData.count = 'true')) then
      CreateExpandCollections(FQuery);

    // preenche os parametros....
    if AJsonBody <> nil then
      for i := 0 to FQuery.ParamCount - 1 do
      begin
        if AJsonBody.TryGetValue<TValue>(FQuery.Params[i].Name, v) then
          FQuery.Params[i].Value := v.AsVariant
      end;

    FQuery.Open;
    CreateEntitiesSchema(FQuery, JSONResponse);

  except
    on e: Exception do
      if e.Message.StartsWith('{') then
        raise
      else
        raise Exception.Create(TODataError.Create(501, e.Message));
  end;
end;

function TODataFiredacQuery.QueryClass: TDataSetclass;
begin
  result := TFdQuery;
end;

procedure TODataFiredacQuery.SetConnection(const Value: TFDConnection);
begin
  FConnection := Value;
end;

end.
