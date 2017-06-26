PROGRAM RestODataApp;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  RestODataApp.Controller in 'RestODataApp.Controller.pas',
  RestODataApp.Controller.Interf in 'RestODataApp.Controller.Interf.pas',
//  RestODataApp.ViewModel.Interf in 'RestODataApp.ViewModel.Interf.pas',  //
 // RestODataApp.ViewModel in 'RestODataApp.ViewModel.pas',
  RestODataAppView in 'RestODataAppView.pas' {RestODataAppView};

{$R *.res}
begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TRestODataAppController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
