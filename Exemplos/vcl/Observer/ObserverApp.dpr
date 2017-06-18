program ObserverApp;


// Código gerado pelo Assistente MVCBr OTA

// www.tireideletra.com.br

// Amarildo Lacerda & Grupo MVCBr-2017

uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  ObserverApp.Controller in 'Controllers\ObserverApp.Controller.pas',
  ObserverApp.Controller.Interf in 'Controllers\ObserverApp.Controller.Interf.pas',
  ObserverApp.ViewModel.Interf in 'Models\ObserverApp.ViewModel.Interf.pas',
  ObserverApp.ViewModel in 'ViewModels\ObserverApp.ViewModel.pas',
  ObserverAppView in 'Views\ObserverAppView.pas' {ObserverAppView},
  ObserverSender.Controller.Interf in 'Controllers\ObserverSender.Controller.Interf.pas',
  ObserverSender.Controller in 'Controllers\ObserverSender.Controller.pas',
  ObserverSenderView in 'Views\ObserverSenderView.pas' {ObserverSenderView};

{$R *.res}

begin

  /// Inicializa o Controller e Roda o MainForm

  ApplicationController.Run(TObserverAppController.New,

    function: boolean

    begin

      // retornar True se o applicatio pode ser carregado

      // False se não foi autorizado inicialização

      result := true;

    end);

end.
