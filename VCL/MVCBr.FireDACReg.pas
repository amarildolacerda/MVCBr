unit MVCBr.FireDACReg;

interface

Uses System.Classes,
  System.SysUtils, DB, MVCBr.HTTPFireDACAdapter,
  DesignIntf, DesignEditors;

type
  THTTPDatasetAdapterCompEditor = class(TComponentEditor)
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
  RegisterComponents('MVCBr', [ THTTPFireDACAdapter]);
  RegisterComponentEditor(THTTPFireDACAdapter,THTTPDatasetAdapterCompEditor);

end;

{ TIDHTTPDatasetAdapterCompEditor }

constructor THTTPDatasetAdapterCompEditor.Create(AComponent: TComponent;
  ADesigner: IDesigner);
begin
  inherited;

end;

procedure THTTPDatasetAdapterCompEditor.Edit;
begin
  inherited;

end;



procedure THTTPDatasetAdapterCompEditor.ExecuteVerb(Index: integer);
begin

  if assigned(Component) and Component.InheritsFrom(THTTPFireDACAdapter) then
    case index of
      0:
        THTTPFireDACAdapter(Component).Execute;
    end;
end;

function THTTPDatasetAdapterCompEditor.GetVerb(Index: integer): string;
begin
  case index of
    0:
     result := 'Execute';
  end;
end;

function THTTPDatasetAdapterCompEditor.GetVerbCount: integer;
begin
  result := 1;
end;

end.
