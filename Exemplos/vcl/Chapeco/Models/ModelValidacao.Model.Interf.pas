{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 11/08/2017 10:21:37                                  //}
{//************************************************************//}

Unit ModelValidacao.Model.Interf;


{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}

interface

uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes, MVCBr.Interf, MVCBr.Model,
      //%Interf,
MVCBr.Controller;

Type
  // Interface de acesso ao model
  IModelValidacaoModel = interface( IModel )
         ['{BE4E2C27-45CC-40CE-9B5E-827777555F2A}']
         // incluir aqui as especializações
  end;

Implementation
end.
