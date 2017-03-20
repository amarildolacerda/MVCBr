unit MVCBr.ODataReg;

interface

Uses System.Classes,
  System.SysUtils, DB,
  MVCBr.ODataDatasetAdapter, oData.Comp.Client, MVCBr.IdHttpRestClient,
  DesignIntf, DesignEditors;

type
  TODataDatasetAdapterCompEditor = class(TComponentEditor)
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

{$R IDHTTPRESTCLIENT.RES}

procedure Register;
begin
  RegisterComponents('MVCBr', [TODataDatasetAdapter]);
  RegisterComponentEditor(TODataDatasetAdapter, TODataDatasetAdapterCompEditor);

end;

{ TIDHTTPDatasetAdapterCompEditor }

constructor TODataDatasetAdapterCompEditor.Create(AComponent: TComponent;
  ADesigner: IDesigner);
begin
  inherited;

end;

procedure TODataDatasetAdapterCompEditor.Edit;
begin
  inherited;

end;

procedure TODataDatasetAdapterCompEditor.ExecuteVerb(Index: integer);
begin

  if assigned(Component) and Component.InheritsFrom(TODataDatasetAdapter) then
    case index of
      0:
        TODataDatasetAdapter(Component).Execute;
      1:
        begin
          with TODataDatasetAdapter(Component) do
          begin
            if not assigned(ResponseJSON) then
            begin
              ResponseJSON := TIdHTTPRestClient.Create(Component.Owner);
              ResponseJSON.Name := 'RestClient_'+Component.Name;
            end;
            if not assigned(Builder) then
            begin
              Builder := TODataBuilder.Create(Component.Owner);
              Builder.Name := 'ODataBuilder_'+Component.Name;
            end;

            Builder.RestClient := ResponseJSON;

          end;
        end;
    end;
end;

function TODataDatasetAdapterCompEditor.GetVerb(Index: integer): string;
begin
  case index of
    0:
      result := 'Execute';
    1:
      result := 'Create Components';
  end;
end;

function TODataDatasetAdapterCompEditor.GetVerbCount: integer;
begin
  result := 2;
end;

end.
