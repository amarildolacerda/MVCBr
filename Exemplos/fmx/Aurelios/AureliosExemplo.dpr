PROGRAM AureliosExemplo;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  System.StartUpCopy,
  FMX.Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  AureliosExemplo.Controller in 'controller\AureliosExemplo.Controller.pas',
  AureliosExemplo.Controller.Interf in 'controller\AureliosExemplo.Controller.Interf.pas',
  AureliosExemplo.ViewModel.Interf in 'viewmodel\AureliosExemplo.ViewModel.Interf.pas',
  AureliosExemplo.ViewModel in 'viewmodel\AureliosExemplo.ViewModel.pas',
  AureliosExemploView in 'view\AureliosExemploView.pas' {AureliosExemploView};

{$R *.res}
begin
  ApplicationController.Run(TAureliosExemploController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
