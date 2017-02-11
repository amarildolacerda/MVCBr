{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 11/02/2017 21:37:21                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit ConfigView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, Config.ViewModel.Interf, MVCBr.Controller;

type
  /// Interface para a VIEW
  IConfigView = interface(IView)
    ['{A4B9DD79-7FE5-4AA0-84DE-4FDF064C3873}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TConfigView = class(TFormFactory { TFORM } , IView, IThisAs<TConfigView>,
    IConfigView, IViewAs<IConfigView>)
  private
    FViewModel: IConfigViewModel;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ViewModel(const AViewModel: IConfigViewModel): IView;
    function This: TObject; override;
    function ThisAs: TConfigView;
    function ViewAs: IConfigView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

implementation

{$R *.fmx}

function TConfigView.Update: IView;
begin
  result := self;
  if assigned(FViewModel) then
    FViewModel.Update(self as IView);
  { codigo para atualizar a View vai aqui... }
end;

function TConfigView.ViewAs: IConfigView;
begin
  result := self;
end;

class function TConfigView.New(aController: IController): IView;
begin
  result := TConfigView.create(nil);
  result.Controller(aController);
end;

function TConfigView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
end;

function TConfigView.ViewModel(const AViewModel: IConfigViewModel): IView;
begin
  result := self;
  if assigned(AViewModel) then
    FViewModel := AViewModel;
end;

function TConfigView.This: TObject;
begin
  result := inherited This;
end;

function TConfigView.ThisAs: TConfigView;
begin
  result := self;
end;

function TConfigView.ShowView(const AProc: TProc<IView>): integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This, IConfigViewModel, FViewModel);
  end;
  inherited;
end;

end.
