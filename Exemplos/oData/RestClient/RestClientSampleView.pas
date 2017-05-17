{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 10/03/2017 19:20:22                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit RestClientSampleView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, Data.FiredacJSONReflect,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, IPPeerClient, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, VCL.Controls, VCL.Grids,
  VCL.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, VCL.StdCtrls,
  FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin;

type
  /// Interface para a VIEW
  IRestClientSampleView = interface(IView)
    ['{77FCF913-D183-4322-B0E3-3FB106AF3F0F}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TRestClientSampleView = class(TFormFactory { TFORM } , IView,
    IThisAs<TRestClientSampleView>, IRestClientSampleView,
    IViewAs<IRestClientSampleView>)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Memo1: TMemo;
    Button1: TButton;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    function GetDeltas(Banco, Tabela: String; MemTable: TFDMemTable)
      : TFDJSONDeltas;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TRestClientSampleView;
    function ViewAs: IRestClientSampleView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
  end;

Implementation

{$R *.DFM}

function TRestClientSampleView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TRestClientSampleView.ViewAs: IRestClientSampleView;
begin
  result := self;
end;

procedure TRestClientSampleView.FormCreate(Sender: TObject);
begin
  RESTRequest1.Execute;
end;

class function TRestClientSampleView.New(aController: IController): IView;
begin
  result := TRestClientSampleView.create(nil);
  result.Controller(aController);
end;

procedure TRestClientSampleView.Button1Click(Sender: TObject);
var
  fd: TFDJSONDeltas;
begin
  fd := GetDeltas('', 'produtos', FDMemTable1);

end;

function TRestClientSampleView.Controller(const aController
  : IController): IView;
begin
  result := inherited Controller(aController);
end;

function TRestClientSampleView.This: TObject;
begin
  result := inherited This;
end;

function TRestClientSampleView.ThisAs: TRestClientSampleView;
begin
  result := self;
end;

function TRestClientSampleView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

function TRestClientSampleView.GetDeltas(Banco, Tabela: String;
  MemTable: TFDMemTable): TFDJSONDeltas;
begin
  if MemTable.State in [dsInsert, dsEdit] then
    MemTable.Post;
  result := TFDJSONDeltas.create;
  TFDJSONDeltasWriter.ListAdd(result, MemTable);
end;

end.
