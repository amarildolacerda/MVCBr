PROGRAM NewMVCApp;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  System.StartUpCopy,
  FMX.Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  NewMVCApp.Controller in 'NewMVCApp.Controller.pas',
  NewMVCApp.Controller.Interf in 'NewMVCApp.Controller.Interf.pas',
  NewMVCApp.ViewModel.Interf in 'NewMVCApp.ViewModel.Interf.pas',
  NewMVCApp.ViewModel in 'NewMVCApp.ViewModel.pas',
  NewMVCAppView in 'NewMVCAppView.pas' {NewMVCAppView},
  Config.Controller.Interf in 'Config\Config.Controller.Interf.pas',
  Config.Controller in 'Config\Config.Controller.pas',
  ConfigView in 'Config\ConfigView.pas' {ConfigView},
  Config.ViewModel in 'Config\Config.ViewModel.pas',
  Config.ViewModel.Interf in 'Config\Config.ViewModel.Interf.pas';

{$R *.res}
begin
  ApplicationController.Run(TNewMVCAppController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
