unit MainView;

// Código gerado pelo assistente     MVCBr OTA
// www.tireideletra.com.br
{ .$I ..\inc\mvcbr.inc }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, StdCtrls, ComCtrls, ExtCtrls, Forms, MVCBr.Interf,
  Pessoas.ModuleModel.Interf,
  MVCBr.FormView, Main.ViewModel.Interf, MVCBr.Controller, Data.DB, Vcl.Grids,
  Vcl.DBGrids;

type
  IMainView = interface(IView)
    ['{965F82C7-8527-4B7A-BDB1-BF8CA6391B36}']
    // incluir especializacoes aqui
  end;

  TMainView = class(TFormFactory { TFORM } , IView, IThisAs<TMainView>,
    IMainView, IViewAs<IMainView>)
    DBGrid1: TDBGrid;
    procedure FormShow(Sender: TObject);
  private
    FViewModel: IMainViewModel;
    FCadastroModel:IPessoasModuleModel;
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
    function UpdateView: IView;
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

procedure TMainView.FormShow(Sender: TObject);
begin
   FCadastroModel := FController.This.GetModel<IPessoasModuleModel>;

   DBGrid1.DataSource := FCadastroModel.CadastroDatasource;

end;

class function TMainView.New(aController: IController): IView;
begin
  result := TMainView.create(nil);
  result.Controller(aController);
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
