{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/05/2017 23:20:37                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit UsandoTemplateView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, Vcl.StdCtrls, Vcl.Controls,
  Vcl.ExtCtrls, MVCBr.Component, MVCBr.PageView, MVCBr.VCL.PageView,
  Vcl.ComCtrls;

type
  /// Interface para a VIEW
  IUsandoTemplateView = interface(IView)
    ['{02FCF0BE-D360-4866-8F02-1057D03AEBD9}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TUsandoTemplateView = class(TFormFactory { TFORM } , IView,
    IThisAs<TUsandoTemplateView>, IUsandoTemplateView,
    IViewAs<IUsandoTemplateView>)
    PageControl1: TPageControl;
    VCLPageViewManager1: TVCLPageViewManager;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
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
    function ThisAs: TUsandoTemplateView;
    function ViewAs: IUsandoTemplateView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
  end;

Implementation

{$R *.DFM}
uses EditorTextoView.Controller.Interf, NavegadorView.Controller.Interf,
  Navegador.View;

function TUsandoTemplateView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TUsandoTemplateView.ViewAs: IUsandoTemplateView;
begin
  result := self;
end;

class function TUsandoTemplateView.New(aController: IController): IView;
begin
  result := TUsandoTemplateView.create(nil);
  result.Controller(aController);
end;

procedure TUsandoTemplateView.Button1Click(Sender: TObject);
begin
   VCLPageViewManager1.addView(IEditorTextoViewController);
end;

procedure TUsandoTemplateView.Button2Click(Sender: TObject);
var AView:IView;
begin
   {
    AView := TNavegadorView.create(nil) as INavegadorView;
    VCLPageViewManager1.AddView(AView);
   }
   VCLPageViewManager1.addView(INavegadorViewController);
end;

function TUsandoTemplateView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TUsandoTemplateView.Init;
begin
  // incluir incializações aqui
end;

function TUsandoTemplateView.This: TObject;
begin
  result := inherited This;
end;

function TUsandoTemplateView.ThisAs: TUsandoTemplateView;
begin
  result := self;
end;

function TUsandoTemplateView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
