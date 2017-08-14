{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 17/07/2017 20:29:09                                  //}
{//************************************************************//}

Unit Piracaia.Built;

interface
uses
   System.SysUtils,
   {$IFDEF FMX} FMX.Forms,
   {$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf,
  Piracaia.Built.Interf,
  System.RTTI;

Type

 TPiracaiaBuilt = class(TInterfacedObject,IPiracaiaBuilt)
 protected
 public

   class function New:IPiracaiaBuilt;
 end;

Implementation

/// Lazy.add( command, TPiracaiaBuilt);

   class function TPiracaiaBuilt.New:IPiracaiaBuilt;
   begin
      result :=  TPiracaiaBuilt.create;
   end;

end.

