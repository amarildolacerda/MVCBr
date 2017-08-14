program NewMVCApp;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  NewMVCApp.Controller in '..\Controllers\NewMVCApp.Controller.pas',
  NewMVCApp.Controller.Interf in '..\Controllers\NewMVCApp.Controller.Interf.pas',
  NewMVCAppView in 'NewMVCAppView.pas' {NewMVCAppView},
  login.Model in 'Models\login.Model.pas',
  login.Model.Interf in 'Models\login.Model.Interf.pas',
  Logs.Model in 'Models\Logs.Model.pas',
  Logs.Model.Interf in 'Models\Logs.Model.Interf.pas',
  Grupos.Model in 'Models\Grupos.Model.pas',
  Grupos.Model.Interf in 'Models\Grupos.Model.Interf.pas',
  MVCBr.ModelBuilder in 'C:\Fontes\MVCBr\MVCBr.ModelBuilder.pas',
  Setores.Model in 'Models\Setores.Model.pas',
  Setores.Model.Interf in 'Models\Setores.Model.Interf.pas',
  Categorias.Model in 'Models\Categorias.Model.pas',
  Categorias.Model.Interf in 'Models\Categorias.Model.Interf.pas';

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
  ApplicationController.Run(TNewMVCAppController.New);
end.
