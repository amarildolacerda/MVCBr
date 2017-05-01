// Implementação para o interface:  ITabClientesModuleModel
// Data: 31/01/2017 22:34:46
// Criado automático pelo assistente do MVCBr (amarildo lacerda)
//
// ---------------------------------------------------------------
Unit TabClientes.ModuleModel.Interf;

{ .$I ..\inc\mvcbr.inc }
interface

uses Forms, System.Classes, System.SysUtils, System.RTTI,
  Data.DB,
  MVCBr.Interf, MVCBr.Model, MVCBr.Controller, MVCBr.ModuleModel;

Type
  ITabClientesModuleModel = interface(IModuleModel)
    ['{9437F5C9-9001-4112-8EF3-7F4C576FC996}']
    // incluir aqui as especializações

    function GetDatasource:TDatasource;
    procedure Recarregar(  ACodigo:string );

  end;

implementation

end.
