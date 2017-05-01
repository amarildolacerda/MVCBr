program UsandoTLayout;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  System.StartUpCopy,
  FMX.Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  UsandoTLayout.Controller in 'Controllers\UsandoTLayout.Controller.pas',
  UsandoTLayout.Controller.Interf in 'Controllers\UsandoTLayout.Controller.Interf.pas',
  UsandoTLayout.ViewModel.Interf in 'Models\UsandoTLayout.ViewModel.Interf.pas',
  UsandoTLayout.ViewModel in 'ViewModels\UsandoTLayout.ViewModel.pas',
  UsandoTLayoutView in 'Views\UsandoTLayoutView.pas' {UsandoTLayoutView},
  segundoForm.Controller.Interf in 'Controllers\segundoForm.Controller.Interf.pas',
  segundoForm.Controller in 'Controllers\segundoForm.Controller.pas',
  segundoFormView in 'Views\segundoFormView.pas' {segundoFormView};

{$R *.res}
begin
  ApplicationController.Run(TUsandoTLayoutController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
