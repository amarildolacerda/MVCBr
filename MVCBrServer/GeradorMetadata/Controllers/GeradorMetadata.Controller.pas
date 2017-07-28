{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 23/05/2017 22:22:46                                  // }
{ //************************************************************// }
unit GeradorMetadata.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE}{$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF} System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  GeradorMetadata.Controller.Interf,
  System.RTTI;

type
  TGeradorMetadataController = class(TControllerFactory,
    IGeradorMetadataController,
    IThisAs<TGeradorMetadataController> { , IModelAs<IGeradorMetadataViewModel> } )
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
    function ThisAs: TGeradorMetadataController;
    procedure init; override;
    // function ModelAs: IGeradorMetadataViewModel;

    procedure CDS_CNN_cancel;
    procedure CDS_CNN_Post;

  end;

implementation

uses Frm_Principal;

procedure TGeradorMetadataController.CDS_CNN_cancel;
begin
  (GetView as IFrmPrincipal).Cancel;
end;

procedure TGeradorMetadataController.CDS_CNN_Post;
begin
  (GetView as IFrmPrincipal).Post;
end;

Constructor TGeradorMetadataController.Create;
begin
  inherited;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  View(FrmPrincipal);
  // add(TGeradorMetadataViewModel.New(self).ID('{GeradorMetadata.ViewModel}')); CreateModules; //< criar os modulos persolnizados
end;

Destructor TGeradorMetadataController.Destroy;
begin
  inherited;
end;

class function TGeradorMetadataController.New(): IController;
begin
  result := New(nil, nil);
end;

class function TGeradorMetadataController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TGeradorMetadataController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TGeradorMetadataController.New(const AModel: IModel)
  : IController;
begin
  result := New(nil, AModel);
end;

function TGeradorMetadataController.ThisAs: TGeradorMetadataController;
begin
  result := self;
end;

{ function TGeradorMetadataController.ModelAs: IGeradorMetadataViewModel;
  begin
  if count>=0 then
  supports(GetModelByType(mtViewModel), IGeradorMetadataViewModel, result);
  end; }
Procedure TGeradorMetadataController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

procedure TGeradorMetadataController.init;
// var ref:TGeradorMetadataView;
begin
  inherited;
  { if not assigned(FView) then
    begin
    Application.CreateForm( TGeradorMetadataView, ref );
    supports(ref,IView,FView);
    end; }
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TGeradorMetadataController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TGeradorMetadataController.New(TGeradorMetadataView.New,TGeradorMetadataViewModel.New)).init();
RegisterInterfacedClass(TGeradorMetadataController.ClassName,
  IGeradorMetadataController, TGeradorMetadataController);

finalization

unRegisterInterfacedClass(TGeradorMetadataController.ClassName);

end.
