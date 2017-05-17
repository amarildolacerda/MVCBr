{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 19/02/2017 08:49:28                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit EditorView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, Editor.ViewModel.Interf, MVCBr.Controller,
  VCL.Controls, VCL.StdCtrls, VCL.ComCtrls;

type
  /// Interface para a VIEW
  IEditorView = interface(IView)
    ['{BEAED3B3-DA48-43E3-A22D-B16CDE2EFBFF}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TEditorView = class(TFormFactory { TFORM } , IView, IThisAs<TEditorView>,
    IEditorView, IViewAs<IEditorView>)
    RichEdit1: TRichEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FViewModel: IEditorViewModel;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ViewModel(const AViewModel: IEditorViewModel): IView;
    function This: TObject; override;
    function ThisAs: TEditorView;
    function ViewAs: IEditorView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
  end;

implementation

{$R *.dfm}

function TEditorView.UpdateView: IView;
begin
  result := self;
  if assigned(FViewModel) then
    FViewModel.UpdateView(self as IView);
  { codigo para atualizar a View vai aqui... }
end;

function TEditorView.ViewAs: IEditorView;
begin
  result := self;
end;

procedure TEditorView.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    CanClose := not FViewModel.IsChanged;
end;

class function TEditorView.New(aController: IController): IView;
begin
  result := TEditorView.create(nil);
  result.Controller(aController);
end;

function TEditorView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not assigned(FViewModel) then
    FViewModel := getViewModel as IEditorViewModel;
end;

function TEditorView.ViewModel(const AViewModel: IEditorViewModel): IView;
begin
  result := self;
  if assigned(AViewModel) then
    FViewModel := AViewModel;
end;

function TEditorView.This: TObject;
begin
  result := inherited This;
end;

function TEditorView.ThisAs: TEditorView;
begin
  result := self;
end;

function TEditorView.ShowView(const AProc: TProc<IView>): integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This, IEditorViewModel, FViewModel);
  end;
  inherited;
end;

end.
