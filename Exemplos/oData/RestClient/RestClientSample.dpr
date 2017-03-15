PROGRAM RestClientSample;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  RestClientSample.Controller in 'RestClientSample.Controller.pas',
  RestClientSample.Controller.Interf in 'RestClientSample.Controller.Interf.pas',
  RestClientSample.ViewModel.Interf in 'RestClientSample.ViewModel.Interf.pas',
  RestClientSample.ViewModel in 'RestClientSample.ViewModel.pas',
  RestClientSampleView in 'RestClientSampleView.pas' {RestClientSampleView};

{$R *.res}
begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TRestClientSampleController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
