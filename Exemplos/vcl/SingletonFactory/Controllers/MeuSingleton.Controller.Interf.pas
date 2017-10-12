{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 09/10/2017 22:47:08                                  //}
{//************************************************************//}

unit MeuSingleton.Controller.Interf;
 ///
 /// <summary>
 ///  IMeuSingletonController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 {auth}
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IMeuSingletonController = interface(IController)
         ['{D55227A2-D1C5-4F66-8526-223757F24782}']
         // incluir especializações aqui
  end;
Implementation
end.
