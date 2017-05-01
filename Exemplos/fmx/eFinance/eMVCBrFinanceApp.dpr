PROGRAM eFinanceX;

// Código gerado pelo Assistente MVCBr OTA
// www.tireideletra.com.br
// Amarildo Lacerda & Grupo MVCBr-2017
uses
  System.StartUpCopy,
  FMX.Forms,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  eFinPrice.Controller.Interf in 'Controllers\eFinPrice.Controller.Interf.pas',
  eFinPrice.Controller in 'Controllers\eFinPrice.Controller.pas',
  tabelaPrice.Controller.Interf in 'Controllers\tabelaPrice.Controller.Interf.pas',
  tabelaPrice.Controller in 'Controllers\tabelaPrice.Controller.pas',
  eFinPrice.ViewModel.Interf in 'Models\eFinPrice.ViewModel.Interf.pas',
  eFinPriceView in 'Views\eFinPriceView.pas' {eFinPriceView},
  tabelaPriceView in 'Views\tabelaPriceView.pas' {tabelaPriceView},
  eFinPrice.ViewModel in 'eFinPrice.ViewModel.pas',
  System.Finance in 'System.Finance.pas';
//  MVCBr.KeyBoard.helper in '..\..\MVCBr\FMX\MVCBr.KeyBoard.helper.pas';

{$R *.res}
begin
  ApplicationController.Run(TeFinPriceController.New,
    function :boolean
    begin
      // retornar True se o applicatio pode ser carregado
      //          False se não foi autorizado inicialização
      result := true;
    end);
end.
