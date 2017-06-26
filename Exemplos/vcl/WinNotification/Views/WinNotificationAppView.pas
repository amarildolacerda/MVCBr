{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 21/06/2017 18:38:16                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit WinNotificationAppView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.StdCtrls, VCL.Controls;

type
  /// Interface para a VIEW
  IWinNotificationAppView = interface(IView)
    ['{F63692B5-64D5-45BD-960F-8A9EE6545A27}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TWinNotificationAppView = class(TFormFactory { TFORM } , IView,
    IThisAs<TWinNotificationAppView>, IWinNotificationAppView,
    IViewAs<IWinNotificationAppView>)
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    FInited: boolean;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    procedure Release;//override;
    destructor destroy;override;
    class function New(aController: IController): IView;
    function ThisAs: TWinNotificationAppView;
    function ViewAs: IWinNotificationAppView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

{$R *.DFM}

uses WinNotification.Model.Interf;

function TWinNotificationAppView.ViewAs: IWinNotificationAppView;
begin
  result := self;
end;

class function TWinNotificationAppView.New(aController: IController): IView;
begin
  result := TWinNotificationAppView.create(nil);
  result.Controller(aController);
end;

procedure TWinNotificationAppView.Release;
begin
  inherited;
end;

procedure TWinNotificationAppView.Button1Click(Sender: TObject);
begin
  getModel<IWinNotificationModel>.Send('MVCBr', 'teste', Edit1.text);
end;

function TWinNotificationAppView.Controller(const aController
  : IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

destructor TWinNotificationAppView.destroy;
begin

  inherited;
end;

//TAggregatedObject
//TContainedObject


function TWinNotificationAppView.ThisAs: TWinNotificationAppView;
begin
  result := self;
end;

function TWinNotificationAppView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
