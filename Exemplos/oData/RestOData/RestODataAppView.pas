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
  Datasnap.DBClient, VCL.Controls, VCL.Grids, VCL.DBGrids, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Response.Adapter, MVCBr.IdHTTPRestClient;

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
    ClientDataSet1: TClientDataSet;
    IdHTTPRestClient1: TIdHTTPRestClient;
  private
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

class function TRestODataAppView.New(aController: IController): IView;
begin
  result := TRestODataAppView.create(nil);
  result.Controller(aController);
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
