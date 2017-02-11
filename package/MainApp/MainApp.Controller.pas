{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 11/02/2017 20:42:31                                  // }
{ //************************************************************// }
unit MainApp.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  MainApp.Controller.Interf,
  System.RTTI;

type
  TMainAppController = class(TControllerFactory, IMainAppController,
    IThisAs<TMainAppController> { , IModelAs<IMainAppViewModel> } )
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
    function ThisAs: TMainAppController;
    procedure init; override;
    // function ModelAs: IMainAppViewModel;
  end;

implementation

Constructor TMainAppController.Create;
begin
  inherited;
  // add(TMainAppViewModel.New(self).ID('{MainApp.ViewModel}')); CreateModules; //< criar os modulos persolnizados
end;

Destructor TMainAppController.Destroy;
begin
  inherited;
end;

class function TMainAppController.New(): IController;
begin
  result := New(nil, nil);
end;

class function TMainAppController.New(const AView: IView; const AModel: IModel)
  : IController;
var
  vm: IViewModel;
begin
  result := TMainAppController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TMainAppController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

function TMainAppController.ThisAs: TMainAppController;
begin
  result := self;
end;

{ function TMainAppController.ModelAs: IMainAppViewModel;
  begin
  if count>=0 then
  supports(GetModelByType(mtViewModel), IMainAppViewModel, result);
  end; }
Procedure TMainAppController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

procedure TMainAppController.init;
// var ref:TMainAppView;
begin
  inherited;
  { if not assigned(FView) then
    begin
    Application.CreateForm( TMainAppView, ref );
    supports(ref,IView,FView);
    end; }
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TMainAppController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TMainAppController.New(TMainAppView.New,TMainAppViewModel.New)).init();
RegisterInterfacedClass(TMainAppController.ClassName, IMainAppController,
  TMainAppController);

finalization

unRegisterInterfacedClass(TMainAppController.ClassName);

end.
