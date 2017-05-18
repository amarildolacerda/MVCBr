{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 17/05/2017 23:20:37                                  //}
{//************************************************************//}
unit UsandoTemplate.Controller.Interf;
 ///
 /// <summary>
 ///  IUsandoTemplateController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 ///
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IUsandoTemplateController = interface(IController)
         ['{B3594167-0279-4C3C-BE9C-C6B4E8732F9F}']
         // incluir especializações aqui
  end;
Implementation
end.
