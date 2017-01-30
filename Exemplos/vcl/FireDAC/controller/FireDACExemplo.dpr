PROGRAM FireDACExemplo;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  Main.Controller in 'Main.Controller.pas',
  Main.ViewModel.Interf in '..\viewmodel\Main.ViewModel.Interf.pas',
  Main.ViewModel in '..\viewmodel\Main.ViewModel.pas',
  MainView in '..\view\MainView.pas' {MainView},
  Grupos.DataModel in '..\Grupos\Grupos.DataModel.pas',
  Grupos.DataModel.Interf in '..\Grupos\Grupos.DataModel.Interf.pas';

{$R *.res}
begin
  ApplicationController.Run(TMainController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
