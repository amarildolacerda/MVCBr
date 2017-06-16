unit MVCBr.HTTPRestClientEditor;

interface

Uses System.Classes,
  System.SysUtils, DB, MVCBr.HTTPRestClient,
  DesignIntf, DesignEditors;

type

  THTTPRestClientCompEditor = class(TComponentEditor)
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




implementation


{ TIDHTTPRestClientCompEditor }

constructor THTTPRestClientCompEditor.Create(AComponent: TComponent;
  ADesigner: IDesigner);
begin
  inherited;

end;

procedure THTTPRestClientCompEditor.Edit;
begin
  inherited;

end;


procedure THTTPRestClientCompEditor.ExecuteVerb(Index: integer);
begin
//  inherited;
  if assigned(Component) then
  if Component.InheritsFrom(THTTPRestClient) then
    case index of
      0:
        THTTPRestClient(Component).Execute;
    end;

end;

function THTTPRestClientCompEditor.GetVerb(Index: integer): string;
begin
  result := '';
  case index of
    0:
     result := 'Execute';
  end;

end;

function THTTPRestClientCompEditor.GetVerbCount: integer;
begin
   result := 1;
end;

end.
