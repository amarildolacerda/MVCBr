{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 26/03/2017 12:18:52                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit embededFormView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.Controls, VCL.ExtCtrls,
  Vcl.StdCtrls;

type
  /// Interface para a VIEW
  IEmbededFormView = interface(IView)
    ['{E204363C-8E8C-478A-A558-A95EF4AAF839}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TembededFormView = class(TFormFactory { TFORM } , IView,
    IThisAs<TembededFormView>, IembededFormView, IViewAs<IembededFormView>)
    Panel1: TPanel;
    Memo1: TMemo;
  private
    FInited: Boolean;
  protected
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TembededFormView;
    function ViewAs: IembededFormView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function ViewEvent(AMessage:string):IView;override;

    function Update: IView; override;
  end;

Implementation

{$R *.DFM}

function TembededFormView.Update: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TembededFormView.ViewAs: IembededFormView;
begin
  result := self;
end;

function TembededFormView.ViewEvent(AMessage: string): IView;
begin
    memo1.Lines.Add(AMessage);
end;

class function TembededFormView.New(aController: IController): IView;
begin
  result := TembededFormView.create(nil);
  result.Controller(aController);
end;

function TembededFormView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TembededFormView.Init;
begin
  // incluir incializações aqui
end;

function TembededFormView.This: TObject;
begin
  result := inherited This;
end;

function TembededFormView.ThisAs: TembededFormView;
begin
  result := self;
end;

function TembededFormView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
