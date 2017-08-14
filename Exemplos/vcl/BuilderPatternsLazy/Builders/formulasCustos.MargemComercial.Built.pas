{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 11/08/2017 09:17:08                                  // }
{ //************************************************************// }

Unit formulasCustos.MargemComercial.Built;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf,
  formulasCustos.MargemComercial.Built.Interf,
  System.RTTI;

Type

  TformulasCustosMargemComercialBuilt = class(TInterfacedObject,
    IformulasCustosMargemComercialBuilt)
  protected
  public
    class function New: IformulasCustosMargemComercialBuilt;
    function CalcularPreco(idProduto: integer): Double;
  end;

Implementation

/// Lazy.add( command, TformulasCustos.MargemComercialBuilt);

function TformulasCustosMargemComercialBuilt.CalcularPreco
  (idProduto: integer): Double;
begin
  result := 10;
end;

class function TformulasCustosMargemComercialBuilt.New
  : IformulasCustosMargemComercialBuilt;
begin
  result := TformulasCustosMargemComercialBuilt.create;
end;

end.
