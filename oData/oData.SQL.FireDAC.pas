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
  FireDAC.Comp.Client;

type
  TODataFiredacQuery = class(TODataSQL)
  private
    FQuery: TFdQuery;
    FConnection: TFDConnection;
    procedure SetConnection(const Value: TFDConnection);
  public
    destructor destroy; override;
    function QueryClass: TDataSetclass; override;
    property Connection: TFDConnection read FConnection write SetConnection;
    function GetDataset: TObject; override;
    function ExecuteDelete(ABody: string): Integer; override;
    function ExecutePost(ABody: string; var JSON: TJSONObject)
      : Integer; override;

    procedure CreateExpandCollections(AQuery: TObject); override;

  end;

implementation

uses oData.JSON, oData.engine;
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

function TODataFiredacQuery.ExecuteDelete(ABody: string): Integer;
var
  AJson: string;
  js: IJsonObject;
  isArray: boolean;
  ji: TJsonValue;
begin
  inherited;
  isArray := false;
  AJson := ABody;
  if ABody <> '' then
  begin
    js := TInterfacedJsonObject.New(TJSONObject.ParseJSONValue(ABody), false);
    isArray := js.JSON is TJsonArray;
  end;

  result := 0;
  freeAndNil(FQuery);
  FQuery := QueryClass.Create(nil) as TFdQuery;
  try
    if isArray then
    begin
      for ji in js.AsArray do
      begin
        FQuery.SQL.Text := CreateDeleteQuery(FODataParse, ji.ToJSON);
        FQuery.ExecSQL;
        result := result + FQuery.RowsAffected;
      end;

    end
    else
    begin
      FQuery.SQL.Text := CreateDeleteQuery(FODataParse, AJson);
      FQuery.ExecSQL;
      result := result + FQuery.RowsAffected;
    end;
  except
    on e: exception do
    begin
      result := 0;
      raise exception.Create(TODataError.Create(501, e.Message));
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
function TODataFiredacQuery.ExecutePost(ABody: string;
  var JSON: TJSONObject): Integer;
var
  AJson: string;
  js: IJsonObject;
  isArray: boolean;
  ji: TJsonValue;
begin
  inherited;
  isArray := false;
  AJson := ABody;
  if ABody <> '' then
  begin
    js := TInterfacedJsonObject.New(TJSONObject.ParseJSONValue(ABody), false);
    isArray := js.JSON is TJsonArray;
  end;

  result := 0;
  freeAndNil(FQuery);
  FQuery := QueryClass.Create(nil) as TFdQuery;
  try
    if isArray then
    begin
      for ji in js.AsArray do
      begin
        FQuery.SQL.Text := CreatePOSTQuery(FODataParse, ji.ToJSON);
        FQuery.ExecSQL;
        result := result + FQuery.RowsAffected;
      end;

    end
    else
    begin
      FQuery.SQL.Text := CreatePOSTQuery(FODataParse, AJson);
      FQuery.ExecSQL;
      result := result + FQuery.RowsAffected;
    end;
  except
    on e: exception do
    begin
      result := 0;
      raise exception.Create(TODataError.Create(501, e.Message));
    end;
  end;
end;

function TODataFiredacQuery.GetDataset: TObject;
begin
  InLineRecordCount := -1;
  freeAndNil(FQuery);
  FQuery := QueryClass.Create(nil) as TFdQuery;
  FQuery.FetchOptions.RowsetSize := 0;
  result := FQuery;

  try
    if (FODataParse.oData.InLineCount = 'allpages') and
      ((FODataParse.oData.Skip > 0) or (FODataParse.oData.Top > 0)) then
    begin
      FQuery.SQL.Text := CreateQuery(FODataParse, true);
      FQuery.Open;
      InLineRecordCount := FQuery.FieldByName('N__Count').AsInteger;
      FQuery.Close;
    end;

    FQuery.SQL.Text := CreateQuery(FODataParse);

    // criar NextedDataset -   $expand  command
    if (FODataParse.oData.Expand <> '') and
      (not(FODataParse.oData.InLineCount = 'allpages')) then
      CreateExpandCollections(FQuery);

    FQuery.Open;
  except
    on e: exception do
      raise exception.Create(TODataError.Create(500,
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

end.
