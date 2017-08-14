{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/07/2017 23:07:45                                  // }
{ //************************************************************// }

Unit Builder.Model;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model,
  Builder.Model.Interf,
  MVCBr.Patterns.Builder, MVCBr.Controller,
  System.RTTI;

Type

  IBuilderModel<T> = interface(TFunc<T>)
    ['{7490F467-65F0-4B66-813F-EFEA95B8FD0B}']
    property Builder: T read invoke;
  end;

  TBuilderModel = class(TModelFactory, IBuilderModel, IThisAs<TBuilderModel>,
    IBuilderModel<TMVCBrBuilderLazyFactory>)
  protected
    FBuilder: TMVCBrBuilderLazyFactory;
    function invoke: TMVCBrBuilderLazyFactory;
    procedure CreateSubClasses; virtual;
  public
    Constructor Create; override;
    Destructor Destroy; override;
    procedure Add(ACommand: TValue; AClass: TMVCBrBuilderObjectClass);
    class function new(): IBuilderModel; overload;
    class function new(const AController: IController): IBuilderModel; overload;
    function ThisAs: TBuilderModel;
    property Builder: TMVCBrBuilderLazyFactory read invoke;
    procedure FreeAllInstances; virtual;
    procedure FreeInstance(ACommand: TValue); virtual;
    // implementaçoes
  end;

Implementation

// uses Builder.Model.Classe1;

/// Add Sub-Classes of Builder

procedure TBuilderModel.CreateSubClasses;
begin

  /// Add Sub-Classes here
  // FBuilder.Add('comandoA', TSubClass1Item);
end;

procedure TBuilderModel.Add(ACommand: TValue; AClass: TMVCBrBuilderObjectClass);
begin
  FBuilder.Add(ACommand, AClass);
end;

constructor TBuilderModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
  /// create Builder
  FBuilder := TMVCBrBuilderLazyFactory.new;

  /// add subclasses
  CreateSubClasses;
end;

destructor TBuilderModel.Destroy;
begin
  FBuilder.free;
  inherited;
end;

procedure TBuilderModel.FreeAllInstances;
var
  i: integer;
begin
  FBuilder.FreeAllInstances;
end;

procedure TBuilderModel.FreeInstance(ACommand: TValue);
begin
  FBuilder.FreeInstance(ACommand);
end;

function TBuilderModel.invoke: TMVCBrBuilderLazyFactory;
begin
  result := FBuilder;
end;

function TBuilderModel.ThisAs: TBuilderModel;
begin
  result := self;
end;

class function TBuilderModel.new(): IBuilderModel;
begin
  result := new(nil);
end;

class function TBuilderModel.new(const AController: IController): IBuilderModel;
begin
  result := TBuilderModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<IBuilderModel, TBuilderModel>
  (TBuilderModel.classname, true);

end.
