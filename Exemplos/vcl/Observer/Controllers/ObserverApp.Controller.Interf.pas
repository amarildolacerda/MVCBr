{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 18/06/2017 15:57:22                                  //}
{//************************************************************//}
unit ObserverApp.Controller.Interf;
 ///
 /// <summary>
 ///  IObserverAppController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 ///
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IObserverAppController = interface(IController)
         ['{DF038980-865A-4018-A149-8F9C9393D0EE}']
         // incluir especializações aqui
  end;
Implementation
end.
