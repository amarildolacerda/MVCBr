program EvolucaoPopulacional;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  System.StartUpCopy,
  FMX.Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  EvolucaoPopulacional.Controller in 'Controllers\EvolucaoPopulacional.Controller.pas',
  EvolucaoPopulacional.Controller.Interf in 'Controllers\EvolucaoPopulacional.Controller.Interf.pas',
  EvolucaoPopulacionalView in 'Views\EvolucaoPopulacionalView.pas' {EvolucaoPopulacionalView},
  Dados.Model in 'Models\Dados.Model.pas',
  Dados.Model.Interf in 'Models\Dados.Model.Interf.pas',
  WinNotification.Model in '..\..\AdIN\Windows\WinNotification.Model.pas',
  WinNotification.Model.Interf in '..\..\AdIN\Windows\WinNotification.Model.Interf.pas';

{$R *.res}
function CheckApplicationAuth: boolean;
begin
  // retornar True se o applicatio pode ser carregado
  //          False se não foi autorizado inicialização
  result := true;
end;

begin
if CheckApplicationAuth then
  ApplicationController.Run(TEvolucaoPopulacionalController.New);
end.
