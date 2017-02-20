{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 19/02/2017 22:11:59                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit TabControlNavView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, FMX.Controls, FMX.TabControl,
  FMX.Types, MVCBr.Component, MVCBr.PageView, MVCBr.FMX.PageView,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  /// Interface para a VIEW
  ITabControlNavView = interface(IView)
    ['{856A3A74-9320-4AF8-ADD2-B7D9961FB571}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TTabControlNavView = class(TFormFactory { TFORM } , IView,
    IThisAs<TTabControlNavView>, ITabControlNavView,
    IViewAs<ITabControlNavView>)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    FMXPageViewManager1: TFMXPageViewManager;
    Button1: TButton;
    Layout1: TLayout;
    procedure Button1Click(Sender: TObject);
  private
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TTabControlNavView;
    function ViewAs: ITabControlNavView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

Implementation

{$R *.fmx}

uses EditorView;

function TTabControlNavView.Update: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TTabControlNavView.ViewAs: ITabControlNavView;
begin
  result := self;
end;

class function TTabControlNavView.New(aController: IController): IView;
begin
  result := TTabControlNavView.create(nil);
  result.Controller(aController);
end;

procedure TTabControlNavView.Button1Click(Sender: TObject);
begin
  FMXPageViewManager1.AddForm(TEditorView);
end;

function TTabControlNavView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
end;

function TTabControlNavView.This: TObject;
begin
  result := inherited This;
end;

function TTabControlNavView.ThisAs: TTabControlNavView;
begin
  result := self;
end;

function TTabControlNavView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
