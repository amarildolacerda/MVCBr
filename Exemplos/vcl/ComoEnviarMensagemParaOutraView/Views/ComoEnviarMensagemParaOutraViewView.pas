{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/04/2017 12:17:21                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit ComoEnviarMensagemParaOutraViewView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.StdCtrls, VCL.ComCtrls,
  VCL.Controls, MVCBr.Component, MVCBr.PageView, MVCBr.VCL.PageView, Vcl.Menus;

type
  /// Interface para a VIEW
  IComoEnviarMensagemParaOutraViewView = interface(IView)
    ['{7B246FE6-DF26-4174-838C-E308AA255670}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TComoEnviarMensagemParaOutraViewView = class(TFormFactory { TFORM } , IView, IThisAs<TComoEnviarMensagemParaOutraViewView>,
    IComoEnviarMensagemParaOutraViewView, IViewAs<IComoEnviarMensagemParaOutraViewView>)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Button1: TButton;
    VCLPageViewManager1: TVCLPageViewManager;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    MainMenu1: TMainMenu;
    ViewFilha1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ViewFilha1Click(Sender: TObject);
  private
    FInited: Boolean;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TComoEnviarMensagemParaOutraViewView;
    function ViewAs: IComoEnviarMensagemParaOutraViewView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;

    function ViewEvent(AMessage: string; var AHandled: Boolean): IView; override;

  end;

Implementation

uses Filha.Controller.Interf;
{$R *.DFM}

function TComoEnviarMensagemParaOutraViewView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TComoEnviarMensagemParaOutraViewView.ViewAs: IComoEnviarMensagemParaOutraViewView;
begin
  result := self;
end;

function TComoEnviarMensagemParaOutraViewView.ViewEvent(AMessage: string; var AHandled: Boolean): IView;
var
  rst: integer;
begin
  rst := -1;
  if AMessage.Equals('tab1.show') then
    rst := 0
  else if AMessage.Equals('tab2.show') then
    rst := 1;

  PageControl1.TabIndex := rst;

  AHandled := (rst >= 0);

end;

procedure TComoEnviarMensagemParaOutraViewView.ViewFilha1Click(Sender: TObject);
begin
  resolveController<IFilhaController>.Showview;

end;

class function TComoEnviarMensagemParaOutraViewView.New(aController: IController): IView;
begin
  result := TComoEnviarMensagemParaOutraViewView.create(nil);
  result.Controller(aController);
end;

procedure TComoEnviarMensagemParaOutraViewView.Button1Click(Sender: TObject);
{
  exemplo: showmodal;
  var
  aController: IFilhaController;
  begin
  aController := resolveController<IFilhaController>;
  aController.ShowView();
  end;
}
begin

  /// como abrir dentro do PageControl
  VCLPageViewManager1.AddView(IFilhaController);
  //resolveController<IFilhaController>.Showview;

end;

procedure TComoEnviarMensagemParaOutraViewView.Button2Click(Sender: TObject);
var
  aController: IFilhaController;
begin
  aController := resolveController<IFilhaController>;
  aController.TrocarMensagemPanel(Edit1.Text);
end;

procedure TComoEnviarMensagemParaOutraViewView.Button3Click(Sender: TObject);
var
  LHandled: Boolean;
  aController: IFilhaController;
begin
  aController := resolveController<IFilhaController>;
  ApplicationController.ViewEventOther(aController, Edit1.Text, LHandled);
end;

function TComoEnviarMensagemParaOutraViewView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TComoEnviarMensagemParaOutraViewView.Init;
begin
  // incluir incializações aqui
end;

function TComoEnviarMensagemParaOutraViewView.This: TObject;
begin
  result := inherited This;
end;

function TComoEnviarMensagemParaOutraViewView.ThisAs: TComoEnviarMensagemParaOutraViewView;
begin
  result := self;
end;

function TComoEnviarMensagemParaOutraViewView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
