unit MVCBr.VCL.DBGauge;

interface

uses System.Classes, System.SysUtils,
  Data.DB, MVCBr.DataControl,
  VCL.Samples.Gauges;

Type

  TDBGauge = class(TGauge)
  private
    FDataControl: TMVCBrDataControl;
    FOnChange: TDataSetNotifyEvent;
    procedure SetDataField(const Value: String);
    procedure SetDatasource(const Value: TDatasource);
    function GetDataField: String;
    function GetDatasource: TDatasource;
    procedure SetOnChange(const Value: TDataSetNotifyEvent);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property DataField: String read GetDataField write SetDataField;
    Property Datasource: TDatasource read GetDatasource write SetDatasource;
    property OnChange: TDataSetNotifyEvent read FOnChange write SetOnChange;
  end;

procedure Register;

implementation

{ TDBGauge }

procedure Register;
begin
    RegisterComponents('MVCBrDB',[TDBGauge]);
end;

constructor TDBGauge.Create(AOwner: TComponent);
begin
  inherited;
  FDataControl := TMVCBrDataControl.Create(self);

  FDataControl.DelegateTo(
    procedure(ds: TDataset)
    begin
      Progress := round(StrToFloatDef(ds.FieldByName(DataField).asString, 0));
      if assigned(FOnChange) then
        FOnChange(ds);
    end);

end;

destructor TDBGauge.Destroy;
begin
  FDataControl.free;
  inherited;
end;

function TDBGauge.GetDataField: String;
begin
  result := FDataControl.DataField;
end;

function TDBGauge.GetDatasource: TDatasource;
begin
  result := FDataControl.Datasource;
end;

procedure TDBGauge.SetDataField(const Value: String);
begin
  FDataControl.DataField := Value;
end;

procedure TDBGauge.SetDatasource(const Value: TDatasource);
begin
  FDataControl.Datasource := Value;
end;

procedure TDBGauge.SetOnChange(const Value: TDataSetNotifyEvent);
begin
  FOnChange := Value;
end;

end.
