{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br                                // }
{ //************************************************************// }
{ // Data: 02/02/2017 22:18:55                                                // }
{ //************************************************************// }
// Implementação para o interface:  ITabGrupoModuleModel
// Data: 02/02/2017 22:18:55
// Criado automático pelo assistente do MVCBr (amarildo lacerda)
//
// ---------------------------------------------------------------
Unit TabGrupo.ModuleModel.Interf;

{ .$I ..\inc\mvcbr.inc }
interface

uses Forms, System.Classes, System.SysUtils, System.RTTI,
  Data.DB,
  MVCBr.Interf, MVCBr.Model, MVCBr.Controller, MVCBr.ModuleModel;

Type
  ITabGrupoModuleModel = interface(IModuleModel)
    ['{F02B68D7-93D8-4E18-813C-F3B2DD0DA4BC}']
    // incluir aqui as especializações
    function GetDataSource: TDataSource;
    procedure ProcurarGrupo(ANomeGrupo: String; AProc : TProc);
    function GetGrupoSelecionado:string;
  end;

implementation

end.
