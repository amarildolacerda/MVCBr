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
  MVCBr.Interf, System.JSON.Helper,
  FireDAC.Comp.Client;

type

  IQueryAdapter<T> = interface(TFunc<T>) // like    System.classes.helper
    ['{B6835263-1731-4E51-9322-0AD7870C588A}']
  end;

  TQueryAdapter = class(TInterfacedObject, IQueryAdapter<TFdQuery>)
  private
    FInstance: TFdQuery;
    function Invoke: TFdQuery;
  public
    Constructor Create(AInstance: TObject);
    Destructor Destroy; override;
  end;

  TODataFiredacQuery = class(TODataSQL)
  private
    FQuery: IQueryAdapter<TFdQuery>;
    FConnection: TFDConnection;
    procedure SetConnection(const Value: TFDConnection);
    procedure paramFromJson(q: TFdQuery; ji: TJsonObject);
    procedure PrepareQuery(FQuery: TFdQuery);
  public
    destructor Destroy; override;
    function GetPrimaryKey(AConnection: TObject; ACollection: string)
      : string; override;
    function GetConnection(ADataset: TDataset): TObject; override;

    function QueryClass: TDataSetclass; override;
    property Connection: TFDConnection read FConnection write SetConnection;
    function ExecuteGET(AJsonBody: TJsonValue; var JSONResponse: TJsonObject)
      : TObject; override;
    function ExecuteDELETE(ABody: string; var JSONResponse: TJsonObject)
      : Integer; override;
    function ExecutePOST(ABody: string; var JSONResponse: TJsonObject)
      : Integer; override;
    function ExecutePATCH(ABody: string; var JSONResponse: TJsonObject)
      : Integer; override;

    procedure CreateExpandCollections(AQuery: TObject); override;

  end;

implementation

uses System.DateUtils, FireDAC.Stan.Param, System.Rtti, idURI,
  oData.ServiceModel, oData.JSON, oData.Dialect,
  oData.engine;
{ TODataFiredacQuery }

procedure TODataFiredacQuery.CreateExpandCollections(AQuery: TObject);
begin
  inherited;

end;

destructor TODataFiredacQuery.Destroy;
begin
  FQuery := nil;
  // freeAndNil(FQuery); // passou para a Interface
  inherited;
end;

function TODataFiredacQuery.ExecuteDELETE(ABody: string;
  var JSONResponse: TJsonObject): Integer;
var
  AJson: string;
  js: IJsonObject;
  isArray: boolean;
  ji: TJsonValue;
  iLin: Integer;
begin
  inherited;
  iLin := 0;
  isArray := false;
  AJson := ABody;
  if ABody <> '' then
  begin
    js := TInterfacedJson.New(TJsonObject.ParseJSONValue(ABody), false);
    if (not assigned(js)) or (not assigned(js.JSON)) then
      raise Exception.Create
        ('JSON string inválido, revisar o body da mensagem');
    isArray := js.JSON is TJsonArray;
  end;

  result := 0;

  FResource := AdapterAPI.GetResource(FODataParse.oData.Resource)
    as IJsonODataServiceResource;

  FQuery := TQueryAdapter.Create(QueryClass.Create(nil));
  PrepareQuery(FQuery);

  FQuery.Connection.StartTransaction;
  try
    if isArray then
    begin
      for ji in js.AsArray do
      begin
        inc(iLin);
        FQuery.SQL.Text := CreateDeleteQuery(FODataParse, ji,
          GetPrimaryKey(FQuery.Connection, FResource.collection));
        paramFromJson(FQuery, ji as TJsonObject);
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
      paramFromJson(FQuery, js.JsonObject);
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
        raise Exception.Create(TODataError.Create(501, 'Linha: ' + iLin.toString
          + ', ' + e.Message));
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
  var JSONResponse: TJsonObject): Integer;
var
  AJson: string;
  jo: TJsonValue;
  js: IJsonObject;
  isArray: boolean;
  ji: TJsonValue;
  sKeys: string;
  iLin: Integer;
  LRowState: string;
begin
  inherited;
  iLin := 0;
  isArray := false;
  AJson := ABody;
  if ABody <> '' then
  begin
    jo := TJsonObject.ParseJSONValue(ABody);
    if assigned(jo) then
    begin
      js := TInterfacedJson.New(jo, false);
      if (not assigned(js)) or (not assigned(js.JSON)) then
        raise Exception.Create
          ('JSON string inválido, revisar o body da mensagem');
      isArray := js.JSON is TJsonArray;
    end;
  end;

  FResource := AdapterAPI.GetResource(FODataParse.oData.Resource)
    as IJsonODataServiceResource;

  result := 0;
  FQuery := TQueryAdapter.Create(QueryClass.Create(nil));
  PrepareQuery(FQuery);
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
        paramFromJson(FQuery, ji as TJsonObject);
        FQuery.ExecSQL;
        if (FQuery.RowsAffected = 0) then
        begin
          if TJsonObject(ji).TryGetValue<string>(cODataRowState, LRowState) then
            if LRowState = cODataModifiedORInserted then
            begin
              FQuery.SQL.Text := CreatePOSTQuery(FODataParse, ji);
              paramFromJson(FQuery, ji as TJsonObject);
              FQuery.ExecSQL;
            end;
        end;
        result := result + FQuery.RowsAffected;
      end;

    end
    else
    begin
      inc(iLin);
      FQuery.SQL.Text := CreatePATCHQuery(FODataParse, js.JsonValue,
        GetPrimaryKey(FQuery.Connection, FResource.collection));
      paramFromJson(FQuery, js.JsonObject);
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
        raise Exception.Create(TODataError.Create(501, 'Linha: ' + iLin.toString
          + ', ' + e.Message));
    end;
  end;
