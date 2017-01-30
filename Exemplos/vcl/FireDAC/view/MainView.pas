unit MainView;
// Código gerado pelo assistente     MVCBr OTA
// www.tireideletra.com.br
{$I+ ..\inc\mvcbr.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, StdCtrls, ComCtrls, ExtCtrls, Forms, MVCBr.Interf,
  MVCBr.View, Main.ViewModel.Interf, MVCBr.Controller, Data.DB, Vcl.Grids,
  Vcl.DBGrids;

type
  IMainView = interface(IView)
    ['{5D341F26-EB13-410D-BB31-DF3CC6F5E266}']
    // incluir especializacoes aqui
  end;

  TMainView = class(TFormFactory { TFORM } , IView, IThisAs<TMainView>,
    IMainView, IViewAs<IMainView>)
    DBGrid1: TDBGrid;
    btAbrir: TButton;
    Button1: TButton;
  private
    FViewModel: IMainViewModel;
    FController: IController;
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
    function Update: IView;
  end;

implementation

{$R *.dfm}

function TMainView.Update: IView;
begin
  result := self;
  if assigned(FViewModel) then
    FViewModel.Update(self as IView);
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
