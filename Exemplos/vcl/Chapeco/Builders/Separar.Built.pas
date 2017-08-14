{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/07/2017 20:26:02                                  // }
{ //************************************************************// }

Unit Separar.Built;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf,
  Separar.Interf,
  System.RTTI;

Type

  TSepararBuilt = class(TInterfacedObject, ISepararBuilt)
  protected
  public

    class function New: ISepararBuilt;
  end;

Implementation

/// Lazy.add( command, TSepararBuilt);

class function TSepararBuilt.New: ISepararBuilt;
begin
  result := TSepararBuilt.create;
end;

end.
