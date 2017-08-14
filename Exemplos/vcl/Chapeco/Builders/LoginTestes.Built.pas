{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 16/07/2017 16:35:34                                  //}
{//************************************************************//}

Unit LoginTestes.Built;

interface

uses System.Classes,System.SysUtils,
     MVCBr.BuilderModel,
     MVCBr.Patterns.Builder, System.RTTI;

Type

   TLoginTestesBuilt = class(TBuiltObjectFactory)
   public
     [weak]
     function Execute(AParam: TValue)
      : TBuiltResult; override;
   end;

Implementation

  //sample to insert into Builder CreateSubClasses
  //add( 'command', TLoginTestesBuilt);

function TLoginTestesBuilt.Execute(AParam: TValue)
   : TBuiltResult;
begin

    /// implements here



end;

end.
