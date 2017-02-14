{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br                                // }
{ //************************************************************// }
{ // Data: 02/02/2017 22:16:23                                                // }
{ //************************************************************// }
unit GrupoView;

// Código gerado pelo assistente     MVCBr OTA
// www.tireideletra.com.br
{ .$I ..\inc\mvcbr.inc }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, StdCtrls, ComCtrls, ExtCtrls, Forms, MVCBr.Interf,
  MVCBr.FormView, Grupo.ViewModel.Interf, MVCBr.Controller, Data.DB, Vcl.Grids,
  TabGrupo.ModuleModel.Interf, Vcl.DBGrids;

type
  IGrupoView = interface(IView)
    ['{1C3144B3-CA1D-4A50-BD6B-E2C5CF3BC80C}']
    // incluir especializacoes aqui
  end;

  TGrupoView = class(TFormFactory { TFORM } , IView, IThisAs<TGrupoView>,
    IGrupoView, IViewAs<IGrupoView>)
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FTabGrupo: ITabGrupoModuleModel;
    FViewModel: IGrupoViewModel;
  protected
    FGrupoSelecionado: string;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ViewModel(const AViewModel: IGrupoViewModel): IView;
    function This: TObject; override;
    function ThisAs: TGrupoView;
    function ViewAs: IGrupoView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

implementation

{$R *.dfm}

uses Usuarios.Controller ;//IUsuariosController

function TGrupoView.Update: IView;
begin
  result := self;
  if assigned(FViewModel) then
    FViewModel.Update(self as IView);
  { codigo para atualizar a View vai aqui... }

  if assigned(FTabGrupo) then
  begin
    FGrupoSelecionado := FTabGrupo.GetGrupoSelecionado;
    Label2.caption := FGrupoSelecionado;
  end;

end;

function TGrupoView.ViewAs: IGrupoView;
begin
  result := self;
end;

procedure TGrupoView.FormShow(Sender: TObject);
begin
  if not assigned(FTabGrupo) then
    FTabGrupo := FController.This.getModel<ITabGrupoModuleModel>;
  if assigned(FTabGrupo) then
    DBGrid1.dataSource := FTabGrupo.getDatasource;
end;

class function TGrupoView.New(aController: IController): IView;
begin
  result := TGrupoView.create(nil);
  result.Controller(aController);
end;

procedure TGrupoView.Button1Click(Sender: TObject);
begin
  if not assigned(FTabGrupo) then
    FTabGrupo := FController.This.getModel<ITabGrupoModuleModel>;

  if assigned(FTabGrupo) then
  begin
    FTabGrupo.ProcurarGrupo(Edit1.text,
      procedure
      Begin
        // FGrupoSelecionado := TabGrupo.GetGrupoSelecionado;
        // Label2.caption := FGrupoSelecionado;
      end);
    // FGrupoSelecionado := TabGrupo.GetGrupoSelecionado;
  end;

end;

procedure TGrupoView.Button2Click(Sender: TObject);
var user:IUsuariosController;
begin
    user := FController.this.ResolveController<IUsuariosController>;
    user.getView.ShowView(nil) ;
    user := nil;
end;

function TGrupoView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
end;

function TGrupoView.ViewModel(const AViewModel: IGrupoViewModel): IView;
begin
  result := self;
  if assigned(AViewModel) then
    FViewModel := AViewModel;
end;

function TGrupoView.This: TObject;
begin
  result := inherited This;
end;

function TGrupoView.ThisAs: TGrupoView;
begin
  result := self;
end;

function TGrupoView.ShowView(const AProc: TProc<IView>): integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This, IGrupoViewModel, FViewModel);
  end;
  ShowModal;
  result := ord(ModalResult);
  if assigned(AProc) then
    AProc(self);
end;

end.
