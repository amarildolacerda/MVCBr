{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/07/2017 23:26:35                                  // }
{ //************************************************************// }

Unit Logs.Model;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model,
  Logs.Model.Interf,
  MVCBr.Patterns.Builder, MVCBr.Controller,
  System.RTTI;

Type

  ILogsModel<T> = interface(TFunc<T>)
    ['{79B2A4DD-AC45-4A43-A701-FDE50CB1F916}']
    property Builder: T read invoke;
    procedure Add(ACommand: TValue; AClass: TMVCBrBuilderObjectClass);
    procedure FreeAllInstances;
    procedure FreeInstance(ACommand: TValue);
  end;

  TLogsModel = class(TModelFactory, ILogsModel, IThisAs<TLogsModel>,
    ILogsModel<TMVCBrBuilderLazyFactory>)
  protected
    FBuilder: TMVCBrBuilderLazyFactory;
    function invoke: TMVCBrBuilderLazyFactory;
    procedure CreateSubClasses; virtual;
  public
    Constructor Create; override;
    Destructor Destroy; override;
    procedure Add(ACommand: TValue; AClass: TMVCBrBuilderObjectClass);
    class function new(): ILogsModel; overload;
    class function new(const AController: IController): ILogsModel; overload;
    function ThisAs: TLogsModel;
    property Builder: TMVCBrBuilderLazyFactory read invoke;
    procedure FreeAllInstances; virtual;
    procedure FreeInstance(ACommand: TValue); virtual;
    // implementaçoes
  end;

Implementation

// uses Builder.Model.Classe1;

/// Add Sub-Classes of Builder

procedure TLogsModel.CreateSubClasses;
begin

  /// Add Sub-Classes here
  // FBuilder.Add('comandoA', TSubClass1Item);
end;

procedure TLogsModel.Add(ACommand: TValue; AClass: TMVCBrBuilderObjectClass);
begin
  FBuilder.Add(ACommand, AClass);
end;

constructor TLogsModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
  /// create Builder
  FBuilder := TMVCBrBuilderLazyFactory.new;

  /// add subclasses
  CreateSubClasses;
end;

destructor TLogsModel.Destroy;
begin
  FBuilder.free;
  inherited;
end;

procedure TLogsModel.FreeAllInstances;
var
  i: integer;
begin
  FBuilder.FreeAllInstances;
end;

procedure TLogsModel.FreeInstance(ACommand: TValue);
begin
  FBuilder.FreeInstance(ACommand);
end;

function TLogsModel.invoke: TMVCBrBuilderLazyFactory;
begin
  result := FBuilder;
end;

function TLogsModel.ThisAs: TLogsModel;
begin
  result := self;
end;

class function TLogsModel.new(): ILogsModel;
begin
  result := new(nil);
end;

class function TLogsModel.new(const AController: IController): ILogsModel;
begin
  result := TLogsModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<ILogsModel, TLogsModel>(TLogsModel.classname, true);

end.
