program StatesPatterns;


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
  MVCBr.Interf,
  StatesPatterns.Controller in 'Controllers\StatesPatterns.Controller.pas',
  StatesPatterns.Controller.Interf
    in 'Controllers\StatesPatterns.Controller.Interf.pas',
  StatesPatternsView in 'Views\StatesPatternsView.pas' {StatesPatternsView};

{$R *.res}


function CheckApplicationAuth: boolean;
begin
  result := true;
end;

begin

  ReportMemoryLeaksOnShutdown := (DebugHook <> 0);

  if CheckApplicationAuth then
    ApplicationController.run(TStatesPatternsController.New);


end.
