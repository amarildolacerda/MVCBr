{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 17/04/2017 12:17:21                                  //}
{//************************************************************//}
unit ComoEnviarMensagemParaOutraView.Controller.Interf;
 ///
 /// <summary>
 ///  IComoEnviarMensagemParaOutraViewController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 ///
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IComoEnviarMensagemParaOutraViewController = interface(IController)
         ['{AC472D78-45D0-443A-926D-D84DC8C9690D}']
         // incluir especializações aqui
  end;
Implementation
end.
