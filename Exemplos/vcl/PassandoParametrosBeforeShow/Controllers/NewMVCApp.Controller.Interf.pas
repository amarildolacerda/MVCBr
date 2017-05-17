{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 16/05/2017 22:59:43                                  //}
{//************************************************************//}
unit NewMVCApp.Controller.Interf;
 ///
 /// <summary>
 ///  INewMVCAppController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 ///
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  INewMVCAppController = interface(IController)
         ['{3CDDCF59-0379-49B6-9153-4BD1DEBE6CC5}']
         // incluir especializações aqui
  end;
Implementation
end.
