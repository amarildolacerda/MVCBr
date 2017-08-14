{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 09/07/2017 21:10:02                                  //}
{//************************************************************//}

unit NewMVCAppMourao.Controller.Interf;
 ///
 /// <summary>
 ///  INewMVCAppMouraoController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 {auth}
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  INewMVCAppMouraoController = interface(IController)
         ['{7052F33A-FACC-4E5D-8700-CDF2667A5363}']
         // incluir especializações aqui
  end;
Implementation
end.