end;

procedure TODataFiredacQuery.paramFromJson(q: TFdQuery; ji: TJsonObject);
var
  p: TJsonPair;
  n: string;
  v: TValue;
  prm: TFDParam;
  dt: TDatetime;
begin
  for p in ji do
  begin
    n := p.JsonString.Value;
    prm := q.findParam(n);
    if assigned(prm) then
    begin
      v := p.JsonValue.Value;

      case TInterfacedJson.GetJsonType(p) of
        jtNumber:
          prm.AsExtended := p.JsonValue.AsFloat;
        jtTrue:
          prm.asBoolean := true;
        jtFalse:
          prm.asBoolean := false;
        jtDate:
          prm.asDateTime := strToDateTimeDef(v.AsString, 0);
        jtDatetimeISO8601:
          begin
            if TryISO8601ToDate(v.AsString, dt, true) then
              prm.asDateTime := dt
            else
              prm.Value := v.asVariant;
          end;
        jtString:
          prm.AsString := v.AsString;
      else
        prm.Value := v.asVariant;
      end;
    end;

  end;
end;

procedure TODataFiredacQuery.PrepareQuery(FQuery: TFdQuery);
begin
  FQuery.FetchOptions.RowsetSize := 0;
  // FQuery.FetchOptions.Unidirectional := true;
  FQuery.ResourceOptions.CmdExecTimeout := 60000 * 10;
  FQuery.ResourceOptions.DirectExecute := true;
  FQuery.ResourceOptions.SilentMode := true;
  FQuery.FetchOptions.AutoClose := true;
end;

function TODataFiredacQuery.ExecutePOST(ABody: string;
  var JSONResponse: TJsonObject): Integer;
var
  AJson: string;
  js: IJsonObject;
  isArray: boolean;
  ji: TJsonValue;
  iLin: Integer;
begin
  inherited;
  iLin := 0;
  isArray := false;
  AJson := ABody;
  if ABody <> '' then
  begin
    js := TInterfacedJson.New(TJsonObject.ParseJSONValue(ABody), false);
    if (not assigned(js)) or (not assigned(js.JSON)) then
      raise Exception.Create
        ('JSON string inválido, revisar o body da mensagem');
    isArray := js.JSON is TJsonArray;
  end;

  FResource := AdapterAPI.GetResource(FODataParse.oData.Resource)
    as IJsonODataServiceResource;

  result := 0;
  freeAndNil(FQuery);
  FQuery := TQueryAdapter.Create(QueryClass.Create(nil));
  PrepareQuery(FQuery);
  FQuery.Connection.StartTransaction;
  try

    if isArray then
    begin
      for ji in js.AsArray do
      begin
        inc(iLin);
        FQuery.SQL.Text := CreatePOSTQuery(FODataParse, ji);
        paramFromJson(FQuery, ji as TJsonObject);
        FQuery.ExecSQL;
        result := result + FQuery.RowsAffected;
      end;

    end
    else
    begin
      inc(iLin);
      FQuery.SQL.Text := CreatePOSTQuery(FODataParse, js.JsonValue);
      paramFromJson(FQuery, js.JsonObject);
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
        raise Exception.Create(TODataError.Create(501, 'Linha: ' + iLin.toString
          + ', ' + e.Message));
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
  var JSONResponse: TJsonObject): TObject;
var
  i: Integer;
  v: TValue;
  n: Integer;
  LSql: string;
begin
  InLineRecordCount := -1;
  FQuery := TQueryAdapter.Create(QueryClass.Create(nil));
  PrepareQuery(FQuery);
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
          FQuery.Params[i].Value := v.asVariant
      end;

    LSql := FQuery.SQL.Text;
    if AdapterAPI.AfterCreateSQL(LSql) then
      FQuery.SQL.Text := LSql;
    FQuery.Open;
    CreateEntitiesSchema(FQuery, JSONResponse);

    if FODataParse.oData.Debug.Equals('on') then
      JSONResponse.AddPair(TJsonPair.Create('query', FQuery.SQL.Text));

  except
    on e: Exception do
      if e.Message.StartsWith('{') then
        raise
      else
        raise Exception.Create(TODataError.Create(501,
          e.Message + '<' + FQuery.SQL.Text + '>'));
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

{ TQueryAdapter }

constructor TQueryAdapter.Create(AInstance: TObject);
begin
  FInstance := AInstance as TFdQuery;
end;

destructor TQueryAdapter.Destroy;
begin
  if assigned(FInstance) then
    FInstance.DisposeOf;
  FInstance := nil;
  inherited;
end;

function TQueryAdapter.Invoke: TFdQuery;
begin
  if not assigned(FInstance) then
    FInstance := TFdQuery.Create(nil);
  result := FInstance;
end;

end.
