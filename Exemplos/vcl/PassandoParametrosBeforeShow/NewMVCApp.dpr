program NewMVCApp;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  NewMVCApp.Controller in 'Controllers\NewMVCApp.Controller.pas',
  NewMVCApp.Controller.Interf in 'Controllers\NewMVCApp.Controller.Interf.pas',
  NewMVCApp.ViewModel.Interf in 'Models\NewMVCApp.ViewModel.Interf.pas',
  NewMVCApp.ViewModel in 'ViewModels\NewMVCApp.ViewModel.pas',
  NewMVCAppView in 'Views\NewMVCAppView.pas' {NewMVCAppView},
  SegundaView.Controller.Interf in 'Controllers\SegundaView.Controller.Interf.pas',
  SegundaView.Controller in 'Controllers\SegundaView.Controller.pas',
  SegundaViewView in 'Views\SegundaViewView.pas' {SegundaViewView};

{$R *.res}
begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TNewMVCAppController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
