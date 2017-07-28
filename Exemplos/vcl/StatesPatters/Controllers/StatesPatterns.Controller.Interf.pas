{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 09/07/2017 10:45:40                                  //}
{//************************************************************//}

unit StatesPatterns.Controller.Interf;
 ///
 /// <summary>
 ///  IStatesPatternsController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 {auth}
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IStatesPatternsController = interface(IController)
         ['{BAAB8E59-8400-4CAE-B8D0-7930DF0ADF38}']
         // incluir especializações aqui
  end;
Implementation
end.
