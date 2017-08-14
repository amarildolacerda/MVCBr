{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/07/2017 23:18:54                                  // }
{ //************************************************************// }

Unit login.Model;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model,
  Login.Model.Interf,
  MVCBr.Patterns.Builder, MVCBr.Controller,
  System.RTTI;

Type

  IloginModel<T> = interface(TFunc<T>)
    ['{7EDF2699-53DB-4EAF-AFC8-BC9687818504}']
    property Builder: T read invoke;
  end;

  TloginModel = class(TModelFactory, IloginModel, IThisAs<TloginModel>,
    IloginModel<TMVCBrBuilderLazyFactory>)
  protected
    FBuilder: TMVCBrBuilderLazyFactory;
    function invoke: TMVCBrBuilderLazyFactory;
    procedure CreateSubClasses; virtual;
  public
    Constructor Create; override;
    Destructor Destroy; override;
    procedure Add(ACommand: TValue; AClass: TMVCBrBuilderObjectClass);
    class function new(): IloginModel; overload;
    class function new(const AController: IController): IloginModel; overload;
    function ThisAs: TloginModel;
    property Builder: TMVCBrBuilderLazyFactory read invoke;
    procedure FreeAllInstances; virtual;
    procedure FreeInstance(ACommand: TValue); virtual;
    // implementaçoes
  end;

Implementation

// uses Builder.Model.Classe1;

/// Add Sub-Classes of Builder

procedure TloginModel.CreateSubClasses;
begin

  /// Add Sub-Classes here
  // FBuilder.Add('comandoA', TSubClass1Item);
end;

procedure TloginModel.Add(ACommand: TValue; AClass: TMVCBrBuilderObjectClass);
begin
  FBuilder.Add(ACommand, AClass);
end;

constructor TloginModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
  /// create Builder
  FBuilder := TMVCBrBuilderLazyFactory.new;

  /// add subclasses
  CreateSubClasses;
end;

destructor TloginModel.Destroy;
begin
  FBuilder.free;
  inherited;
end;

procedure TloginModel.FreeAllInstances;
var
  i: integer;
begin
  FBuilder.FreeAllInstances;
end;

procedure TloginModel.FreeInstance(ACommand: TValue);
begin
  FBuilder.FreeInstance(ACommand);
end;

function TloginModel.invoke: TMVCBrBuilderLazyFactory;
begin
  result := FBuilder;
end;

function TloginModel.ThisAs: TloginModel;
begin
  result := self;
end;

class function TloginModel.new(): IloginModel;
begin
  result := new(nil);
end;

class function TloginModel.new(const AController: IController): IloginModel;
begin
  result := TloginModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<IloginModel, TloginModel>
  (TloginModel.classname, true);

end.
