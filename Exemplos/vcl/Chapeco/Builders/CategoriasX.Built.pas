{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 16/07/2017 01:42:22                                  //}
{//************************************************************//}

Unit CategoriasX.Built;

interface

uses System.Classes,System.SysUtils,
     MVCBr.BuilderModel,
     MVCBr.Patterns.Builder, System.RTTI;

Type

   TCategoriasXBuilt = class(TBuiltObjectFactory)
   public
     [weak]
     function Execute(AParam: TValue)
      : TBuiltResult; override;
   end;

Implementation

  //sample to insert into Builder CreateSubClasses
  //add( 'command', TCategoriasXBuilt);

function TCategoriasXBuilt.Execute(AParam: TValue)
   : TBuiltResult;
begin

    /// implements here



end;

end.
