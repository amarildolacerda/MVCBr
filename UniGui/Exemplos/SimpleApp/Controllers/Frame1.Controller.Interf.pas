{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 14/07/2017 22:02:01                                  //}
{//************************************************************//}

unit Frame1.Controller.Interf;
 ///
 /// <summary>
 ///  IFrame1Controller
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 {auth}
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IFrame1Controller = interface(IController)
         ['{32229905-E2DB-4C1F-AE38-93ACF4DF4ABC}']
         // incluir especializações aqui
  end;
Implementation
end.
