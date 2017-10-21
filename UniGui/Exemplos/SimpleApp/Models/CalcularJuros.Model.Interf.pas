{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 14/07/2017 22:27:33                                  // }
{ //************************************************************// }

Unit CalcularJuros.Model.Interf;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}

interface

uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  // %Interf,
  MVCBr.Controller;

Type
  // Interface de acesso ao model
  ICalcularJurosModel = interface(IModel)
    ['{EAE36C9C-DA1D-4BFD-BE66-11A07828F78B}']
    // incluir aqui as especializações

    function Calcular: Double;
    function GetDateFinished: TDateTime;
  end;

Implementation

end.
