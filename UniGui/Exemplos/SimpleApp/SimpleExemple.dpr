program SimpleExemple;

uses
  Forms,
  ServerModule in 'ServerModule.pas' {UniServerModule: TUniGUIServerModule},
  MainModule in 'MainModule.pas' {UniMainModule: TUniGUIMainModule},
  Main in 'Main.pas' {MainForm: TUniForm},
  Unit1 in 'Views\Unit1.pas' {UniFrame1: TUniFrame},
  MainForm.Controller.Interf in 'Controllers\MainForm.Controller.Interf.pas',
  MainForm.Controller in 'Controllers\MainForm.Controller.pas',
  MVCBr.UniDbGrid.Helper in '..\..\MVCBr.UniDbGrid.Helper.pas',
  MVCBr.UniForm in '..\..\MVCBr.UniForm.pas',
  MVCBr.UniFormView in '..\..\MVCBr.UniFormView.pas',
  MVCBr.UniFrame in '..\..\MVCBr.UniFrame.pas',
  MVCBr.UniFrameView in '..\..\MVCBr.UniFrameView.pas',
  MVCBr.UniHelper in '..\..\MVCBr.UniHelper.pas',
  MVCBr.UniPageControlManager in '..\..\MVCBr.UniPageControlManager.pas',
  Frame1.Controller.Interf in 'Controllers\Frame1.Controller.Interf.pas',
  Frame1.Controller in 'Controllers\Frame1.Controller.pas',
  CalcularJuros.Model in 'Models\CalcularJuros.Model.pas',
  CalcularJuros.Model.Interf in 'Models\CalcularJuros.Model.Interf.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  TUniServerModule.Create(Application);
  Application.Run;
end.
