{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 28/03/2017 22:29:13                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit CRUDProdutosView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, VCL.StdCtrls, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, MVCBr.ODataFDMemTable, oData.Comp.Client,
  MVCBr.ODataDatasetBuilder, VCL.Controls, VCL.Grids, VCL.DBGrids;

type
  /// Interface para a VIEW
  ICRUDProdutosView = interface(IView)
    ['{1EC2E769-DE16-4D24-86C1-DD023F4E6F01}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TCRUDProdutosView = class(TFormFactory { TFORM } , IView,
    IThisAs<TCRUDProdutosView>, ICRUDProdutosView, IViewAs<ICRUDProdutosView>)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ODataDatasetBuilder1: TODataDatasetBuilder;
    ODataFDMemTable1: TODataFDMemTable;
    Button1: TButton;
    Button2: TButton;
    ODataFDMemTable1codigo: TStringField;
    ODataFDMemTable1descricao: TStringField;
    ODataFDMemTable1grupo: TStringField;
    ODataFDMemTable1unidade: TStringField;
    ODataFDMemTable1preco: TFloatField;
    ODataFDMemTable1figura: TStringField;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FInited: Boolean;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TCRUDProdutosView;
    function ViewAs: ICRUDProdutosView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
  end;

Implementation

{$R *.DFM}

function TCRUDProdutosView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TCRUDProdutosView.ViewAs: ICRUDProdutosView;
begin
  result := self;
end;

class function TCRUDProdutosView.New(aController: IController): IView;
begin
  result := TCRUDProdutosView.create(nil);
  result.Controller(aController);
end;

procedure TCRUDProdutosView.Button1Click(Sender: TObject);
begin
  ODataDatasetBuilder1.execute;
end;

procedure TCRUDProdutosView.Button2Click(Sender: TObject);
begin
  ODataFDMemTable1.ApplyUpdates();
end;

function TCRUDProdutosView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TCRUDProdutosView.Init;
begin
  // incluir incializações aqui
end;

function TCRUDProdutosView.This: TObject;
begin
  result := inherited This;
end;

function TCRUDProdutosView.ThisAs: TCRUDProdutosView;
begin
  result := self;
end;

function TCRUDProdutosView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
