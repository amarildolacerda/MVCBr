PROGRAM TabControlNav;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  System.StartUpCopy,
  FMX.Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  TabControlNav.Controller in 'TabControlNav.Controller.pas',
  TabControlNav.Controller.Interf in 'TabControlNav.Controller.Interf.pas',
  TabControlNav.ViewModel.Interf in 'TabControlNav.ViewModel.Interf.pas',
  TabControlNav.ViewModel in 'TabControlNav.ViewModel.pas',
  TabControlNavView in 'TabControlNavView.pas' {TabControlNavView},
  MVCBr.FMX.PageView in '..\..\..\FMX\MVCBr.FMX.PageView.pas',
  Editor.Controller.Interf in 'Editor\Editor.Controller.Interf.pas',
  Editor.Controller in 'Editor\Editor.Controller.pas',
  EditorView in 'Editor\EditorView.pas' {EditorView};

{$R *.res}
begin
  ApplicationController.Run(TTabControlNavController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
