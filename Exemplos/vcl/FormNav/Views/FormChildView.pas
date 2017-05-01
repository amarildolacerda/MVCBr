{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 26/03/2017 11:42:00                                  //}
{//************************************************************//}
/// <summary>
///    Uma View representa a camada de apresentação ao usuário
///    deve esta associado a um controller onde ocorrerá
///    a troca de informações e comunicação com os Models
/// </summary>
unit FormChildView;
interface
uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes,MVCBr.Interf,
  MVCBr.View,MVCBr.FormView,MVCBr.Controller, Vcl.Controls, Vcl.ExtCtrls;
type
/// Interface para a VIEW
  IFormChildView = interface(IView)
    ['{E70AD251-AE02-4B30-B53E-91DF1AC6D6AD}']
    // incluir especializacoes aqui
  end;
/// Object Factory que implementa a interface da VIEW
  TFormChildView = class(TFormFactory {TFORM} ,IView,IThisAs<TFormChildView>,
  IFormChildView,IViewAs<IFormChildView>)
    Panel1: TPanel;
  private
     FInited:Boolean;
  protected
    procedure Init;
    function Controller(const aController: IController): IView;override;
  public
   { Public declarations }
    class function New(AController:IController):IView;
    function This: TObject;override;
    function ThisAs:TFormChildView;
    function ViewAs:IFormChildView;
    function ShowView(const AProc: TProc<IView>): integer;override;
    function Update: IView;override;
  end;
Implementation
{$R *.DFM}
function TFormChildView.Update:IView;
begin
  result := self;
  {codigo para atualizar a View vai aqui...}
end;
function TFormChildView.ViewAs:IFormChildView;
begin
  result := self;
end;
class function TFormChildView.new(AController:IController):IView;
begin
   result := TFormChildView.create(nil);
   result.controller(AController);
end;
function TFormChildView.Controller(const AController:IController):IView;
begin
  result := inherited Controller(AController);
  if not FInited then begin init; FInited:=true; end;
end;
procedure TFormChildView.Init;
begin
   // incluir incializações aqui
end;
function TFormChildView.This:TObject;
begin
   result := inherited This;
end;
function TFormChildView.ThisAs:TFormChildView;
begin
   result := self;
end;
function TFormChildView.ShowView(const AProc:TProc<IView>):integer;
begin
  inherited;
end;
end.
