{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 15/10/2017 16:14:07                                  //}
{//************************************************************//}

unit DemoAddModel.Controller.Interf;
 ///
 /// <summary>
 ///  IDemoAddModelController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 {auth}
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IDemoAddModelController = interface(IController)
         ['{DFE0394B-5D29-45CD-8769-86A9809E38BB}']
         // incluir especializações aqui
  end;
Implementation
end.
