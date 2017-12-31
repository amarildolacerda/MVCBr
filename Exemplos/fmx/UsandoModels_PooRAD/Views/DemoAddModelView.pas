{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/10/2017 16:14:07                                  // }
{ //************************************************************// }

/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit DemoAddModelView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, MVCBr.Component, MVCBr.PageView,
  MVCBr.FMX.LayoutViewManager, FMX.Types, FMX.Controls, FMX.Layouts,
  FMX.Controls.Presentation, FMX.MultiView, FMX.StdCtrls, FMX.Objects;

type
  /// Interface para a VIEW
  IDemoAddModelView = interface(IView)
    ['{8DF5DE73-D7EA-4D44-BECB-1897FD7698ED}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TDemoAddModelView = class(TFormFactory { TFORM } , IView,
    IThisAs<TDemoAddModelView>, IDemoAddModelView, IViewAs<IDemoAddModelView>)
    Layout1: TLayout;
    FMXLayoutViewManager1: TFMXLayoutViewManager;
    StyleBook1: TStyleBook;
    MultiView1: TMultiView;
    RoundRect1: TRoundRect;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image1: TImage;
    procedure SpeedButton1Click(Sender: TObject);
  private
    FInited: boolean;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ThisAs: TDemoAddModelView;
    function ViewAs: IDemoAddModelView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

{$R *.fmx}

uses produtos.Controller.Interf;

function TDemoAddModelView.ViewAs: IDemoAddModelView;
begin
  result := self;
end;

class function TDemoAddModelView.New(aController: IController): IView;
begin
  result := TDemoAddModelView.create(nil);
  result.Controller(aController);
end;

function TDemoAddModelView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

function TDemoAddModelView.ThisAs: TDemoAddModelView;
begin
  result := self;
end;

function TDemoAddModelView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

procedure TDemoAddModelView.SpeedButton1Click(Sender: TObject);
begin
  FMXLayoutViewManager1.AddView(IProdutosController);
end;

end.
