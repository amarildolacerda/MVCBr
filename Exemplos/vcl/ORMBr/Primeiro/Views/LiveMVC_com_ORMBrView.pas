{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 29/08/2017 22:34:39                                  // }
{ //************************************************************// }

/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit LiveMVC_com_ORMBrView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, VCL.Controls, VCL.Grids, VCL.DBGrids, Vcl.StdCtrls;

type
  /// Interface para a VIEW
  ILiveMVC_com_ORMBrView = interface(IView)
    ['{97A93305-E058-4786-8142-1E12515669E2}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TLiveMVC_com_ORMBrView = class(TFormFactory { TFORM } , IView,
    IThisAs<TLiveMVC_com_ORMBrView>, ILiveMVC_com_ORMBrView,
    IViewAs<ILiveMVC_com_ORMBrView>)
    DBGrid1: TDBGrid;
    FDMemTable1: TFDMemTable;
    DataSource1: TDataSource;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FInited: boolean;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ThisAs: TLiveMVC_com_ORMBrView;
    function ViewAs: ILiveMVC_com_ORMBrView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

uses
  LiveORM.Model;

{$R *.DFM}

function TLiveMVC_com_ORMBrView.ViewAs: ILiveMVC_com_ORMBrView;
begin
  result := self;
end;

class function TLiveMVC_com_ORMBrView.New(aController: IController): IView;
begin
  result := TLiveMVC_com_ORMBrView.create(nil);
  result.Controller(aController);
end;

procedure TLiveMVC_com_ORMBrView.Button1Click(Sender: TObject);
var LCli : iClientes;
begin
   LCli:=GetModel<IClientesModel>.this.GetClientes( FDMemTable1 );
   LCli.openWhere('codigo=1'  );
end;

procedure TLiveMVC_com_ORMBrView.Button2Click(Sender: TObject);
begin
    //FDMemTable1.ApplyUpdates(0);
    GetModel<IClientesModel>.this.GetClientes( NIL ).ApplyUpdates(0);
end;

function TLiveMVC_com_ORMBrView.Controller(const aController
  : IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

function TLiveMVC_com_ORMBrView.ThisAs: TLiveMVC_com_ORMBrView;
begin
  result := self;
end;

function TLiveMVC_com_ORMBrView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
