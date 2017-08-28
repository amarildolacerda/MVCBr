unit MVCBr.VCL.DBCalendarPick;

interface

{$IF CompilerVersion>=31}

uses System.Classes, System.SysUtils,
  Data.DB,
  MVCBr.DataControl, VCL.WinXCalendars;

type

  TDBCalendarPicker = class(TCalendarPicker)
  private
    FDataControl: TMVCBrDataControl;
    procedure SetDataField(const Value: string);
    procedure SetDatasource(const Value: TDatasource);
    function GetDataField: string;
    function GetDatasource: TDatasource;
    procedure DoChange(sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DataField: string read GetDataField write SetDataField;
    property Datasource: TDatasource read GetDatasource write SetDatasource;
  end;

procedure Register;
{$ENDIF}

implementation

{$IF CompilerVersion>=31}

procedure Register;
begin
  RegisterComponents('MVCBrDB', [TDBCalendarPicker]);
end;

{ TDBCalendarPicker }

constructor TDBCalendarPicker.Create(AOwner: TComponent);
begin
  inherited;
  FDataControl := TMVCBrDataControl.Create(self);
  OnChange := DoChange;
  FDataControl.DelegateTo(
    procedure(ds: TDataset)
    begin
      Date := ds.fieldByName(DataField).asDateTime;
    end);

end;

destructor TDBCalendarPicker.Destroy;
begin
  FDataControl.free;
  inherited;
end;

procedure TDBCalendarPicker.DoChange(sender: TObject);
var
  ds: TDataset;
begin
  ds := FDataControl.Dataset;
  if assigned(ds) and (ds.CanModify) then
  begin
    if not(ds.state in dsEditModes) then
      ds.edit;
    ds.fieldByName(DataField).asDateTime := Date;
  end;
end;

function TDBCalendarPicker.GetDataField: string;
begin
  result := FDataControl.DataField;
end;

function TDBCalendarPicker.GetDatasource: TDatasource;
begin
  result := FDataControl.Datasource;
end;

procedure TDBCalendarPicker.SetDataField(const Value: string);
begin
  FDataControl.DataField := Value;
end;

procedure TDBCalendarPicker.SetDatasource(const Value: TDatasource);
begin
  FDataControl.Datasource := Value;
end;
{$ENDIF}

end.
