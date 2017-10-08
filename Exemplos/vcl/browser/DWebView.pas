{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 19/02/2017 19:35:38                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit DWebView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, Vcl.StdCtrls, Vcl.Controls,
  Vcl.ExtCtrls, Vcl.ComCtrls, MVCBr.Component, MVCBr.PageView,
  MVCBr.VCL.PageView, Vcl.Buttons;

type
  /// Interface para a VIEW
  IDWebView = interface(IView)
    ['{5655F287-2FB7-460A-BA9D-6959902F28AF}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TDWebView = class(TFormFactory { TFORM } , IView, IThisAs<TDWebView>,
    IDWebView, IViewAs<IDWebView>)
    PageControl1: TPageControl;
    Panel1: TPanel;
    Edit1: TEdit;
    VCLPageViewManager1: TVCLPageViewManager;
    Button1: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TDWebView;
    function ViewAs: IDWebView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
  end;

Implementation

{$R *.DFM}
uses DBowser.Controller.Interf, wConfig;

function TDWebView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TDWebView.ViewAs: IDWebView;
begin
  result := self;
end;

class function TDWebView.New(aController: IController): IView;
begin
  result := TDWebView.create(nil);
  result.Controller(aController);
end;


///  usando o Controller para isntancia o VIEW  dentro de um TPageControl ///
procedure TDWebView.Button1Click(Sender: TObject);
var cnt:IPageView;
begin
   cnt := VCLPageViewManager1.AddView(IdBowserController);  // adiciona um novo formulario ao pagecontrol
   (cnt.This.Controller as IdBowserController).AddPage(edit1.text);  // carrega o endereço da pagina digitado.
end;

function TDWebView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
end;

procedure TDWebView.FormCreate(Sender: TObject);
begin
    edit1.Text := 'www.google.com.br';
end;

function TDWebView.This: TObject;
begin
  result := inherited This;
end;

function TDWebView.ThisAs: TDWebView;
begin
  result := self;
end;

function TDWebView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

procedure TDWebView.SpeedButton2Click(Sender: TObject);
begin
   VCLPageViewManager1.AddForm(TConfig,nil);
end;

end.
