program BuilderLazy;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  BuilderLazy.Controller in 'Controllers\BuilderLazy.Controller.pas',
  builder.Model in 'Models\builder.Model.pas',
  builder.Model.Interf in 'Models\builder.Model.Interf.pas',
  BuilderLazy.Controller.Interf in 'Controllers\BuilderLazy.Controller.Interf.pas',
  BuilderLazyView in 'Views\BuilderLazyView.pas' {BuilderLazyView},
  Builder.Model.Classe1 in 'Models\Builder.Model.Classe1.pas',
  FormulasCustos.Builder in 'Builders\FormulasCustos.Builder.pas',
  FormulasCustos.Builder.Interf in 'Builders\FormulasCustos.Builder.Interf.pas',
  formulasCustos.MargemComercial.Built in 'Builders\formulasCustos.MargemComercial.Built.pas',
  formulasCustos.MargemComercial.Built.Interf in 'Builders\formulasCustos.MargemComercial.Built.Interf.pas';

begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TBuilderLazyController.New);
end.
