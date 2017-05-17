unit MainView;

// Código gerado pelo assistente     MVCBr OTA
// www.tireideletra.com.br
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, StdCtrls, ComCtrls, ExtCtrls, Forms, MVCBr.Interf,
  MVCbr.FormView,
  Main.ViewModel.Interf, MVCBr.Controller;

type
  IMainView = interface(IView)
    ['{FBC8D581-6590-4F9B-8CBE-51FF51968922}']
    // incluir especializacoes aqui
  end;

  TMainView = class(TFormFactory, IView, IThisAs<TMainView>, IMainView,
    IViewAs<IMainView>)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    FViewModel: IMainViewModel;
  protected
    function Controller(const aController: IController): IView;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ViewModel(const AViewModel: IMainViewModel): IView;
    function This: TObject;
    function ThisAs: TMainView;
    function ViewAs: IMainView;
    function ShowView(const AProc: TProc<IView>): integer;
    function UpdateView: IView;override;
  end;

implementation

{$R *.dfm}

function TMainView.UpdateView: IView;
begin
  result := self;
  if assigned(FViewModel) then
    FViewModel.UpdateView(self as IView);
  { codigo para atualizar a View vai aqui... }
end;

function TMainView.ViewAs: IMainView;
begin
  result := self;
end;

class function TMainView.New(aController: IController): IView;
begin
  result := TMainView.create(nil);
  result.Controller(aController);
end;

procedure TMainView.Button1Click(Sender: TObject);
begin
 if not assigned(FViewModel) then
   FViewModel := GetViewModel as IMainViewModel;
  FViewModel.ValidarCPF(Edit1.Text);
end;

function TMainView.Controller(const aController: IController): IView;
begin
  result := self;
  FController := aController;
end;

function TMainView.ViewModel(const AViewModel: IMainViewModel): IView;
begin
  result := self;
  if assigned(AViewModel) then
    FViewModel := AViewModel;
end;

function TMainView.This: TObject;
begin
  result := self;
end;

function TMainView.ThisAs: TMainView;
begin
  result := self;
end;

function TMainView.ShowView(const AProc: TProc<IView>): integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This, IMainViewModel, FViewModel);
  end;
  ShowModal;
  result := ord(ModalResult);
  if assigned(AProc) then
    AProc(self);
end;

end.
