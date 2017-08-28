program ORMBrSample;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  ORMBrSample.Controller in '..\Controllers\ORMBrSample.Controller.pas',
  ORMBrSample.Controller.Interf in '..\Controllers\ORMBrSample.Controller.Interf.pas',
  ORMBrSampleView in '..\Views\ORMBrSampleView.pas' {ORMBrSampleView},
  MVCBr.model.CLIENTES in '..\..\Modelos\MVCBr.model.CLIENTES.pas',
  MVCBr.model.FORNECEDORES in '..\..\Modelos\MVCBr.model.FORNECEDORES.pas',
  MVCBr.model.GRUPOS in '..\..\Modelos\MVCBr.model.GRUPOS.pas',
  MVCBr.model.PRODUTOS in '..\..\Modelos\MVCBr.model.PRODUTOS.pas',
  MVCBr.model.VENDAS in '..\..\Modelos\MVCBr.model.VENDAS.pas',
  MVCBr.model.VENDAS_ITEM in '..\..\Modelos\MVCBr.model.VENDAS_ITEM.pas',
  ORMBrClienteModel in 'ORMBrClienteModel.pas';

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
