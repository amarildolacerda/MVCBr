unit MVCBr.DataControl;

interface

uses
  System.Classes, System.SysUtils, Data.DB,
  VCL.DBCtrls;

type

  TMVCBrDataControlProc = TProc<TDataset>;

  TMVCBrDataControl = class(TComponent)
  private
    FDataLink: TFieldDataLink;
    FDelegateTo: TMVCBrDataControlProc;
    procedure SetDatasource(const Value: TDatasource);
    procedure SetDataField(const Value: String);
    procedure DataChange(Sender: TObject);
    function GetDataField: String;
    function GetDatasource: TDatasource;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    function Dataset:TDataset;
    property DataField: String read GetDataField write SetDataField;
    property Datasource: TDatasource read GetDatasource write SetDatasource;
    function DelegateTo(ADelegate: TMVCBrDataControlProc): TMVCBrDataControl;
  end;

implementation

{ TMVCBrDataControl<T> }

procedure TMVCBrDataControl.SetDatasource(const Value: TDatasource);
begin
  FDataLink.Datasource := Value;
end;

constructor TMVCBrDataControl.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.OnDataChange := DataChange;
end;

procedure TMVCBrDataControl.DataChange(Sender: TObject);
begin
  if assigned(FDataLink.Field) and assigned(FDelegateTo) then
  begin
    FDelegateTo(FDataLink.DataSet);
  end;
end;

function TMVCBrDataControl.Dataset: TDataset;
begin
   result := FDataLink.DataSet;
end;

function TMVCBrDataControl.DelegateTo(ADelegate: TMVCBrDataControlProc)
  : TMVCBrDataControl;
begin
  result := self;
  FDelegateTo := ADelegate;
end;

destructor TMVCBrDataControl.Destroy;
begin
  FDataLink.OnDataChange := nil;
  FDataLink.FieldName := '';
  FDataLink.DataSource := nil;
  FDataLink.Free;
  inherited;
end;

function TMVCBrDataControl.GetDataField: String;
begin
  result := FDataLink.FieldName;
end;

function TMVCBrDataControl.GetDatasource: TDatasource;
begin
  result := FDataLink.Datasource;
end;

procedure TMVCBrDataControl.SetDataField(const Value: String);
begin
  FDataLink.FieldName := Value;
end;

end.
