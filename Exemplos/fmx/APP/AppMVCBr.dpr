PROGRAM AppMVCBr;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  System.StartUpCopy,
  FMX.Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  AppMVCBr.Controller in 'AppMVCBr.Controller.pas',
  AppMVCBr.Controller.Interf in 'AppMVCBr.Controller.Interf.pas',
  AppMVCBr.ViewModel.Interf in 'AppMVCBr.ViewModel.Interf.pas',
  AppMVCBr.ViewModel in 'AppMVCBr.ViewModel.pas',
  AppMVCBrView in 'AppMVCBrView.pas' {AppMVCBrView};

{$R *.res}
begin
  ApplicationController.Run(TAppMVCBrController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
