PROGRAM DWeb;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  DWeb.Controller in 'DWeb.Controller.pas',
  DWeb.Controller.Interf in 'DWeb.Controller.Interf.pas',
  DWeb.ViewModel.Interf in 'DWeb.ViewModel.Interf.pas',
  DWeb.ViewModel in 'DWeb.ViewModel.pas',
  DWebView in 'DWebView.pas' {DWebView},
  dBowser.Controller.Interf in 'dBowser\dBowser.Controller.Interf.pas',
  dBowser.Controller in 'dBowser\dBowser.Controller.pas',
  dBowserView in 'dBowser\dBowserView.pas' {dBowserView},
  MVCBr.VCL.PageView in '..\..\..\VCL\MVCBr.VCL.PageView.pas',
  wConfig in 'wConfig.pas' {Config};

{$R *.res}
begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TDWebController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
