{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 01/05/2017 15:07:03                                  //}
{//************************************************************//}
/// <summary>
///    Uma View representa a camada de apresentação ao usuário
///    deve esta associado a um controller onde ocorrerá
///    a troca de informações e comunicação com os Models
/// </summary>
unit segundoFormView;
interface
uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes,MVCBr.Interf,
  MVCBr.View,MVCBr.FormView,MVCBr.Controller, FMX.Types, FMX.Controls,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;
type
/// Interface para a VIEW
  IsegundoFormView = interface(IView)
    ['{B9852487-FE7E-4EBF-AC4C-4D3979D10FAE}']
    // incluir especializacoes aqui
  end;
/// Object Factory que implementa a interface da VIEW
  TsegundoFormView = class(TFormFactory {TFORM} ,IView,IThisAs<TsegundoFormView>,
  IsegundoFormView,IViewAs<IsegundoFormView>, ILayout)
    Panel1: TPanel;
    Layout1: TLayout;
    Label1: TLabel;
  private
     FInited:Boolean;
  protected
    procedure Init;
    function Controller(const aController: IController): IView;override;
  public
   { Public declarations }
    class function New(AController:IController):IView;
    function This: TObject;override;
    function ThisAs:TsegundoFormView;
    function ViewAs:IsegundoFormView;
    function ShowView(const AProc: TProc<IView>): integer;override;
    function Update: IView;override;

        function GetLayout: TObject;


  end;
Implementation
{$R *.fmx}
function TsegundoFormView.Update:IView;
begin
  result := self;
  {codigo para atualizar a View vai aqui...}
end;
function TsegundoFormView.ViewAs:IsegundoFormView;
begin
  result := self;
end;
class function TsegundoFormView.new(AController:IController):IView;
begin
   result := TsegundoFormView.create(nil);
   result.controller(AController);
end;
function TsegundoFormView.Controller(const AController:IController):IView;
begin
  result := inherited Controller(AController);
  if not FInited then begin init; FInited:=true; end;
end;
function TsegundoFormView.GetLayout: TObject;
begin
  result := Layout1;
end;

procedure TsegundoFormView.Init;
begin
   // incluir incializações aqui
end;
function TsegundoFormView.This:TObject;
begin
   result := inherited This;
end;
function TsegundoFormView.ThisAs:TsegundoFormView;
begin
   result := self;
end;
function TsegundoFormView.ShowView(const AProc:TProc<IView>):integer;
begin
  inherited;
end;
end.
