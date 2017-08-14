program NewMVCAppMourao;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  NewMVCAppMourao.Controller in '..\Controllers\NewMVCAppMourao.Controller.pas',
  NewMVCAppMourao.Controller.Interf in '..\Controllers\NewMVCAppMourao.Controller.Interf.pas',
  NewMVCAppMouraoView in 'NewMVCAppMouraoView.pas' {NewMVCAppMouraoView},
  SegundoForm.Controller.Interf in '..\Controllers\SegundoForm.Controller.Interf.pas',
  SegundoForm.Controller in '..\Controllers\SegundoForm.Controller.pas',
  SegundoFormView in 'SegundoFormView.pas' {SegundoFormView},
  CacularJuros.Model in '..\Models\CacularJuros.Model.pas',
  CacularJuros.Model.Interf in '..\Models\CacularJuros.Model.Interf.pas';

{$R *.res}
function CheckApplicationAuth: boolean;
begin
  // retornar True se o applicatio pode ser carregado
  //          False se não foi autorizado inicialização
  result := true;
end;

begin
/// Inicializa o Controller e Roda o MainForm
if CheckApplicationAuth then
  ApplicationController.Run(TNewMVCAppMouraoController.New);
end.
