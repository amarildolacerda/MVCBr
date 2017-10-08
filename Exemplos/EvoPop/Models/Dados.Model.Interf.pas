{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 29/09/2017 21:58:42                                  // }
{ //************************************************************// }

Unit Dados.Model.Interf;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}

interface

uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  Data.DB,
  MVCBr.Controller;

Type
  // Interface de acesso ao model
  IDadosModel = interface(IModel)
    ['{478C1530-6889-4C29-9B3E-90A9E6EE2FDB}']
    // incluir aqui as especializações
    procedure CarregarDataset(arquivo: string; ADataset: TDataset);

  end;

Implementation

end.
