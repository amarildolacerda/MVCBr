unit ProcurarEnderecosView;
// Código gerado pelo assistente     MVCBr OTA
// www.tireideletra.com.br
{.$I ..\inc\mvcbr.inc}
interface
uses
  Windows, Messages, SysUtils,  Classes,Graphics,
  Controls,StdCtrls,ComCtrls,ExtCtrls,Forms,MVCBr.Interf,
  MVCBr.View, ProcurarEnderecos.ViewModel.Interf ,MVCBr.Controller;
type
  IProcurarEnderecosView = interface(IView)
    ['{B9CF815F-841A-48B3-90F4-AEC823D86362}']
    // incluir especializacoes aqui
  end;
  TProcurarEnderecosView = class(TFormFactory {TFORM} ,IView,IThisAs<TProcurarEnderecosView>,
                      IProcurarEnderecosView,IViewAs<IProcurarEnderecosView>)
    Memo1: TMemo;
  private
    FViewModel : IProcurarEnderecosViewModel;
    FController : IController;
  protected
    function Controller(const aController: IController): IView;
  public
   { Public declarations }
    class function New(AController:IController):IView;
    function ViewModel(const AViewModel:IProcurarEnderecosViewModel):IView;
    function This: TObject;
    function ThisAs:TProcurarEnderecosView;
    function ViewAs:IProcurarEnderecosView;
    function ShowView(const AProc: TProc<IView>): integer;
    function Update: IView;
  end;
implementation
{$R *.dfm}
function TProcurarEnderecosView.Update:IView;
begin
  result := self;
  if assigned(FViewModel) then FViewModel.update(self as IView);
  {codigo para atualizar a View vai aqui...}
end;
function TProcurarEnderecosView.ViewAs:IProcurarEnderecosView;
begin
  result := self;
end;
class function TProcurarEnderecosView.new(AController:IController):IView;
begin
   result := TProcurarEnderecosView.create(nil);
   result.controller(AController);
end;
function TProcurarEnderecosView.Controller(const AController:IController):IView;
begin
  result := self;
  FController := AController;
end;
function TProcurarEnderecosView.ViewModel(const AViewModel:IProcurarEnderecosViewModel):IView;
begin
   result := self;
  if assigned(AViewModel) then
   FViewModel := AViewModel;
end;
function TProcurarEnderecosView.This:TObject;
begin
   result := self;
end;
function TProcurarEnderecosView.ThisAs:TProcurarEnderecosView;
begin
   result := self;
end;
function TProcurarEnderecosView.ShowView(const AProc:TProc<IView>):integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This,IProcurarEnderecosViewModel,FViewModel);
  end;
  ShowModal;
  result := ord(ModalResult);
  if assigned(AProc) then AProc(self);
end;
end.
