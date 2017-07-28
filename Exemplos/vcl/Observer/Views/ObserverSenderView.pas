{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 18/06/2017 16:01:18                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit ObserverSenderView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.StdCtrls, VCL.Controls;

type
  /// Interface para a VIEW
  IObserverSenderView = interface(IView)
    ['{810F7B13-38AC-4143-BCB6-233522EDF1C1}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TObserverSenderView = class(TFormFactory { TFORM } , IView,
    IThisAs<TObserverSenderView>, IObserverSenderView,
    IViewAs<IObserverSenderView>)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FInited: boolean;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ThisAs: TObserverSenderView;
    function ViewAs: IObserverSenderView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

{$R *.DFM}

function TObserverSenderView.ViewAs: IObserverSenderView;
begin
  result := self;
end;

class function TObserverSenderView.New(aController: IController): IView;
begin
  result := TObserverSenderView.create(nil);
  result.Controller(aController);
end;

procedure TObserverSenderView.Button1Click(Sender: TObject);
var
  j: TJsonObject;
begin
  j := TJsonObject.create;
  j.addpair('mensagem', Edit1.text);
  try
    UpdateObserver('logar', j);
  finally
    j.free;
  end;
end;

procedure TObserverSenderView.Button2Click(Sender: TObject);
begin
   UpdateObserver('logar',edit1.text);
end;

function TObserverSenderView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

function TObserverSenderView.ThisAs: TObserverSenderView;
begin
  result := self;
end;

function TObserverSenderView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
