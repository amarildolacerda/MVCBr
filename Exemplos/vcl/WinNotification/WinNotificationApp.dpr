program WinNotificationApp;


// Código gerado pelo Assistente MVCBr OTA

// www.tireideletra.com.br

// Amarildo Lacerda & Grupo MVCBr-2017

uses

  FastMM4, madExcept, madLinkDisAsm, madListHardware, madListProcesses,
  madListModules,

  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  WinNotificationApp.Controller
    in 'Controllers\WinNotificationApp.Controller.pas',
  WinNotificationApp.Controller.Interf
    in 'Controllers\WinNotificationApp.Controller.Interf.pas',
  WinNotificationApp.ViewModel.Interf
    in 'Models\WinNotificationApp.ViewModel.Interf.pas',
  WinNotificationApp.ViewModel in 'ViewModels\WinNotificationApp.ViewModel.pas',
  WinNotificationAppView
    in 'Views\WinNotificationAppView.pas' {WinNotificationAppView} ,
  WinNotification.Model in '..\..\..\AdIN\Windows\WinNotification.Model.pas',
  WinNotification.Model.Interf
    in '..\..\..\AdIN\Windows\WinNotification.Model.Interf.pas';

{$R *.res}

begin

  /// Inicializa o Controller e Roda o MainForm

  ApplicationController.Run(TWinNotificationAppController.New,

    function: boolean

    begin

      // retornar True se o applicatio pode ser carregado

      // False se não foi autorizado inicialização

      result := true;

    end);

end.
