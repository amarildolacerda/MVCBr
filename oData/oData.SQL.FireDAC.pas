unit oData.SQL.FireDAC;

interface

uses
  System.Classes, System.SysUtils, Data.Db, oData.SQL, FireDAC.Comp.Client;

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
    procedure CreateExpandCollections(AQuery: TObject); override;

  end;

implementation

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
    on e: Exception do
      raise Exception.Create(e.message + '<' + FQuery.SQL.Text + '>');
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
