unit MVCBr.FireDACReg;

interface

Uses System.Classes,
  System.SysUtils, DB, MVCBr.IdHTTPFireDACAdapter,
  DesignIntf, DesignEditors;

type
  TIDHTTPDatasetAdapterCompEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
    procedure Edit; override;
  protected
    // function GetLinkToTypeClass: TComponentClass; override;
  private
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
  end;

procedure Register;


implementation


procedure Register;
begin
  RegisterComponents('MVCBr', [ TIdHTTPFireDACAdapter]);
  RegisterComponentEditor(TIdHTTPFireDACAdapter,TIDHTTPDatasetAdapterCompEditor);

end;

{ TIDHTTPDatasetAdapterCompEditor }

constructor TIDHTTPDatasetAdapterCompEditor.Create(AComponent: TComponent;
  ADesigner: IDesigner);
begin
  inherited;

end;

procedure TIDHTTPDatasetAdapterCompEditor.Edit;
begin
  inherited;

end;



procedure TIDHTTPDatasetAdapterCompEditor.ExecuteVerb(Index: integer);
begin

  if assigned(Component) and Component.InheritsFrom(TIdHTTPFireDACAdapter) then
    case index of
      0:
        TIdHTTPFireDACAdapter(Component).Execute;
    end;
end;

function TIDHTTPDatasetAdapterCompEditor.GetVerb(Index: integer): string;
begin
  case index of
    0:
     result := 'Execute';
  end;
end;

function TIDHTTPDatasetAdapterCompEditor.GetVerbCount: integer;
begin
  result := 1;
end;

end.
