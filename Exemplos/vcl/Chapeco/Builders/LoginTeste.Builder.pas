{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/07/2017 16:34:37                                  // }
{ //************************************************************// }

Unit LoginTeste.Builder;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model, MVCBr.BuilderModel,
  LoginTeste.Builder.Interf,
  MVCBr.Patterns.Builder, MVCBr.Controller,
  System.RTTI;

Type

  TLoginTesteModelCommands = record
  const
    cmd_default = 'default';
  end;

  TLoginTesteBuilderModel = class(TBuilderModelFactory, ILoginTesteBuilderModel,
    IThisAs<TLoginTesteBuilderModel>)
  protected
    procedure CreateSubClasses; override;
  public
    class function new(): ILoginTesteBuilderModel; overload;
    class function new(const AController: IController)
      : ILoginTesteBuilderModel; overload;
    function ThisAs: TLoginTesteBuilderModel;
    // implementaçoes
  end;

Implementation

// uses Builder.Model.Classe1;

/// Add Sub-Classes of Builder

procedure TLoginTesteBuilderModel.CreateSubClasses;
begin
  /// Add Sub-Classes here
  // FBuilder.Add(TLoginTesteCommands.cmd_default, TLoginTesteBuilt);
end;

function TLoginTesteBuilderModel.ThisAs: TLoginTesteBuilderModel;
begin
  result := self;
end;

class function TLoginTesteBuilderModel.new(): ILoginTesteBuilderModel;
begin
  result := new(nil);
end;

class function TLoginTesteBuilderModel.new(const AController: IController)
  : ILoginTesteBuilderModel;
begin
  result := TLoginTesteBuilderModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<ILoginTesteBuilderModel, TLoginTesteBuilderModel>
  (TLoginTesteBuilderModel.classname, true);

end.
