PROGRAM FormChildSample;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  FormChildSample.Controller in 'Controllers\FormChildSample.Controller.pas',
  FormChildSample.Controller.Interf in 'Controllers\FormChildSample.Controller.Interf.pas',
  FormChildSample.ViewModel.Interf in 'Models\FormChildSample.ViewModel.Interf.pas',
  FormChildSample.ViewModel in 'FormChildSample.ViewModel.pas',
  FormChildSampleView in 'Views\FormChildSampleView.pas' {FormChildSampleView},
  FormChild.Controller.Interf in 'Controllers\FormChild.Controller.Interf.pas',
  FormChild.Controller in 'Controllers\FormChild.Controller.pas',
  FormChildView in 'Views\FormChildView.pas' {FormChildView},
  RegrasNegocios.Model in 'Models\RegrasNegocios.Model.pas',
  RegrasNegocios.Model.Interf in 'Models\RegrasNegocios.Model.Interf.pas',
  embededForm.Controller.Interf in 'Controllers\embededForm.Controller.Interf.pas',
  embededForm.Controller in 'Controllers\embededForm.Controller.pas',
  embededFormView in 'Views\embededFormView.pas' {embededFormView};

{$R *.res}
begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TFormChildSampleController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
