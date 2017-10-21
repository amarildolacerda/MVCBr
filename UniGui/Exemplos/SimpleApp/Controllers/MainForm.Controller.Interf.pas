{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 14/07/2017 21:57:39                                  //}
{//************************************************************//}

unit MainForm.Controller.Interf;
 ///
 /// <summary>
 ///  IMainFormController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 {auth}
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IMainFormController = interface(IController)
         ['{A646D500-7E4F-42B7-A179-2F21F3652DF4}']
         // incluir especializações aqui
  end;
Implementation
end.
