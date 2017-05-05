{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 05/05/2017 11:12:00                                  //}
{//************************************************************//}
unit NewMVCAppParameters.Controller.Interf;
 ///
 /// <summary>
 ///  INewMVCAppParametersController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 ///
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  INewMVCAppParametersController = interface(IController)
         ['{8DD4F5B3-07F9-4526-8160-FB640F35FFC0}']
         // incluir especializações aqui
  end;
Implementation
end.
