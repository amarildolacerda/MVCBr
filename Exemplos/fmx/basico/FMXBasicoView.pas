{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 13/02/2017 22:49:37                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit FMXBasicoView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, FMXBasico.ViewModel.Interf, MVCBr.Controller;

type
  /// Interface para a VIEW
  IFMXBasicoView = interface(IView)
    ['{6E321EE4-A607-4CDC-A63A-56FCA7E90A09}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TFMXBasicoView = class(TFormFactory { TFORM } , IView,
    IThisAs<TFMXBasicoView>, IFMXBasicoView, IViewAs<IFMXBasicoView>)
  private
    FViewModel: IFMXBasicoViewModel;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ViewModel(const AViewModel: IFMXBasicoViewModel): IView;
    function This: TObject; override;
    function ThisAs: TFMXBasicoView;
    function ViewAs: IFMXBasicoView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

implementation

{$R *.fmx}

function TFMXBasicoView.Update: IView;
begin
  result := self;
  if assigned(FViewModel) then
    FViewModel.Update(self as IView);
  { codigo para atualizar a View vai aqui... }
end;

function TFMXBasicoView.ViewAs: IFMXBasicoView;
begin
  result := self;
end;

class function TFMXBasicoView.New(aController: IController): IView;
begin
  result := TFMXBasicoView.create(nil);
  result.Controller(aController);
end;

function TFMXBasicoView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not assigned(FViewModel) then
    FViewModel := getViewModel as IFMXBasicoViewModel;
end;

function TFMXBasicoView.ViewModel(const AViewModel: IFMXBasicoViewModel): IView;
begin
  result := self;
  if assigned(AViewModel) then
    FViewModel := AViewModel;
end;

function TFMXBasicoView.This: TObject;
begin
  result := inherited This;
end;

function TFMXBasicoView.ThisAs: TFMXBasicoView;
begin
  result := self;
end;

function TFMXBasicoView.ShowView(const AProc: TProc<IView>): integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This, IFMXBasicoViewModel, FViewModel);
  end;
  inherited;
end;

end.
