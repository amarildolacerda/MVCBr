{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 11/08/2017 09:15:48                                  // }
{ //************************************************************// }

Unit FormulasCustos.Builder;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model, MVCBr.BuilderModel,
  FormulasCustos.Builder.Interf,
  MVCBr.Patterns.Builder, MVCBr.Controller,
  System.RTTI;

Type

  TFormulasCustosBuilderModel = class(TBuilderModelFactory,
    IFormulasCustosBuilderModel, IThisAs<TFormulasCustosBuilderModel>)
  protected
    procedure CreateSubClasses; override;
  public
    class function new(): IFormulasCustosBuilderModel; overload;
    class function new(const AController: IController)
      : IFormulasCustosBuilderModel; overload;
    function ThisAs: TFormulasCustosBuilderModel;
    // implementaçoes
  end;

Implementation

// uses Builder.Model.Classe1;

uses  FormulasCustos.MargemComercial.Built.Interf,
  FormulasCustos.MargemComercial.Built;
/// Add Sub-Classes of Builder

procedure TFormulasCustosBuilderModel.CreateSubClasses;
begin
  /// Add Sub-Classes here
  // FBuilder.Add(TFormulasCustosModelCommands.cmd_default, TFormulasCustosBuilt);

  Lazy.add(TFormulasCustosModelCommands.cmd_margem_comercial, TformulasCustosMargemComercialBuilt);

end;

function TFormulasCustosBuilderModel.ThisAs: TFormulasCustosBuilderModel;
begin
  result := self;
end;

class function TFormulasCustosBuilderModel.new(): IFormulasCustosBuilderModel;
begin
  result := new(nil);
end;

class function TFormulasCustosBuilderModel.new(const AController: IController)
  : IFormulasCustosBuilderModel;
begin
  result := TFormulasCustosBuilderModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<IFormulasCustosBuilderModel,
  TFormulasCustosBuilderModel>(TFormulasCustosBuilderModel.classname, true);

end.
