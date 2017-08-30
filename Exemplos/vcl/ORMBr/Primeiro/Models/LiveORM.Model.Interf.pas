{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 29/08/2017 22:42:33                                  //}
{//************************************************************//}

Unit LiveORM.Model.Interf;


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
  ILiveORMModel = interface( IModel )
         ['{C9351BFC-EDEF-4685-93DB-A0AD890C3AA0}']
         // incluir aqui as especializações
  end;

Implementation
end.
