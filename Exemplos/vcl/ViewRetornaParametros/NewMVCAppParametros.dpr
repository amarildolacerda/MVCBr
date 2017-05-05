program NewMVCAppParametros;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  NewMVCAppParameters.Controller in 'Controllers\NewMVCAppParameters.Controller.pas',
  NewMVCAppParameters.Controller.Interf in 'Controllers\NewMVCAppParameters.Controller.Interf.pas',
  NewMVCAppParameters.ViewModel.Interf in 'Models\NewMVCAppParameters.ViewModel.Interf.pas',
  NewMVCAppParameters.ViewModel in 'ViewModels\NewMVCAppParameters.ViewModel.pas',
  NewMVCAppParametersView in 'Views\NewMVCAppParametersView.pas' {NewMVCAppParametersView},
  Parametros.Controller.Interf in 'Controllers\Parametros.Controller.Interf.pas',
  Parametros.Controller in 'Controllers\Parametros.Controller.pas',
  ParametrosView in 'Views\ParametrosView.pas' {ParametrosView};

{$R *.res}
begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TNewMVCAppParametersController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
