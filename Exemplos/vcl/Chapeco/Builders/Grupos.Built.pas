{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 16/07/2017 01:38:14                                  //}
{//************************************************************//}

Unit Grupos.Built;

interface

uses System.Classes,System.SysUtils,
     MVCBr.BuilderModel,
     MVCBr.Patterns.Builder, System.RTTI;

Type

   TGruposBuilt = class(TBuiltObjectFactory)
   public
     [weak]
     function Execute(AParam: TValue)
      : TBuiltResult; override;
   end;

Implementation

  //sample to insert into Builder CreateSubClasses
  //add( 'command', TGruposBuilt);

function TGruposBuilt.Execute(AParam: TValue)
   : TBuiltResult;
begin

    /// implements here



end;

end.
