PROGRAM Clientes;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  Main.Controller in '..\..\controller\Main.Controller.pas',
  Main.ViewModel.Interf in '..\..\viewmodel\Main.ViewModel.Interf.pas',
  Main.ViewModel in '..\..\viewmodel\Main.ViewModel.pas',
  MainView in '..\..\view\MainView.pas' {MainView},
  Validacoes.Model in '..\..\persistentmodel\Validacoes.Model.pas',
  Validacoes.Model.Interf in '..\..\persistentmodel\Validacoes.Model.Interf.pas',
  TabClientes.ModuleModel in '..\..\module\TabClientes.ModuleModel.pas' {TabClientesModuleModel: TDataModule},
  TabClientes.ModuleModel.Interf in '..\..\module\TabClientes.ModuleModel.Interf.pas',
  ProcurarEnderecos.Controller in 'ProcurarEnderecos.Controller.pas',
  ProcurarEnderecosView in '..\view\ProcurarEnderecosView.pas' {ProcurarEnderecosView},
  ProcurarEnderecos.ViewModel in '..\viewmodel\ProcurarEnderecos.ViewModel.pas',
  ProcurarEnderecos.ViewModel.Interf in '..\viewmodel\ProcurarEnderecos.ViewModel.Interf.pas';

{$R *.res}
begin
  ApplicationController.Run(TMainController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
