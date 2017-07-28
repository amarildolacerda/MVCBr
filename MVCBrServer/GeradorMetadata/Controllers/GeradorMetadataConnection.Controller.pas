{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 23/05/2017 22:40:48                                  // }
{ //************************************************************// }
unit GeradorMetadataConnection.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE}{$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF} System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  GeradorMetadataConnection.Controller.Interf,
  System.RTTI;

type
  TGeradorMetadataConnectionController = class(TControllerFactory,
    IGeradorMetadataConnectionController,
    IThisAs<TGeradorMetadataConnectionController> { , IModelAs<IGeradorMetadataConnectionViewModel> } )
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
    function ThisAs: TGeradorMetadataConnectionController;
    procedure init; override;
    // function ModelAs: IGeradorMetadataConnectionViewModel;
  end;

implementation

uses Frm_Connection;

Constructor TGeradorMetadataConnectionController.Create;
var form:TFrmConnection;
begin
  inherited;
  application.CreateForm(TFrmConnection,form);
  view( form );
  // add(TGeradorMetadataConnectionViewModel.New(self).ID('{GeradorMetadataConnection.ViewModel}')); CreateModules; //< criar os modulos persolnizados
end;

Destructor TGeradorMetadataConnectionController.Destroy;
begin
  inherited;
end;

class function TGeradorMetadataConnectionController.New(): IController;
begin
  result := New(nil, nil);
end;

class function TGeradorMetadataConnectionController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TGeradorMetadataConnectionController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TGeradorMetadataConnectionController.New(const AModel: IModel)
  : IController;
begin
  result := New(nil, AModel);
end;

function TGeradorMetadataConnectionController.ThisAs
  : TGeradorMetadataConnectionController;
begin
  result := self;
end;

{ function TGeradorMetadataConnectionController.ModelAs: IGeradorMetadataConnectionViewModel;
  begin
  if count>=0 then
  supports(GetModelByType(mtViewModel), IGeradorMetadataConnectionViewModel, result);
  end; }
Procedure TGeradorMetadataConnectionController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

procedure TGeradorMetadataConnectionController.init;
// var ref:TGeradorMetadataConnectionView;
begin
  inherited;
  { if not assigned(FView) then
    begin
    Application.CreateForm( TGeradorMetadataConnectionView, ref );
    supports(ref,IView,FView);
    end; }
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TGeradorMetadataConnectionController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TGeradorMetadataConnectionController.New(TGeradorMetadataConnectionView.New,TGeradorMetadataConnectionViewModel.New)).init();
RegisterInterfacedClass(TGeradorMetadataConnectionController.ClassName,
  IGeradorMetadataConnectionController, TGeradorMetadataConnectionController);

finalization

unRegisterInterfacedClass(TGeradorMetadataConnectionController.ClassName);

end.
