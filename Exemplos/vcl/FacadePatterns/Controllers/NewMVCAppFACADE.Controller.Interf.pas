{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 04/07/2017 21:51:17                                  //}
{//************************************************************//}
unit NewMVCAppFACADE.Controller.Interf;
 ///
 /// <summary>
 ///  INewMVCAppFACADEController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 {auth}
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  INewMVCAppFACADEController = interface(IController)
         ['{FFCEDD3E-1B75-42B6-8B0A-A3880AF59754}']
         // incluir especializações aqui
  end;
Implementation
end.
