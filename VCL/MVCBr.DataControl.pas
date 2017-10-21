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
 protected
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Dataset: TDataset;
    property DataField: String read GetDataField write SetDataField;
    property Datasource: TDatasource read GetDatasource write SetDatasource;
    function DelegateTo(ADelegate: TMVCBrDataControlProc): TMVCBrDataControl;
  end;

  TDatasetNotify = procedure(ADataset: TDataset) of object;

  TMVCBrFieldDataSource = class(TMVCBrDataControl)
  private
    FFieldChange: TDatasetNotify;
    procedure SetFieldChange(const Value: TDatasetNotify);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property DataField;
    property Datasource;
    property OnFieldChange: TDatasetNotify read FFieldChange
      write SetFieldChange;
  end;

procedure register;

implementation

procedure register;
begin
  RegisterComponents('MVCBr', [TMVCBrFieldDataSource]);
end;

{ TMVCBrDataControl<T> }

procedure TMVCBrDataControl.SetDatasource(const Value: TDatasource);
begin
  FDataLink.Datasource := Value;
end;

constructor TMVCBrDataControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.OnDataChange := DataChange;
end;

procedure TMVCBrDataControl.DataChange(Sender: TObject);
begin
  if assigned(FDataLink.Dataset) and assigned(FDataLink.Field) and
    assigned(FDelegateTo) then
  begin
    FDelegateTo(FDataLink.Dataset);
  end;
end;

function TMVCBrDataControl.Dataset: TDataset;
begin
  result := FDataLink.Dataset;
end;

function TMVCBrDataControl.DelegateTo(ADelegate: TMVCBrDataControlProc)
  : TMVCBrDataControl;
begin
  result := self;
  FDelegateTo := ADelegate;
end;

destructor TMVCBrDataControl.Destroy;
begin
  if assigned(FDataLink) then
  begin
    FDataLink.OnDataChange := nil;
    FDataLink.FieldName := '';
    FDataLink.Datasource := nil;
    FDataLink.disposeOf;
    FDataLink := nil;
  end;
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

procedure TMVCBrDataControl.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;
  if assigned(FDataLink) then
    if assigned(FDataLink.Datasource) then
      if AComponent.Equals(FDataLink.Datasource) and
        (AOperation = TOperation.opRemove) then
        FDataLink.Datasource := nil;
end;

procedure TMVCBrDataControl.SetDataField(const Value: String);
begin
  FDataLink.FieldName := Value;
end;

{ TMVCBrFieldDataSource }

constructor TMVCBrFieldDataSource.Create(AOwner: TComponent);
begin
  inherited;
  DelegateTo(
    procedure(ds: TDataset)
    begin
      if assigned(FFieldChange) then
        FFieldChange(ds);
    end);
end;

procedure TMVCBrFieldDataSource.SetFieldChange(const Value: TDatasetNotify);
begin
  FFieldChange := Value;
end;

end.
