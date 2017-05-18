{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/05/2017 23:22:04                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit ViewTemplateView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.WinXCtrls, VCL.Controls,
  VCL.Buttons, VCL.ExtCtrls, VCL.ComCtrls, VCL.StdCtrls;

type
  /// Interface para a VIEW
  IViewTemplateView = interface(IView)
    ['{9016D83F-1F08-4800-8DD0-280A84AC8B57}']
    // incluir especializacoes aqui
    procedure msgStatusX(ATexto: string);
    procedure msgStatusY(ATexto: string);
    procedure msgStatus(ATexto: string);
  end;

  /// Object Factory que implementa a interface da VIEW
  TViewTemplateView = class(TFormFactory { TFORM } , IView,
    IThisAs<TViewTemplateView>, IViewTemplateView, IViewAs<IViewTemplateView>)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    FInited: Boolean;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TViewTemplateView;
    function ViewAs: IViewTemplateView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;

    procedure msgStatusX(ATexto: string);
    procedure msgStatusY(ATexto: string);
    procedure msgStatus(ATexto: string);

  end;

Implementation

{$R *.DFM}

function TViewTemplateView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TViewTemplateView.ViewAs: IViewTemplateView;
begin
  result := self;
end;

class function TViewTemplateView.New(aController: IController): IView;
begin
  result := TViewTemplateView.create(nil);
  result.Controller(aController);
end;

function TViewTemplateView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TViewTemplateView.Init;
begin
  // incluir incializações aqui
end;

procedure TViewTemplateView.msgStatus(ATexto: string);
begin
  StatusBar1.Panels[2].Text := ATexto;
end;

procedure TViewTemplateView.msgStatusX(ATexto: string);
begin
  StatusBar1.Panels[0].Text := ATexto;

end;

procedure TViewTemplateView.msgStatusY(ATexto: string);
begin
  StatusBar1.Panels[1].Text := ATexto;
end;

function TViewTemplateView.This: TObject;
begin
  result := inherited This;
end;

function TViewTemplateView.ThisAs: TViewTemplateView;
begin
  result := self;
end;

function TViewTemplateView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

procedure TViewTemplateView.SpeedButton1Click(Sender: TObject);
begin
   close;
end;

end.
