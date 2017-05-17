{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 11/02/2017 21:35:10                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit NewMVCAppView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, NewMVCApp.ViewModel.Interf, MVCBr.Controller,
  FMX.Types, FMX.Controls, FMX.Controls.Presentation, FMX.StdCtrls;

type
  /// Interface para a VIEW
  INewMVCAppView = interface(IView)
    ['{1B7FA825-1200-4353-941C-E81314CC75F8}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TNewMVCAppView = class(TFormFactory { TFORM } , IView,
    IThisAs<TNewMVCAppView>, INewMVCAppView, IViewAs<INewMVCAppView>)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    FViewModel: INewMVCAppViewModel;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ViewModel(const AViewModel: INewMVCAppViewModel): IView;
    function This: TObject; override;
    function ThisAs: TNewMVCAppView;
    function ViewAs: INewMVCAppView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
  end;

implementation

{$R *.fmx}

uses Config.Controller.Interf;


function TNewMVCAppView.UpdateView: IView;
begin
  result := self;
  if assigned(FViewModel) then
    FViewModel.UpdateView(self as IView);
  { codigo para atualizar a View vai aqui... }
end;

function TNewMVCAppView.ViewAs: INewMVCAppView;
begin
  result := self;
end;

class function TNewMVCAppView.New(aController: IController): IView;
begin
  result := TNewMVCAppView.create(nil);
  result.Controller(aController);
end;

procedure TNewMVCAppView.Button1Click(Sender: TObject);
begin
   // FController.ResolveController(  iConfigController  ).getview.ShowView(nil);
   //  ou
   ShowView(IConfigController,nil);
end;

function TNewMVCAppView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
end;

function TNewMVCAppView.ViewModel(const AViewModel: INewMVCAppViewModel): IView;
begin
  result := self;
  if assigned(AViewModel) then
    FViewModel := AViewModel;
end;

function TNewMVCAppView.This: TObject;
begin
  result := inherited This;
end;

function TNewMVCAppView.ThisAs: TNewMVCAppView;
begin
  result := self;
end;

function TNewMVCAppView.ShowView(const AProc: TProc<IView>): integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This, INewMVCAppViewModel, FViewModel);
  end;
  inherited;
end;

end.
