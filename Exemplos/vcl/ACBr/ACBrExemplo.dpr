PROGRAM ACBrExemplo;


// Código gerado pelo Assistente MVCBr OTA

// www.tireideletra.com.br

// Amarildo Lacerda & Grupo MVCBr-2017

uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  ACBrUtils.Model.Interf in '..\..\..\ACBr\ACBrUtils.Model.Interf.pas',
  ACBrUtils.Model in '..\..\..\ACBr\ACBrUtils.Model.pas',
  ACBrValidador.Model.Interf in '..\..\..\ACBr\ACBrValidador.Model.Interf.pas',
  ACBrValidador.Model in '..\..\..\ACBr\ACBrValidador.Model.pas',
  Main.Controller in 'controller\Main.Controller.pas',
  MainView in 'view\MainView.pas' {MainView},
  Main.ViewModel.Interf in 'viewmodel\Main.ViewModel.Interf.pas',
  Main.ViewModel in 'viewmodel\Main.ViewModel.pas';

{$R *.res}

begin

  ApplicationController.Run(TMainController.New,

    function: boolean

    begin

      // retornar True se o applicatio pode ser carregado

      // False se não foi autorizado inicialização

      result := true;

    end);

end.
