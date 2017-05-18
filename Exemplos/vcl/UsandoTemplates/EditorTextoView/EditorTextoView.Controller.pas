{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/05/2017 23:41:17                                  // }
{ //************************************************************// }
unit EditorTextoView.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE}{$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF} System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  EditorTextoView.Controller.Interf,
  EditorTexto.view,
  System.RTTI;

type

  TEditorTextoViewController = class(TControllerFactory,
    IEditorTextoViewController,
    IThisAs<TEditorTextoViewController> { , IModelAs<IEditorTextoViewViewModel> } )
  protected
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); override;
  public
    // inicializar os módulos personalizados em CreateModules
    Procedure CreateModules; virtual;
    Constructor Create; override;
    Destructor Destroy; override;
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel)
      : IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TEditorTextoViewController;
    procedure init; override;
    // function ModelAs: IEditorTextoViewViewModel;
  end;

implementation

Constructor TEditorTextoViewController.Create;
begin
  inherited;
  // add(TEditorTextoViewViewModel.New(self).ID('{EditorTextoView.ViewModel}')); CreateModules; //< criar os modulos persolnizados
end;

Destructor TEditorTextoViewController.Destroy;
begin
  inherited;
end;

class function TEditorTextoViewController.New(): IController;
begin
  result := New(nil, nil);
end;

class function TEditorTextoViewController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TEditorTextoViewController.Create as IController;
  result.view(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.view(AView).Controller(result);
    end;
end;

class function TEditorTextoViewController.New(const AModel: IModel)
  : IController;
begin
  result := New(nil, AModel);
end;

function TEditorTextoViewController.ThisAs: TEditorTextoViewController;
begin
  result := self;
end;

{ function TEditorTextoViewController.ModelAs: IEditorTextoViewViewModel;
  begin
  if count>=0 then
  supports(GetModelByType(mtViewModel), IEditorTextoViewViewModel, result);
  end; }
Procedure TEditorTextoViewController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

procedure TEditorTextoViewController.init;
var
  ref: TEditorTextoView;
begin
  inherited;
  // inicializa a VIEW
  if not assigned(FView) then
  begin
    Application.CreateForm(TEditorTextoView, ref);
    supports(ref, IView, FView);
  end;
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TEditorTextoViewController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TEditorTextoViewController.New(TEditorTextoViewView.New,TEditorTextoViewViewModel.New)).init();
RegisterInterfacedClass(TEditorTextoViewController.ClassName,
  IEditorTextoViewController, TEditorTextoViewController);

finalization

unRegisterInterfacedClass(TEditorTextoViewController.ClassName);

end.
