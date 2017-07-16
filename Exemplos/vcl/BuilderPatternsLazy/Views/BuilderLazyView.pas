{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 15/07/2017 20:30:26                                  //}
{//************************************************************//}

/// <summary>
///    Uma View representa a camada de apresentação ao usuário
///    deve esta associado a um controller onde ocorrerá
///    a troca de informações e comunicação com os Models
/// </summary>
unit BuilderLazyView;

interface
uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes,MVCBr.Interf,System.JSON,
  MVCBr.View,MVCBr.FormView,MVCBr.Controller, Vcl.Controls, Vcl.StdCtrls;


type
/// Interface para a VIEW
  IBuilderLazyView = interface(IView)
    ['{B4BF06E2-4157-4FF4-8FCD-F0D6C5FB8805}']
    // incluir especializacoes aqui
  end;

/// Object Factory que implementa a interface da VIEW
  TBuilderLazyView = class(TFormFactory {TFORM} ,IView,IThisAs<TBuilderLazyView>,
  IBuilderLazyView,IViewAs<IBuilderLazyView>)
    Button1: TButton;
    Button2: TButton;
  private FInited:boolean;
  protected
    function Controller(const aController:IController):IView;override;
  public
   { Public declarations }
    class function New(AController:IController):IView;
    function ThisAs:TBuilderLazyView;
    function ViewAs:IBuilderLazyView;
    function ShowView(const AProc: TProc<IView>): integer;override;
end;

Implementation
{$R *.DFM}


function TBuilderLazyView.ViewAs:IBuilderLazyView;
begin
  result := self;
end;

class function TBuilderLazyView.new(AController:IController):IView;
begin
   result := TBuilderLazyView.create(nil);
   result.controller(AController);
end;

function TBuilderLazyView.Controller(const AController:IController):IView;
begin
  result := inherited Controller(AController);
  if not FInited then begin init; FInited:=true; end;
end;

function TBuilderLazyView.ThisAs:TBuilderLazyView;
begin
   result := self;
end;

function TBuilderLazyView.ShowView(const AProc:TProc<IView>):integer;
begin
  inherited;
end;

end.
