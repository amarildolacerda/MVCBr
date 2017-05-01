{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 01/05/2017 11:08:32                                  //}
{//************************************************************//}
unit WooCommerceSample.Controller.Interf;
 ///
 /// <summary>
 ///  IWooCommerceSampleController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 ///
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IWooCommerceSampleController = interface(IController)
         ['{F6359CD9-D7F3-401E-8C6E-CA33BB2232F4}']
         // incluir especializações aqui
  end;
Implementation
end.
