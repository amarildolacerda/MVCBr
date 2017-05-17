{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/05/2017 14:05:02                                  // }
{ //************************************************************// }
unit DJsonView.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE}{$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF} System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  DJsonView.Controller.Interf,
  System.RTTI;

type
  TDJsonViewController = class(TControllerFactory, IDJsonViewController,
    IThisAs<TDJsonViewController> { , IModelAs<IDJsonViewViewModel> } )
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
    function ThisAs: TDJsonViewController;
    procedure init; override;
    // function ModelAs: IDJsonViewViewModel;
  end;

implementation

uses uFormJsonViewer;

Constructor TDJsonViewController.Create;
begin
  inherited;
  Application.Initialize;
  Application.CreateForm(TFormJsonViewer, FormJsonViewer);
  // add(TDJsonViewViewModel.New(self).ID('{DJsonView.ViewModel}')); CreateModules; //< criar os modulos persolnizados
end;

Destructor TDJsonViewController.Destroy;
begin
  inherited;
end;

class function TDJsonViewController.New(): IController;
begin
  result := New(FormJsonViewer, nil);
end;

class function TDJsonViewController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TDJsonViewController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TDJsonViewController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

function TDJsonViewController.ThisAs: TDJsonViewController;
begin
  result := self;
end;

{ function TDJsonViewController.ModelAs: IDJsonViewViewModel;
  begin
  if count>=0 then
  supports(GetModelByType(mtViewModel), IDJsonViewViewModel, result);
  end; }
Procedure TDJsonViewController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

procedure TDJsonViewController.init;
// var ref:TDJsonViewView;
begin
  inherited;
  { if not assigned(FView) then
    begin
    Application.CreateForm( TDJsonViewView, ref );
    supports(ref,IView,FView);
    end; }
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TDJsonViewController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TDJsonViewController.New(TDJsonViewView.New,TDJsonViewViewModel.New)).init();
RegisterInterfacedClass(TDJsonViewController.ClassName, IDJsonViewController,
  TDJsonViewController);

finalization

unRegisterInterfacedClass(TDJsonViewController.ClassName);

end.
