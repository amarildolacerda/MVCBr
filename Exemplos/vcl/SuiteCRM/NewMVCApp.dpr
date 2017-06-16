program NewMVCApp;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  SuiteCRMSampleView in 'Views\SuiteCRMSampleView.pas' {SugarCRMSampleView},
  SuiteCRMSample.ViewModel in 'ViewModels\SuiteCRMSample.ViewModel.pas',
  SuiteCRMSample.ViewModel.Interf in 'Models\SuiteCRMSample.ViewModel.Interf.pas',
  SuiteCRMSample.Controller.Interf in 'Controllers\SuiteCRMSample.Controller.Interf.pas',
  SuiteCRMSample.Controller in 'Controllers\SuiteCRMSample.Controller.pas',
  SugarCRM.Model.Interf in '..\..\..\3Models\SuiteCRM\SugarCRM.Model.Interf.pas',
  SuiteCRM.Model in '..\..\..\3Models\SuiteCRM\SuiteCRM.Model.pas';

{$R *.res}
begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TSuiteCRMSampleController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
