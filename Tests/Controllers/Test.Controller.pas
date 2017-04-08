{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 08/04/2017 10:34:47                                  // }
{ //************************************************************// }
unit Test.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  Test.Controller.Interf,
  System.RTTI;

type
  TTestController = class(TControllerFactory, ITestController,
    IThisAs<TTestController> { , IModelAs<ITestViewModel> } )
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
    function ThisAs: TTestController;
    procedure init; override;
    // function ModelAs: ITestViewModel;

    function GetStubInt:Integer;

  end;

implementation

Constructor TTestController.Create;
begin
  inherited;
  // add(TTestViewModel.New(self).ID('{Test.ViewModel}')); CreateModules; //< criar os modulos persolnizados
end;

Destructor TTestController.Destroy;
begin
  inherited;
end;

class function TTestController.New(): IController;
begin
  result := New(nil, nil);
end;

class function TTestController.New(const AView: IView; const AModel: IModel)
  : IController;
var
  vm: IViewModel;
begin
  result := TTestController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TTestController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

function TTestController.ThisAs: TTestController;
begin
  result := self;
end;

{ function TTestController.ModelAs: ITestViewModel;
  begin
  if count>=0 then
  supports(GetModelByType(mtViewModel), ITestViewModel, result);
  end; }
Procedure TTestController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

function TTestController.GetStubInt: Integer;
begin
   result := 1;
end;

procedure TTestController.init;
// var ref:TTestView;
begin
  inherited;
  { if not assigned(FView) then
    begin
    Application.CreateForm( TTestView, ref );
    supports(ref,IView,FView);
    end; }
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TTestController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TTestController.New(TTestView.New,TTestViewModel.New)).init();
RegisterInterfacedClass(TTestController.ClassName, ITestController,
  TTestController);

finalization

unRegisterInterfacedClass(TTestController.ClassName);

end.
