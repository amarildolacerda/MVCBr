PROGRAM NewMVCApp;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  NewMVCApp.Controller in 'C:\lixo\NewMVCApp.Controller.pas',
  NewMVCApp.Controller.Interf in 'C:\lixo\NewMVCApp.Controller.Interf.pas',
  NewMVCApp.ViewModel.Interf in 'C:\lixo\NewMVCApp.ViewModel.Interf.pas',
  NewMVCApp.ViewModel in 'C:\lixo\NewMVCApp.ViewModel.pas',
  NewMVCAppView in 'C:\lixo\NewMVCAppView.pas' {NewMVCAppView},
  uClasseStub in 'C:\lixo\uClasseStub.pas',
  ClasseStub.Model in 'ClasseStub.Model.pas',
  ClasseStub.Model.Interf in 'ClasseStub.Model.Interf.pas';

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
