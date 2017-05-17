PROGRAM CRUDProdutos;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  CRUDProdutos.Controller in 'Controllers\CRUDProdutos.Controller.pas',
  CRUDProdutos.Controller.Interf in 'Controllers\CRUDProdutos.Controller.Interf.pas',
  CRUDProdutos.ViewModel.Interf in 'Models\CRUDProdutos.ViewModel.Interf.pas',
  CRUDProdutos.ViewModel in 'CRUDProdutos.ViewModel.pas',
  CRUDProdutosView in 'Views\CRUDProdutosView.pas' {CRUDProdutosView};

{$R *.res}
begin
/// Inicializa o Controller e Roda o MainForm
  ApplicationController.Run(TCRUDProdutosController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
