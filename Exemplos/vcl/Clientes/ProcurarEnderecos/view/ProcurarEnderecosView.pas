unit ProcurarEnderecosView;

// Código gerado pelo assistente     MVCBr OTA
// www.tireideletra.com.br
{ .$I ..\inc\mvcbr.inc }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, StdCtrls, ComCtrls, ExtCtrls, Forms, MVCBr.Interf,
  MVCBr.FormView, ProcurarEnderecos.ViewModel.Interf, MVCBr.Controller;

type
  IProcurarEnderecosView = interface(IView)
    ['{B9CF815F-841A-48B3-90F4-AEC823D86362}']
    // incluir especializacoes aqui
  end;

  TProcurarEnderecosView = class(TFormFactory { TFORM } , IView,
    IThisAs<TProcurarEnderecosView>, IProcurarEnderecosView,
    IViewAs<IProcurarEnderecosView>)
    Memo1: TMemo;
  private
    FViewModel: IProcurarEnderecosViewModel;
    FController: IController;
  protected
    function Controller(const aController: IController): IView;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ViewModel(const AViewModel: IProcurarEnderecosViewModel): IView;
    function This: TObject;
    function ThisAs: TProcurarEnderecosView;
    function ViewAs: IProcurarEnderecosView;
    function ShowView(const AProc: TProc<IView>): integer;
    function UpdateView: IView;OVerride;
  end;

implementation

{$R *.dfm}

function TProcurarEnderecosView.UpdateView: IView;
begin
  result := self;
  if assigned(FViewModel) then
    FViewModel.UpdateView(self as IView);
  { codigo para atualizar a View vai aqui... }
end;

function TProcurarEnderecosView.ViewAs: IProcurarEnderecosView;
begin
  result := self;
end;

class function TProcurarEnderecosView.New(aController: IController): IView;
begin
  result := TProcurarEnderecosView.create(nil);
  result.Controller(aController);
end;

function TProcurarEnderecosView.Controller(const aController
  : IController): IView;
begin
  result := self;
  FController := aController;
end;

function TProcurarEnderecosView.ViewModel(const AViewModel
  : IProcurarEnderecosViewModel): IView;
begin
  result := self;
  if assigned(AViewModel) then
    FViewModel := AViewModel;
end;

function TProcurarEnderecosView.This: TObject;
begin
  result := self;
end;

function TProcurarEnderecosView.ThisAs: TProcurarEnderecosView;
begin
  result := self;
end;

function TProcurarEnderecosView.ShowView(const AProc: TProc<IView>): integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This, IProcurarEnderecosViewModel, FViewModel);
  end;
  ShowModal;
  result := ord(ModalResult);
  if assigned(AProc) then
    AProc(self);
end;

end.
