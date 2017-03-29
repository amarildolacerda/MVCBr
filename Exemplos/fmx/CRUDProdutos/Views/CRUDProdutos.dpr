PROGRAM CRUDProdutos;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  System.StartUpCopy,
  FMX.Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  CRUDProdutos.Controller in '..\Controllers\CRUDProdutos.Controller.pas',
  CRUDProdutos.Controller.Interf in '..\Controllers\CRUDProdutos.Controller.Interf.pas',
  CRUDProdutos.ViewModel.Interf in '..\Models\CRUDProdutos.ViewModel.Interf.pas',
  CRUDProdutos.ViewModel in '..\CRUDProdutos.ViewModel.pas',
  CRUDProdutosView in 'CRUDProdutosView.pas' {CRUDProdutosView};

{$R *.res}
begin
  ApplicationController.Run(TCRUDProdutosController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
