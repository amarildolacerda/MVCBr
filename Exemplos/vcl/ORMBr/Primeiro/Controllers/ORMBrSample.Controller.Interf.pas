{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 27/08/2017 11:16:03                                  //}
{//************************************************************//}

unit ORMBrSample.Controller.Interf;
 ///
 /// <summary>
 ///  IORMBrSampleController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 {auth}
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IORMBrSampleController = interface(IController)
         ['{14850644-D330-4B5C-BCA3-43DA14153200}']
         // incluir especializações aqui
  end;
Implementation
end.
