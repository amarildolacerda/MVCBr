{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/07/2017 20:36:56                                  // }
{ //************************************************************// }

Unit Grupinhos.Built;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf,
  Grupinhos.Built.Interf,
  System.RTTI;

Type

  TGrupinhosBuilt = class(TInterfacedObject, IGrupinhosBuilt)
  protected
  public

    class function New: IGrupinhosBuilt;
  end;

Implementation

/// Lazy.add( command, TGrupinhosBuilt);

class function TGrupinhosBuilt.New: IGrupinhosBuilt;
begin
  result := TGrupinhosBuilt.create;
end;

end.
