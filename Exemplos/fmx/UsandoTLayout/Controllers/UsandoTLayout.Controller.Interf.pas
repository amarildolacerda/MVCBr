{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 01/05/2017 15:04:55                                  //}
{//************************************************************//}
unit UsandoTLayout.Controller.Interf;
 ///
 /// <summary>
 ///  IUsandoTLayoutController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 ///
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IUsandoTLayoutController = interface(IController)
         ['{38335DD9-4EB6-409B-9F27-FBFBF83C11E7}']
         // incluir especializações aqui
  end;
Implementation
end.
