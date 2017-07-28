PROGRAM AppPageControl;


// Código gerado pelo Assistente MVCBr OTA

// www.tireideletra.com.br

// Amarildo Lacerda & Grupo MVCBr-2017

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  AppPageControl.Controller in 'controller\AppPageControl.Controller.pas',
  AppPageControl.Controller.Interf in 'controller\AppPageControl.Controller.Interf.pas',
  AppPageControl.ViewModel.Interf in 'viewmodel\AppPageControl.ViewModel.Interf.pas',
  AppPageControl.ViewModel in 'viewmodel\AppPageControl.ViewModel.pas',
  AppPageControlView in 'view\AppPageControlView.pas' {AppPageControlView},
  MVCBr.PageView in '..\..\..\MVCBr.PageView.pas',
  MVCBr.Component in '..\..\..\MVCBr.Component.pas',
  Editor.Controller.Interf in 'Editor\Editor.Controller.Interf.pas',
  Editor.Controller in 'Editor\Editor.Controller.pas',
  EditorView in 'Editor\EditorView.pas' {EditorView},
  Editor.ViewModel in 'Editor\Editor.ViewModel.pas',
  Editor.ViewModel.Interf in 'Editor\Editor.ViewModel.Interf.pas',
  MVCBr.VCL.PageView in '..\..\..\VCL\MVCBr.VCL.PageView.pas';

{$R *.res}

begin

  /// Inicializa o Controller e Roda o MainForm

  ApplicationController.Run(TAppPageControlController.New,

    function: boolean

    begin

      // retornar True se o applicatio pode ser carregado

      // False se não foi autorizado inicialização

      result := true;

    end);

end.
