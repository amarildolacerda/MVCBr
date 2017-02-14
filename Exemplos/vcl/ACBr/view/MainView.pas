unit MainView;

// Código gerado pelo assistente     MVCBr OTA
// www.tireideletra.com.br
{ .$I ..\inc\mvcbr.inc }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, StdCtrls, ComCtrls, ExtCtrls, Forms, MVCBr.Interf,
  MVCBr.FormView, Main.ViewModel.Interf, MVCBr.Controller;

type
  IMainView = interface(IView)
    ['{0A6B1F59-A0BD-4E27-BC3F-109AE712EBBF}']
    // incluir especializacoes aqui
  end;

  TMainView = class(TFormFactory { TFORM } , IView, IThisAs<TMainView>,
    IMainView, IViewAs<IMainView>)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
    function Update: IView;
  end;

implementation

{$R *.dfm}

uses Dialogs, ACBrUtils.Model.Interf, ACBrValidador.Model.Interf;

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

procedure TMainView.Button1Click(Sender: TObject);
var
  Model: IACBrUtilsModel;
begin

  // exemplo utilizando o Controller para pegar qual o MODEL que faz o tipo de validação
  Model := FController.This.GetModel<IACBrUtilsModel>(); // < procura o ´MODEL
  if Model.EAN13Valido(Edit1.text) then
    showmessage('EAN é válido')
  else
    showmessage('Não é um código EAN');

end;

procedure TMainView.Button2Click(Sender: TObject);
var
   msg:String;
begin
  msg := FController.This.GetModel<IACBrValidadorModel>()
    .ValidarCNPJouCPF(Edit1.text);
  if msg='' then
    showmessage('Número OK')
  else
    showmessage('Inválido: '+msg);
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
