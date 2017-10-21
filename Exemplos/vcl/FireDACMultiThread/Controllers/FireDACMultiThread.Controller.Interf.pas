{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 20/10/2017 06:38:15                                  //}
{//************************************************************//}

unit FireDACMultiThread.Controller.Interf;
 ///
 /// <summary>
 ///  IFireDACMultiThreadController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 {auth}
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IFireDACMultiThreadController = interface(IController)
         ['{DD178236-BD09-40ED-8F33-F45586606341}']
         // incluir especializações aqui
  end;
Implementation
end.
