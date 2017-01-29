program FMXBasico;

uses
  System.StartUpCopy,
  FMX.Forms,
  MVCBr.Interf,
  MVCBr.Controller,
  MVCBr.ApplicationController,
  Unit46 in 'Unit46.pas' {Form46},
  Main.Controller in 'controller\Main.Controller.pas',
  MainView in 'view\MainView.pas' {MainView},
  Main.ViewModel in 'viewmodel\Main.ViewModel.pas',
  Main.ViewModel.Interf in 'viewmodel\Main.ViewModel.Interf.pas';

{$R *.res}

begin
  // TIToolServices

  ApplicationController.Run(TMainView,TMainController.New,TMainViewModel.new,
    function :boolean
    begin
       result := true;
    end);
end.
