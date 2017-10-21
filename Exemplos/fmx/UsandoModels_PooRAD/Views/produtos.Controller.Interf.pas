{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 15/10/2017 16:41:33                                  //}
{//************************************************************//}

unit produtos.Controller.Interf;
 ///
 /// <summary>
 ///  IprodutosController
 ///     Interaface de acesso ao object factory do controller
 /// </summary>
 {auth}
interface
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}
System.Classes, MVCBr.Interf;
type
  IprodutosController = interface(IController)
         ['{5A75523A-6B66-4094-BDB4-768981F4E700}']
         // incluir especializações aqui
  end;
Implementation
end.
