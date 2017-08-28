unit MVCBr.VCL.DBStaticText;

interface

uses System.Classes, System.SysUtils, VCL.StdCtrls,
  Data.DB,
  MVCBr.DataControl;

type

  /// <summary>
  /// DBStaticText to create OnChange event when DataField change value
  /// </summary>
  TDBStaticText = class(TStaticText)
  private
    FValue: Variant;
    FDataControl: TMVCBrDataControl;
    FOnChange: TDataSetNotifyEvent;
    procedure SetDataField(const Value: string);
    procedure SetDatasource(const Value: TDatasource);
    function GetDataField: string;
    function GetDatasource: TDatasource;
    procedure SetOnChange(const Value: TDataSetNotifyEvent);
    procedure DoChange(ds: TDataset);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Dataset: TDataset;
  published
    /// <summary> Datafield to monitor value </summary>
    Property DataField: string read GetDataField write SetDataField;
    Property Datasource: TDatasource read GetDatasource write SetDatasource;
    property OnChange: TDataSetNotifyEvent read FOnChange write SetOnChange;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MVCBrDB', [TDBStaticText]);
end;

{ TDBStaticText }

constructor TDBStaticText.Create(AOwner: TComponent);
begin
  inherited;
  if csDesigning in ComponentState then
  begin
      Height := 21;
      BorderStyle := sbsSingle;
      AutoSize := false;
  end;

  FDataControl := TMVCBrDataControl.Create(Self);

  FDataControl.DelegateTo(
    procedure(ds: TDataset)
    begin
      DoChange(ds);
    end)

end;

function TDBStaticText.Dataset: TDataset;
begin
  result := FDataControl.Dataset;
end;

destructor TDBStaticText.Destroy;
begin
  FDataControl.free;
  inherited;
end;

procedure TDBStaticText.DoChange(ds: TDataset);
begin
  if ds.FieldByName(DataField).Value <> FValue then
  begin
    if assigned(FOnChange) then
      FOnChange(ds);
    FValue := ds.FieldByName(DataField).Value;
  end;
end;

function TDBStaticText.GetDataField: string;
begin
  result := FDataControl.DataField;
end;

function TDBStaticText.GetDatasource: TDatasource;
begin
  result := FDataControl.Datasource;
end;

procedure TDBStaticText.SetDataField(const Value: string);
begin
  FDataControl.DataField := Value;
end;

procedure TDBStaticText.SetDatasource(const Value: TDatasource);
begin
  FDataControl.Datasource := Value;
end;

procedure TDBStaticText.SetOnChange(const Value: TDataSetNotifyEvent);
begin
  FOnChange := Value;
end;

end.
