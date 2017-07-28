{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 09/07/2017 10:45:40                                  //}
{//************************************************************//}

/// <summary>
///    Uma View representa a camada de apresentação ao usuário
///    deve esta associado a um controller onde ocorrerá
///    a troca de informações e comunicação com os Models
/// </summary>
unit StatesPatternsView;

interface
uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes,MVCBr.Interf,System.JSON,
  MVCBr.View,MVCBr.FormView,MVCBr.Controller;


type
/// Interface para a VIEW
  IStatesPatternsView = interface(IView)
    ['{06213FF9-7D76-4827-8871-13A9AA393B3A}']
    // incluir especializacoes aqui
  end;

/// Object Factory que implementa a interface da VIEW
  TStatesPatternsView = class(TFormFactory {TFORM} ,IView,IThisAs<TStatesPatternsView>,
  IStatesPatternsView,IViewAs<IStatesPatternsView>)
  private FInited:boolean;
  protected
    function Controller(const aController:IController):IView;override;
  public
   { Public declarations }
    class function New(AController:IController):IView;
    function ThisAs:TStatesPatternsView;
    function ViewAs:IStatesPatternsView;
    function ShowView(const AProc: TProc<IView>): integer;override;
end;

Implementation
{$R *.DFM}


function TStatesPatternsView.ViewAs:IStatesPatternsView;
begin
  result := self;
end;

class function TStatesPatternsView.new(AController:IController):IView;
begin
   result := TStatesPatternsView.create(nil);
   result.controller(AController);
end;

function TStatesPatternsView.Controller(const AController:IController):IView;
begin
  result := inherited Controller(AController);
  if not FInited then begin init; FInited:=true; end;
end;

function TStatesPatternsView.ThisAs:TStatesPatternsView;
begin
   result := self;
end;

function TStatesPatternsView.ShowView(const AProc:TProc<IView>):integer;
begin
  inherited;
end;

end.
