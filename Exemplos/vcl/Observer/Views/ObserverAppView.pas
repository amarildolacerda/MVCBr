{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 18/06/2017 15:57:22                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit ObserverAppView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.Controls, VCL.StdCtrls;

type
  /// Interface para a VIEW
  IObserverAppView = interface(IView)
    ['{BCBA96FB-0C7D-40A9-8ED5-24CEA0068F61}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TObserverAppView = class(TFormFactory { TFORM } , IView,
    IThisAs<TObserverAppView>, IObserverAppView, IViewAs<IObserverAppView>)
    Memo1: TMemo;
    Button1: TButton;
    procedure FormFactoryCreate(Sender: TObject);
    procedure FormFactoryViewEvent(AMessage: TJSONValue; var AHandled: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    FInited: boolean;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ThisAs: TObserverAppView;
    function ViewAs: IObserverAppView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

{$R *.DFM}
uses ObserverSender.Controller.Interf;

function TObserverAppView.ViewAs: IObserverAppView;
begin
  result := self;
end;

procedure TObserverAppView.FormFactoryCreate(Sender: TObject);
begin
  registerObserver('logar');
end;

procedure TObserverAppView.FormFactoryViewEvent(AMessage: TJSONValue;
  var AHandled: Boolean);
begin
   memo1.lines.add(  AMessage.toJson);
end;

class function TObserverAppView.New(aController: IController): IView;
begin
  result := TObserverAppView.create(nil);
  result.Controller(aController);
end;

procedure TObserverAppView.Button1Click(Sender: TObject);
begin
   ResolveController( IObserverSenderController  ).ShowView;
end;

function TObserverAppView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

function TObserverAppView.ThisAs: TObserverAppView;
begin
  result := self;
end;

function TObserverAppView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
