{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 13/02/2017 23:07:44                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit AppPageControlView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, AppPageControl.ViewModel.Interf, MVCBr.Controller,
  VCL.Controls, VCL.ComCtrls, MVCBr.VCL.PageControl;

type
  /// Interface para a VIEW
  IAppPageControlView = interface(IView)
    ['{2ABF9018-81E6-4DC6-BCB7-990BA2E6349E}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TAppPageControlView = class(TFormFactory { TFORM } , IView,
    IThisAs<TAppPageControlView>, IAppPageControlView,
    IViewAs<IAppPageControlView>)
    PageControl1: TPageControl;
  private
    FViewModel: IAppPageControlViewModel;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ViewModel(const AViewModel: IAppPageControlViewModel): IView;
    function This: TObject; override;
    function ThisAs: TAppPageControlView;
    function ViewAs: IAppPageControlView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

implementation

{$R *.dfm}

function TAppPageControlView.Update: IView;
begin
  result := self;
  if assigned(FViewModel) then
    FViewModel.Update(self as IView);
  { codigo para atualizar a View vai aqui... }
end;

function TAppPageControlView.ViewAs: IAppPageControlView;
begin
  result := self;
end;

class function TAppPageControlView.New(aController: IController): IView;
begin
  result := TAppPageControlView.create(nil);
  result.Controller(aController);
end;

function TAppPageControlView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not assigned(FViewModel) then
    FViewModel := getViewModel as IAppPageControlViewModel;
end;

function TAppPageControlView.ViewModel(const AViewModel
  : IAppPageControlViewModel): IView;
begin
  result := self;
  if assigned(AViewModel) then
    FViewModel := AViewModel;
end;

function TAppPageControlView.This: TObject;
begin
  result := inherited This;
end;

function TAppPageControlView.ThisAs: TAppPageControlView;
begin
  result := self;
end;

function TAppPageControlView.ShowView(const AProc: TProc<IView>): integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This, IAppPageControlViewModel, FViewModel);
  end;
  inherited;
end;

end.
