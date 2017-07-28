{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 21/06/2017 18:38:16                                  //}
{//************************************************************//}
unit WinNotificationApp.Controller.Interf;
 ///
 /// <summary>
 ///  IWinNotificationAppController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 ///
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IWinNotificationAppController = interface(IController)
         ['{2B02627E-6241-4FB3-ABD5-7E0A94D59442}']
         // incluir especializações aqui
  end;
Implementation
end.
