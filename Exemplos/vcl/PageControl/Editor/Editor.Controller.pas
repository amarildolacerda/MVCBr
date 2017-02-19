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
/// O controller possui as seguintes características:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanciá-los
/// (resolveController<I..>)
/// </summary>
unit Editor.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, Editor.Controller.Interf,
  Editor.ViewModel, Editor.ViewModel.Interf, EditorView;

type
  TEditorController = class(TControllerFactory, IEditorController,
    IThisAs<TEditorController>, IModelAs<IEditorViewModel>)
  protected
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); override;
  public
    // inicializar os módulos personalizados em CreateModules
    Procedure CreateModules; virtual;
    Constructor Create; override;
    Destructor Destroy; override;
    /// New Cria nova instância para o Controller
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel)
      : IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TEditorController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    /// ModeAs retornar a própria interface do controller
    function ModelAs: IEditorViewModel;
  end;

implementation

/// Creator para a classe Controller
Constructor TEditorController.Create;
begin
  inherited;
  /// Inicializar as Views...
  view(TEditorView.New(self));
  add(TEditorViewModel.New(self));
  /// Inicializar os modulos
  CreateModules; // < criar os modulos persolnizados
end;

/// Finaliza o controller
Destructor TEditorController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TEditorController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TEditorController.New(const AView: IView; const AModel: IModel)
  : IController;
var
  vm: IViewModel;
begin
  result := TEditorController.Create as IController;
  result.View(AView).add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TEditorController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TEditorController.ThisAs: TEditorController;
begin
  result := self;
end;

/// Cast para o ViewModel local do controller
function TEditorController.ModelAs: IEditorViewModel;
begin
  if count >= 0 then
    supports(GetModelByType(mtViewModel), IEditorViewModel, result);
end;

/// Executar algum comando customizavel
Procedure TEditorController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TEditorController.init;
var
  ref: TEditorView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TEditorView, ref);
    supports(ref, IView, FView);
{$IFDEF FMX}
    if Application.MainForm = nil then
      Application.RealCreateForms;
{$ENDIF}
  end;
  AfterInit;
end;

/// Adicionar os modulos e MODELs personalizados
Procedure TEditorController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TEditorController.New(TEditorView.New,TEditorViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr

//RegisterInterfacedClass(TEditorController.ClassName, IEditorController,
//  TEditorController,true);


// permitir criar varias instancias do editor;
RegisterInterfacedClass(TEditorController.ClassName, IEditorController,
  TEditorController,false  { permite multiplas instancias} );



finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TEditorController.ClassName);

end.
