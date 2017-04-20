{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/04/2017 12:19:36                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit FilhaView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.StdCtrls, VCL.Controls,
  VCL.ExtCtrls;

type
  /// Interface para a VIEW
  IFilhaView = interface(IView)
    ['{94305293-779A-45D2-BA37-C67ED0D8E73E}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TFilhaView = class(TFormFactory { TFORM } , IView, IThisAs<TFilhaView>, IFilhaView, IViewAs<IFilhaView>)
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
    function ThisAs: TFilhaView;
    function ViewAs: IFilhaView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;


    function ViewEvent( AMessage:string;var AHandled:boolean):IView;override;

  end;

Implementation

{$R *.DFM}

function TFilhaView.Update: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TFilhaView.ViewAs: IFilhaView;
begin
  result := self;
end;

function TFilhaView.ViewEvent(AMessage: string; var AHandled: boolean): IView;
begin
    Panel1.Caption := AMessage;
end;

class function TFilhaView.New(aController: IController): IView;
begin
  result := TFilhaView.create(nil);
  result.Controller(aController);
end;

procedure TFilhaView.Button1Click(Sender: TObject);
var LHandled:boolean;
begin
  ApplicationController.ViewEvent('tab1.show', LHandled);
end;

procedure TFilhaView.Button2Click(Sender: TObject);
var LHandled:boolean;
begin
  ApplicationController.ViewEvent('tab2.show',LHandled);
end;

function TFilhaView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TFilhaView.Init;
begin
  // incluir incializações aqui
end;

function TFilhaView.This: TObject;
begin
  result := inherited This;
end;

function TFilhaView.ThisAs: TFilhaView;
begin
  result := self;
end;

function TFilhaView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
