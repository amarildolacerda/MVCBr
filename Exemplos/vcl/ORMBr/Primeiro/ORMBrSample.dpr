program ORMBrSample;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  ORMBrSample.Controller in 'Controllers\ORMBrSample.Controller.pas',
  ORMBrSample.Controller.Interf in 'Controllers\ORMBrSample.Controller.Interf.pas',
  ORMBrSampleView in 'Views\ORMBrSampleView.pas' {ORMBrSampleView},
  ORMBr.model.CLIENTES in '..\Modelos\ORMBr.model.CLIENTES.pas',
  ORMBr.model.FORNECEDORES in '..\Modelos\ORMBr.model.FORNECEDORES.pas',
  ORMBr.model.GRUPOS in '..\Modelos\ORMBr.model.GRUPOS.pas',
  ORMBr.model.PRODUTOS in '..\Modelos\ORMBr.model.PRODUTOS.pas',
  ORMBr.model.VENDAS in '..\Modelos\ORMBr.model.VENDAS.pas',
  ORMBr.model.VENDAS_ITEM in '..\Modelos\ORMBr.model.VENDAS_ITEM.pas',
  ORMBrClienteModel in 'Models\ORMBrClienteModel.pas',
  ModelBaseTemplate in 'Models\ModelBaseTemplate.pas';

{$R *.res}
function CheckApplicationAuth: boolean;
begin
  // retornar True se o applicatio pode ser carregado
  //          False se não foi autorizado inicialização
  result := true;
end;

begin
/// Inicializa o Controller e Roda o MainForm
if CheckApplicationAuth then
  ApplicationController.Run(TORMBrSampleController.New);
end.
