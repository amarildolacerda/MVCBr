{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/07/2017 14:48:21                                  // }
{ //************************************************************// }

Unit Estacao.Builder;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model, MVCBr.BuilderModel,
  Estacao.Builder.Interf,
  MVCBr.Patterns.Builder, MVCBr.Controller,
  System.RTTI;

Type

  TEstacaoCommands = record
  const
    cmd_default = 'default';
  end;

  TEstacaoBuilder = class(TBuilderModelFactory, IEstacaoBuilder,
    IThisAs<TEstacaoBuilder>)
  protected
    procedure CreateSubClasses; override;
  public
    class function new(): IEstacaoBuilder; overload;
    class function new(const AController: IController)
      : IEstacaoBuilder; overload;
    function ThisAs: TEstacaoBuilder;
    // implementaçoes
  end;

Implementation

// uses Builder.Model.Classe1;

/// Add Sub-Classes of Builder

procedure TEstacaoBuilder.CreateSubClasses;
begin
  /// Add Sub-Classes here
  // FBuilder.Add(TEstacaoCommands.cmd_default, TEstacaoBuiltFactory);
end;

function TEstacaoBuilder.ThisAs: TEstacaoBuilder;
begin
  result := self;
end;

class function TEstacaoBuilder.new(): IEstacaoBuilder;
begin
  result := new(nil);
end;

class function TEstacaoBuilder.new(const AController: IController)
  : IEstacaoBuilder;
begin
  result := TEstacaoBuilder.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<IEstacaoBuilder, TEstacaoBuilder>
  (TEstacaoBuilder.classname, true);

end.
