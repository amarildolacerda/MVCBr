{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 10/03/2017 21:21:54                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
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
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

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
    IdHTTPRestClient1: TIdHTTPRestClient;
    ODataBuilder1: TODataBuilder;
    ODataDatasetAdapter1: TODataDatasetAdapter;
    FDMemTable1: TFDMemTable;
    Button1: TButton;
    Button2: TButton;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FDMemTable1BeforeApplyUpdates(DataSet: TFDDataSet);
    procedure FDMemTable1BeforeDelete(DataSet: TDataSet);
    procedure Button2Click(Sender: TObject);
    procedure FDMemTable1BeforePost(DataSet: TDataSet);
    procedure FDMemTable1AfterPost(DataSet: TDataSet);
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

procedure TRestODataAppView.FDMemTable1AfterPost(DataSet: TDataSet);
begin
  if not FLoading then
    case FState of
      dsInsert:
        ODataDatasetAdapter1.AddRowSet(rctInserted, DataSet);
      dsEdit:
        ODataDatasetAdapter1.AddRowSet(rctModified, DataSet);
    end;

end;

procedure TRestODataAppView.FDMemTable1BeforeApplyUpdates(DataSet: TFDDataSet);
begin
  ODataDatasetAdapter1.ApplyUpdates(nil, rmPATCH);
end;

procedure TRestODataAppView.FDMemTable1BeforeDelete(DataSet: TDataSet);
begin
  ODataDatasetAdapter1.AddRowSet(rctDeleted, DataSet);
end;

procedure TRestODataAppView.FDMemTable1BeforePost(DataSet: TDataSet);
begin
  FState := DataSet.State;
end;

procedure TRestODataAppView.FormCreate(Sender: TObject);
begin
  IdHTTPRestClient1.IdHTTP.Request.CustomHeaders.AddValue('token', 'abcdexz');
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
    ODataDatasetAdapter1.Execute;
    ODataDatasetAdapter1.ClearChanges;
  finally
    FLoading := false;
  end;
end;

procedure TRestODataAppView.Button2Click(Sender: TObject);
begin
  FDMemTable1.ApplyUpdates();
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
