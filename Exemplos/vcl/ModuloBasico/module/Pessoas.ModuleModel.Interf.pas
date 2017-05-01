// Implementação para o interface:  IPessoasModuleModel
// Data: 31/01/2017 11:27:00
// Criado automático pelo assistente do MVCBr (amarildo lacerda)
//
// ---------------------------------------------------------------
Unit Pessoas.ModuleModel.Interf;

{ .$I ..\inc\mvcbr.inc }
interface

uses Forms, System.Classes, System.SysUtils, System.RTTI,
  Data.DB,
  MVCBr.Interf, MVCBr.Model, MVCBr.Controller, MVCBr.ModuleModel;

Type
  IPessoasModuleModel = interface(IModuleModel)
    ['{DE0E48E7-26D4-40F4-953D-EB6FC0DDA691}']
    // incluir aqui as especializações
    function CadastroDatasource:TDatasource;
  end;

implementation

end.
