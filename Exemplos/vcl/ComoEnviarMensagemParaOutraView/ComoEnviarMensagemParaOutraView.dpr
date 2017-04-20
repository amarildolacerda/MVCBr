program ComoEnviarMensagemParaOutraView;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  ComoEnviarMensagemParaOutraView.Controller in 'Controllers\ComoEnviarMensagemParaOutraView.Controller.pas',
  ComoEnviarMensagemParaOutraView.Controller.Interf in 'Controllers\ComoEnviarMensagemParaOutraView.Controller.Interf.pas',
  ComoEnviarMensagemParaOutraView.ViewModel.Interf in 'Models\ComoEnviarMensagemParaOutraView.ViewModel.Interf.pas',
  ComoEnviarMensagemParaOutraView.ViewModel in 'ViewModels\ComoEnviarMensagemParaOutraView.ViewModel.pas',
  ComoEnviarMensagemParaOutraViewView in 'Views\ComoEnviarMensagemParaOutraViewView.pas' {ComoEnviarMensagemParaOutraViewView},
  Filha.Controller.Interf in 'Controllers\Filha.Controller.Interf.pas',
  Filha.Controller in 'Controllers\Filha.Controller.pas',
  FilhaView in 'Views\FilhaView.pas' {FilhaView};

{$R *.res}
begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TComoEnviarMensagemParaOutraViewController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
