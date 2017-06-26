unit oData.Comp.Editor;

interface

uses
  System.Classes, System.SysUtils,
  VCL.Forms,
  DesignIntf, DesignEditors, VCL.Controls, VCL.StdCtrls;

type

  TODataPropertyDlg = class(TForm)
    Memo1: TMemo;
  end;

  TODataPropertyEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
    procedure Edit; override;
  private
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
  end;

procedure Register;

implementation

{$R *.dfm}
{$R TODataBuilder.res}
{$R TODataDatasetBuilder.res}

uses oData.Comp.Client,MVCBr.ODataDatasetBuilder;

procedure Register;
begin
  RegisterComponents('MVCBr', [TODataBuilder]);
  RegisterComponentEditor(TODataBuilder, TODataPropertyEditor);
  RegisterComponentEditor(TODataDatasetBuilder, TODataPropertyEditor);

end;

{ TODataPropertyEditor }

constructor TODataPropertyEditor.Create(AComponent: TComponent;
  ADesigner: IDesigner);
begin
  inherited;

end;

procedure TODataPropertyEditor.Edit;
begin
  inherited;

end;

procedure TODataPropertyEditor.ExecuteVerb(Index: integer);
var
  s: String;
begin
  if not assigned(Component) then
    exit;

  if Component.InheritsFrom(TODataBuilder) then
  begin
    case index of
      0:
        begin
          s := TODataBuilder(Component).ToString;
          with TODataPropertyDlg.Create(nil) do
            try
              Memo1.Text := s;
              showModal;
            finally
              free;
            end;
        end;
      1:
        begin
          TODataBuilder(Component).execute;
        end;
    end;

  end else
  if Component.InheritsFrom(TODataDatasetBuilder) then
  begin
    case index of
      0:
        begin
          s := TODataDatasetBuilder(Component).ToString;
          with TODataPropertyDlg.Create(nil) do
            try
              Memo1.Text := s;
              showModal;
            finally
              free;
            end;
        end;
      1:
        begin
          TODataDatasetBuilder(Component).execute;
        end;
    end;
  end;

end;

function TODataPropertyEditor.GetVerb(Index: integer): string;
begin
  case index of
    0:
      Result := '&Ver resultado';
    1:
      Result := 'Execute';
  end;

end;

function TODataPropertyEditor.GetVerbCount: integer;
begin
  Result := 2;
end;

end.
