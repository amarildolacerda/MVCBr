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
  Créditos: Ivan Cesar - fornecendo o Dataset com DeltaJSON
}
{ *************************************************************************** }
unit RestODataAppView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, IPPeerClient, Data.DB,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, MVCBr.ODataDatasetAdapter, oData.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, MVCBr.IdHTTPRestClient,
  VCL.Controls, VCL.Grids, VCL.DBGrids, VCL.StdCtrls,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
  Datasnap.DBClient, MVCBr.ODataDatasetBuilder, MVCBr.ODataFDMemTable;

type
  /// Interface para a VIEW
  IRestODataAppView = interface(IView)
    ['{2AEBB87C-2DE9-4616-87D8-2A31D98574C2}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TRestODataAppView = class(TFormFactory { TFORM } , IView,
    IThisAs<TRestODataAppView>, IRestODataAppView, IViewAs<IRestODataAppView>)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Button1: TButton;
    Button2: TButton;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    ODataDatasetBuilder1: TODataDatasetBuilder;
    ODataFDMemTable1: TODataFDMemTable;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FDMemTable1BeforePost(DataSet: TDataSet);
  private
    FLoading: boolean;
    FState: TDataSetState;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TRestODataAppView;
    function ViewAs: IRestODataAppView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

Implementation

{$R *.DFM}

function TRestODataAppView.Update: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TRestODataAppView.ViewAs: IRestODataAppView;
begin
  result := self;
end;

procedure TRestODataAppView.FDMemTable1BeforePost(DataSet: TDataSet);
begin
  FState := DataSet.State;
end;

procedure TRestODataAppView.FormCreate(Sender: TObject);
begin
  // IdHTTPRestClient1.IdHTTP.Request.CustomHeaders.AddValue('token', 'abcdexz');
end;

class function TRestODataAppView.New(aController: IController): IView;
begin
  result := TRestODataAppView.create(nil);
  result.Controller(aController);
end;

procedure TRestODataAppView.Button1Click(Sender: TObject);
begin
  FLoading := true;
  try
    ODataDatasetBuilder1.Execute;
  finally
    FLoading := false;
  end;
end;

procedure TRestODataAppView.Button2Click(Sender: TObject);
begin
  //FDMemTable1.ApplyUpdates();
  ODataDatasetBuilder1.applyUpdates();
end;

function TRestODataAppView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
end;

function TRestODataAppView.This: TObject;
begin
  result := inherited This;
end;

function TRestODataAppView.ThisAs: TRestODataAppView;
begin
  result := self;
end;

function TRestODataAppView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
