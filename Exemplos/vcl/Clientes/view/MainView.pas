unit MainView;

// Código gerado pelo assistente     MVCBr OTA
// www.tireideletra.com.br
{ .$I ..\inc\mvcbr.inc }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, StdCtrls, ComCtrls, ExtCtrls, Forms, MVCBr.Interf,
  MVCBr.View, Main.ViewModel.Interf, MVCBr.Controller, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Vcl.Menus;

type
  IMainView = interface(IView)
    ['{76EB79AD-A5CB-4D82-8884-C7EE03D822F0}']
    // incluir especializacoes aqui
  end;

  TMainView = class(TFormFactory { TFORM } , IView, IThisAs<TMainView>,
    IMainView, IViewAs<IMainView>)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    DBGrid1: TDBGrid;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    MainMenu1: TMainMenu;
    ProcurarEndereo1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ProcurarEndereo1Click(Sender: TObject);
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

uses Validacoes.Model.Interf, TabClientes.ModuleModel.Interf, ProcurarEnderecos.Controller  ;

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

procedure TMainView.ProcurarEndereo1Click(Sender: TObject);
var ctrlProcEnder:IProcurarEnderecosController;
begin
   // applicationController.Add

   //  onde minha view de procurar cliente.....?
  // Controller.GetExternalController(   );
  ctrlProcEnder := FController.this.ResolveController<IProcurarEnderecosController>();
  if assigned(ctrlProcEnder) then
     ctrlProcEnder.GetView.ShowView(nil);


end;

procedure TMainView.Button1Click(Sender: TObject);
begin
  // qual o MODEL...

  FViewModel.ValidarCPF(Edit1.text);

end;

procedure TMainView.Button2Click(Sender: TObject);
var
  ValdacoesModel: IValidacoesModel;
begin
  ValdacoesModel := FController.This.GetModel<IValidacoesModel>();
  ValdacoesModel.ValidarCEP(Edit1.text);
end;

procedure TMainView.Button3Click(Sender: TObject);
var TabCliente:ITabClientesModuleModel;
begin
    TabCliente := FController.This.GetModel<ITabClientesModuleModel>()  ;
    if Assigned(TabCliente) then
       DBGrid1.DataSource := TabCliente.getdataSource;
end;

procedure TMainView.Button4Click(Sender: TObject);
begin
    FController.UpdateByView(self);
end;

procedure TMainView.Button5Click(Sender: TObject);
var TabCliente:ITabClientesModuleModel;
begin
    TabCliente := FController.This.GetModel<ITabClientesModuleModel>()  ;
    if Assigned(TabCliente) then
       TabCliente.Recarregar(Edit1.text);
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
