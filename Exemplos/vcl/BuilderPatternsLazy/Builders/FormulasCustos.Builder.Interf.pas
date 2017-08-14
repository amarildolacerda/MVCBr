{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 11/08/2017 09:15:48                                  //}
{//************************************************************//}

Unit FormulasCustos.Builder.Interf;

interface

Uses MVCBr.Interf,MVCBr.Model,MVCBr.BuilderModel,
MVCBr.Patterns.Builder,System.RTTI;

Type

  IFormulasCustosBuilderModel = interface(IBuilderModel)
         ['{4EC8D5E6-80AF-4BD0-B7C6-38A0FB5BEA3B}']
  end;

  /// strong typed commands
  /// put here yours builder commands
  TFormulasCustosModelCommands = record
    const
       cmd_margem_comercial = 'margem_comercial';
  end;

Implementation
end.
