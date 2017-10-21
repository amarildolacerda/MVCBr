program FireDACMultiThread;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  FireDACMultiThread.Controller in 'Controllers\FireDACMultiThread.Controller.pas',
  FireDACMultiThread.Controller.Interf in 'Controllers\FireDACMultiThread.Controller.Interf.pas',
  FireDACMultiThreadView in 'Views\FireDACMultiThreadView.pas' {FireDACMultiThreadView},
  Data.FireDAC.Helper in '..\..\..\helpers\Data.FireDAC.Helper.pas';

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
  ApplicationController.Run(TFireDACMultiThreadController.New);
end.
