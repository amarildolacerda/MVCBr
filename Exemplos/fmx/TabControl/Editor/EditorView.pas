{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 19/02/2017 22:53:45                                  //}
{//************************************************************//}
/// <summary>
///    Uma View representa a camada de apresentação ao usuário
///    deve esta associado a um controller onde ocorrerá
///    a troca de informações e comunicação com os Models
/// </summary>
unit EditorView;
interface
uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes,MVCBr.Interf,
  MVCBr.View,MVCBr.FormView,MVCBr.Controller, FMX.Types, FMX.Controls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;
type
/// Interface para a VIEW
  IEditorView = interface(IView)
    ['{13B6040B-CCCD-46AF-B512-C9B96553B7CF}']
    // incluir especializacoes aqui
  end;
/// Object Factory que implementa a interface da VIEW
  TEditorView = class(TFormFactory {TFORM} ,IView,IThisAs<TEditorView>,
  IEditorView,IViewAs<IEditorView>)
    Memo1: TMemo;
  private
  protected
    function Controller(const aController: IController): IView;override;
  public
   { Public declarations }
    class function New(AController:IController):IView;
    function This: TObject;override;
    function ThisAs:TEditorView;
    function ViewAs:IEditorView;
    function ShowView(const AProc: TProc<IView>): integer;override;
    function Update: IView;override;
  end;
Implementation
{$R *.fmx}
function TEditorView.Update:IView;
begin
  result := self;
  {codigo para atualizar a View vai aqui...}
end;
function TEditorView.ViewAs:IEditorView;
begin
  result := self;
end;
class function TEditorView.new(AController:IController):IView;
begin
   result := TEditorView.create(nil);
   result.controller(AController);
end;
function TEditorView.Controller(const AController:IController):IView;
begin
  result := inherited Controller(AController);
end;
function TEditorView.This:TObject;
begin
   result := inherited This;
end;
function TEditorView.ThisAs:TEditorView;
begin
   result := self;
end;
function TEditorView.ShowView(const AProc:TProc<IView>):integer;
begin
  inherited;
end;
end.
