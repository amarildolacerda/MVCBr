{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 13/02/2017 23:07:44                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit AppPageControlView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, AppPageControl.ViewModel.Interf, MVCBr.Controller,
  VCL.Controls, VCL.ComCtrls, MVCBr.PageView, Vcl.StdActns, Vcl.ExtActns,
  AppPageControl.controller.Interf,
  System.Actions, Vcl.ActnList, Vcl.ToolWin, System.ImageList, Vcl.ImgList;

type
  /// Interface para a VIEW
  IAppPageControlView = interface(IView)
    ['{2ABF9018-81E6-4DC6-BCB7-990BA2E6349E}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TAppPageControlView = class(TFormFactory { TFORM } , IView,
    IThisAs<TAppPageControlView>, IAppPageControlView,
    IViewAs<IAppPageControlView>)
    PageControl1: TPageControl;
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    EditDelete1: TEditDelete;
    FileOpen1: TFileOpen;
    FileSaveAs1: TFileSaveAs;
    FileExit1: TFileExit;
    TabPreviousTab1: TPreviousTab;
    TabNextTab1: TNextTab;
    WindowClose1: TWindowClose;
    ToolButton1: TToolButton;
    Action1: TAction;
    ImageList1: TImageList;
    procedure Action1Execute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FViewModel: IAppPageControlViewModel;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ViewModel(const AViewModel: IAppPageControlViewModel): IView;
    function This: TObject; override;
    function ThisAs: TAppPageControlView;
    function ViewAs: IAppPageControlView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

implementation

{$R *.dfm}

uses MVCBr.VCL.PageControl, Editor.Controller.Interf;

function TAppPageControlView.Update: IView;
begin
  result := self;
  if assigned(FViewModel) then
    FViewModel.Update(self as IView);
  { codigo para atualizar a View vai aqui... }
end;

function TAppPageControlView.ViewAs: IAppPageControlView;
begin
  result := self;
end;

class function TAppPageControlView.New(aController: IController): IView;
begin
  result := TAppPageControlView.create(nil);
  result.Controller(aController);
end;

procedure TAppPageControlView.Action1Execute(Sender: TObject);
begin
   (FController as IAppPageControlController).addView(IEditorController);
end;

function TAppPageControlView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not assigned(FViewModel) then
    FViewModel := getViewModel as IAppPageControlViewModel;
end;

procedure TAppPageControlView.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    CanClose := FViewModel.CanClose;
end;

function TAppPageControlView.ViewModel(const AViewModel
  : IAppPageControlViewModel): IView;
begin
  result := self;
  if assigned(AViewModel) then
    FViewModel := AViewModel;
end;

function TAppPageControlView.This: TObject;
begin
  result := inherited This;
end;

function TAppPageControlView.ThisAs: TAppPageControlView;
begin
  result := self;
end;

function TAppPageControlView.ShowView(const AProc: TProc<IView>): integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This, IAppPageControlViewModel, FViewModel);
  end;
  inherited;
end;

end.
