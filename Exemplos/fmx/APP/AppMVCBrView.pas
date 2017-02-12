{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 11/02/2017 22:18:59                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit AppMVCBrView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, AppMVCBr.ViewModel.Interf, MVCBr.Controller;

type
  /// Interface para a VIEW
  IAppMVCBrView = interface(IView)
    ['{B508F85D-D6A4-48F0-89D0-E8708AB298FE}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TAppMVCBrView = class(TFormFactory { TFORM } , IView, IThisAs<TAppMVCBrView>,
    IAppMVCBrView, IViewAs<IAppMVCBrView>)
  private
    FViewModel: IAppMVCBrViewModel;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ViewModel(const AViewModel: IAppMVCBrViewModel): IView;
    function This: TObject; override;
    function ThisAs: TAppMVCBrView;
    function ViewAs: IAppMVCBrView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

implementation

{$R *.fmx}

function TAppMVCBrView.Update: IView;
begin
  result := self;
  if assigned(FViewModel) then
    FViewModel.Update(self as IView);
  { codigo para atualizar a View vai aqui... }
end;

function TAppMVCBrView.ViewAs: IAppMVCBrView;
begin
  result := self;
end;

class function TAppMVCBrView.New(aController: IController): IView;
begin
  result := TAppMVCBrView.create(nil);
  result.Controller(aController);
end;

function TAppMVCBrView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
end;

function TAppMVCBrView.ViewModel(const AViewModel: IAppMVCBrViewModel): IView;
begin
  result := self;
  if assigned(AViewModel) then
    FViewModel := AViewModel;
end;

function TAppMVCBrView.This: TObject;
begin
  result := inherited This;
end;

function TAppMVCBrView.ThisAs: TAppMVCBrView;
begin
  result := self;
end;

function TAppMVCBrView.ShowView(const AProc: TProc<IView>): integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This, IAppMVCBrViewModel, FViewModel);
  end;
  inherited;
end;

end.
