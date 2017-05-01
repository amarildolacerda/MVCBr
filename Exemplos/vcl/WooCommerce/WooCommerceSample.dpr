program WooCommerceSample;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  {$ifdef DEBUG}
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  {$endif }
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  WooCommerceSample.Controller in 'Controllers\WooCommerceSample.Controller.pas',
  WooCommerceSample.Controller.Interf in 'Controllers\WooCommerceSample.Controller.Interf.pas',
  WooCommerceSample.ViewModel.Interf in 'Models\WooCommerceSample.ViewModel.Interf.pas',
  WooCommerceSample.ViewModel in 'ViewModels\WooCommerceSample.ViewModel.pas',
  WooCommerceSampleView in 'Views\WooCommerceSampleView.pas' {WooCommerceSampleView},
  WooCommerce.Model in '..\..\..\3Models\WooCommerce\WooCommerce.Model.pas',
  WooCommerce.Model.Interf in '..\..\..\3Models\WooCommerce\WooCommerce.Model.Interf.pas',
  Rest.OAuth in '..\..\..\3Models\Rest.OAuth.pas';

{$R *.res}
begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TWooCommerceSampleController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
