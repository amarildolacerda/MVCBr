{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 17/05/2017 14:20:45                                  //}
{//************************************************************//}
unit JsonEdit.Controller.Interf;
 ///
 /// <summary>
 ///  IJsonEditController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 ///
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IJsonEditController = interface(IController)
         ['{49A37E4B-B5D7-456E-8E9A-C14FD0E01CDE}']
         // incluir especializações aqui
  end;
Implementation
end.
