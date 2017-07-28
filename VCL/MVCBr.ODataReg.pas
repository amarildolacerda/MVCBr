{ *************************************************************************** }
{ }
{ Projeto MVCBr }
{ Coder: amarildo lacerda }
{ }
{ *************************************************************************** }
{ }
{ Licensed under the Apache License, Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. }
{ You may obtain a copy of the License at }
{ }
{ http://www.apache.org/licenses/LICENSE-2.0 }
{ }
{ Unless required by applicable law or agreed to in writing, software }
{ distributed under the License is distributed on an "AS IS" BASIS, }
{ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{ See the License for the specific language governing permissions and }
{ limitations under the License. }
{ }
{ *************************************************************************** }
{
}
{ *************************************************************************** }

unit MVCBr.ODataReg;

interface

Uses System.Classes,
  System.SysUtils, DB,
  MVCBr.ODataDatasetAdapter, oData.Comp.Client, MVCBr.HttpRestClient,
  MVCBr.ODataDatasetBuilder,
  MVCBr.Common, MVCBr.ODataFDMemTable,
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
  RegisterComponents(CMVCBrComponentPalletName, [TODataDatasetAdapter,TODataDatasetBuilder, TODataFDMemTable]);
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
              ResponseJSON := THTTPRestClient.Create(Component.Owner);
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
