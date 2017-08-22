unit MVCBr.VCL.DBToggleSwitch;

interface

uses System.Classes, System.SysUtils, VCL.WinXCtrls,
  System.RTTI, Data.DB, MVCBr.DataControl;

type

  TDBToggleSwitch = class(TToggleSwitch)
  private
    FInLoading: boolean;
    FDataControl: TMVCBrDataControl;
    FValueTrue: string;
    FValueFalse: string;
    procedure SetValueTrue(const Value: string);
    procedure SetDataField(const Value: string);
    procedure SetDatasource(const Value: TDatasource);
    function GetDataField: string;
    function GetDatasource: TDatasource;
    procedure DoClick(Sender: TObject);
    procedure SetValueFalse(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ValueTrue: string read FValueTrue write SetValueTrue;
    property ValueFalse: string read FValueFalse write SetValueFalse;
    property DataField: string read GetDataField write SetDataField;
    property Datasource: TDatasource read GetDatasource write SetDatasource;
  end;

procedure Register;

implementation

uses MVCBr.Interf, System.RTTI.helper;

procedure Register;
begin
  RegisterComponents('MVCBr', [TDBToggleSwitch]);
end;

{ TDbToggleSwitch }

constructor TDBToggleSwitch.Create(AOwner: TComponent);
begin
  inherited;
  FDataControl := TMVCBrDataControl.Create(self);

  FDataControl.DelegateTo(
    procedure(ds: TDataset)
    begin
      if not assigned(ds) then
        exit;
      FInLoading := true;
      try
        if ValueTrue = ds.fieldByName(DataField).AsString then
        begin
          if self.State <> tssOn then
            self.State := tssOn
        end
        else
        begin
          if self.State <> tssOff then
            self.State := tssOff;
        end;
      finally
        FInLoading := false;
      end;
    end);

  onClick := DoClick;

end;

destructor TDBToggleSwitch.Destroy;
begin
  onClick := nil;
  FDataControl.delegateTo(nil);
  FDataControl.Datasource := nil;
  FDataControl.free;
  FDataControl := nil;
  inherited;
end;

procedure TDBToggleSwitch.DoClick(Sender: TObject);
var
  ds: TDataset;
begin

  if FInLoading then
    exit;

  ds := FDataControl.Dataset;
  if (not assigned(ds)) or (not ds.CanModify) then
    exit;

//  if not(ds.State in [dsBrowse]) then
  begin
    if not(ds.State in dsEditModes) then
      ds.edit;
    if State = tssOff then
      ds.fieldByName(DataField).Value := ValueTrue
    else
      ds.fieldByName(DataField).Value := ValueFalse
  end;
end;

function TDBToggleSwitch.GetDataField: string;
begin
  result := FDataControl.DataField;
end;

function TDBToggleSwitch.GetDatasource: TDatasource;
begin
  result := FDataControl.Datasource;
end;

procedure TDBToggleSwitch.SetDataField(const Value: string);
begin
  FDataControl.DataField := Value;
end;

procedure TDBToggleSwitch.SetDatasource(const Value: TDatasource);
begin
  FDataControl.Datasource := Value;
end;

procedure TDBToggleSwitch.SetValueFalse(const Value: string);
begin
  FValueFalse := Value;
end;

procedure TDBToggleSwitch.SetValueTrue(const Value: string);
begin
  FValueTrue := Value;
end;

end.
