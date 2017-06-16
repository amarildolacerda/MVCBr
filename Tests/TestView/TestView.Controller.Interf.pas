{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 15/06/2017 21:46:55                                  //}
{//************************************************************//}
unit TestView.Controller.Interf;
 ///
 /// <summary>
 ///  ITestViewController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 ///
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  ITestViewController = interface(IController)
         ['{AF962A43-2AD3-4FA6-9F34-D25218DFF6CB}']
         // incluir especializações aqui
  end;

  ITestViewController2 = interface(IController)
         ['{AF962A43-2AD3-4FA6-9F34-D25218DFF6CB}']
         // incluir especializações aqui
  end;


Implementation
end.
