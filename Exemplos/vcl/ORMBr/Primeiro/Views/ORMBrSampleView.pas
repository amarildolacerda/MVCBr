{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 27/08/2017 11:16:03                                  // }
{ //************************************************************// }

/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit ORMBrSampleView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, FireDAC.Stan.Intf,
  ORMBrClienteModel,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, VCL.Controls, VCL.Grids, VCL.DBGrids, VCL.StdCtrls;

type
  /// Interface para a VIEW
  IORMBrSampleView = interface(IView)
    ['{1EC23089-EDA5-44EB-9796-201EC782005E}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TORMBrSampleView = class(TFormFactory { TFORM } , IView,
    IThisAs<TORMBrSampleView>, IORMBrSampleView, IViewAs<IORMBrSampleView>)
    DBGrid1: TDBGrid;
    FDMemTable1: TFDMemTable;
    DataSource1: TDataSource;
    Button1: TButton;
    Button2: TButton;
    procedure FormFactoryShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FInited: boolean;
    FClientes: IClientes;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ThisAs: TORMBrSampleView;
    function ViewAs: IORMBrSampleView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function InvokeClientes: IClientes;
  end;

Implementation

{$R *.DFM}

function TORMBrSampleView.ViewAs: IORMBrSampleView;
begin
  result := self;
end;

procedure TORMBrSampleView.FormFactoryShow(Sender: TObject);
begin
  InvokeClientes.open;
end;

function TORMBrSampleView.InvokeClientes: IClientes;
begin
  if not assigned(FClientes) then
    FClientes := getModel<IClientesFactoryModel>.this.GetClientes(FDMemTable1 );
  result := FClientes;
end;

class function TORMBrSampleView.New(aController: IController): IView;
begin
  result := TORMBrSampleView.create(nil);
  result.Controller(aController);
end;

procedure TORMBrSampleView.Button1Click(Sender: TObject);
begin
  InvokeClientes.ApplyUpdates(0);
end;

procedure TORMBrSampleView.Button2Click(Sender: TObject);
begin
   InvokeClientes.open;
end;

function TORMBrSampleView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

function TORMBrSampleView.ThisAs: TORMBrSampleView;
begin
  result := self;
end;

function TORMBrSampleView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
