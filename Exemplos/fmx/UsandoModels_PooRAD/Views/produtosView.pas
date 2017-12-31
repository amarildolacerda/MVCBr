{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/10/2017 16:41:34                                  // }
{ //************************************************************// }

/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit produtosView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, System.Rtti, FMX.Grid.Style,
  Data.Bind.EngExt, FMX.Bind.DBEngExt, FMX.Bind.Grid, System.Bindings.Outputs,
  FMX.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.Controls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, MVCBr.FDMongoDB, FMX.Types,
  FMX.Layouts, Data.Bind.Controls, Fmx.Bind.Navigator;

type
  /// Interface para a VIEW
  IprodutosView = interface(IView)
    ['{2458D935-57BF-488F-9CFF-DAE7DB62CE05}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TprodutosView = class(TFMXFormFactory { TFORM } , IView,
    IThisAs<TprodutosView>, IprodutosView, IViewAs<IprodutosView>, ILayout)
    Layout1: TLayout;
    MVCBrMongoConnection1: TMVCBrMongoConnection;
    MVCBrMongoDataset1: TMVCBrMongoDataset;
    MVCBrMongoDataset1codigo: TStringField;
    MVCBrMongoDataset1nome: TStringField;
    Grid1: TGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    NavigatorBindSourceDB1: TBindNavigator;
    procedure FormShow(Sender: TObject);
  private
    FInited: boolean;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ThisAs: TprodutosView;
    function ViewAs: IprodutosView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function GetLayout:TObject;
  end;

Implementation

{$R *.fmx}

function TprodutosView.ViewAs: IprodutosView;
begin
  result := self;
end;

procedure TprodutosView.FormShow(Sender: TObject);
begin
  MVCBrMongoDataset1.open;
end;

function TprodutosView.GetLayout: TObject;
begin
  result := Layout1;
end;

class function TprodutosView.New(aController: IController): IView;
begin
  result := TprodutosView.create(nil);
  result.Controller(aController);
end;

function TprodutosView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

function TprodutosView.ThisAs: TprodutosView;
begin
  result := self;
end;

function TprodutosView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
