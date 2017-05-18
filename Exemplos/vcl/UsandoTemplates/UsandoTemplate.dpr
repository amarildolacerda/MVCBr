program UsandoTemplate;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  UsandoTemplate.Controller in 'UsandoTemplate.Controller.pas',
  UsandoTemplate.Controller.Interf in 'UsandoTemplate.Controller.Interf.pas',
  UsandoTemplate.ViewModel.Interf in 'UsandoTemplate.ViewModel.Interf.pas',
  UsandoTemplate.ViewModel in 'UsandoTemplate.ViewModel.pas',
  UsandoTemplateView in 'UsandoTemplateView.pas' {UsandoTemplateView},
  ViewTemplate.Controller.Interf in 'ViewTemplate\ViewTemplate.Controller.Interf.pas',
  ViewTemplate.Controller in 'ViewTemplate\ViewTemplate.Controller.pas',
  ViewTemplateView in 'ViewTemplate\ViewTemplateView.pas' {ViewTemplateView},
  EditorTexto.view in 'EditorTexto.view.pas' {EditorTextoView},
  EditorTextoView.Controller.Interf in 'EditorTextoView\EditorTextoView.Controller.Interf.pas',
  EditorTextoView.Controller in 'EditorTextoView\EditorTextoView.Controller.pas',
  NavegadorView.Controller.Interf in 'NavegadorView\NavegadorView.Controller.Interf.pas',
  NavegadorView.Controller in 'NavegadorView\NavegadorView.Controller.pas',
  Navegador.View in 'Navegador.View.pas' {NavegadorView};

{$R *.res}
begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TUsandoTemplateController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
