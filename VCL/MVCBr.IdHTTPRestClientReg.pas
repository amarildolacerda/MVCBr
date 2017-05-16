unit MVCBr.IdHTTPRestClientReg;

interface

Uses System.Classes,
  System.SysUtils, DB, MVCBr.IdHTTPRestClient,
  DesignIntf, DesignEditors;

type

  TIDHTTPRestClientCompEditor = class(TComponentEditor)
    function GetVerbCount: integer; override;
    function GetVerb(Index: integer): string; override;
    procedure ExecuteVerb(Index: integer); override;
    procedure Edit; override;
  protected
  //  function GetLinkToTypeClass: TComponentClass; override;
  private
  public
    constructor Create(AComponent: TComponent; ADesigner: IDesigner); override;
  end;



procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('MVCBr', [TIdHTTPRestClient]);
  RegisterComponentEditor(TIdHTTPRestClient,TIDHTTPRestClientCompEditor);

end;

{ TIDHTTPRestClientCompEditor }

constructor TIDHTTPRestClientCompEditor.Create(AComponent: TComponent;
  ADesigner: IDesigner);
begin
  inherited;

end;

procedure TIDHTTPRestClientCompEditor.Edit;
begin
  inherited;

end;


procedure TIDHTTPRestClientCompEditor.ExecuteVerb(Index: integer);
begin
//  inherited;
  if assigned(Component) then
  if Component.InheritsFrom(TIdHTTPRestClient) then
    case index of
      0:
        TIdHTTPRestClient(Component).Execute;
    end;

end;

function TIDHTTPRestClientCompEditor.GetVerb(Index: integer): string;
begin
  result := '';
  case index of
    0:
     result := 'Execute';
  end;

end;

function TIDHTTPRestClientCompEditor.GetVerbCount: integer;
begin
   result := 1;
end;

end.
