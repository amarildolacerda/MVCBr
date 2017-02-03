PROGRAM Grupo;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  Grupo.Controller in '..\..\controller\Grupo.Controller.pas',
  Grupo.ViewModel.Interf in '..\..\viewmodel\Grupo.ViewModel.Interf.pas',
  Grupo.ViewModel in '..\..\viewmodel\Grupo.ViewModel.pas',
  GrupoView in '..\..\view\GrupoView.pas' {GrupoView},
  TabGrupo.ModuleModel in '..\..\TabGrupo\module\TabGrupo.ModuleModel.pas' {TabGrupoModuleModel: TDataModule},
  TabGrupo.ModuleModel.Interf in '..\..\TabGrupo\module\TabGrupo.ModuleModel.Interf.pas',
  Usuarios.Controller in '..\controller\Usuarios.Controller.pas',
  UsuarioView in 'UsuarioView.pas' {UsuarioForm};

{$R *.res}
begin
  ApplicationController.Run(TGrupoController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
