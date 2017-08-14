{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/07/2017 01:42:44                                  // }
{ //************************************************************// }

Unit CategoriasX.Builder;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model, MVCBr.BuilderModel,
  CategoriasX.Builder.Interf,
  MVCBr.Patterns.Builder, MVCBr.Controller,
  System.RTTI;

Type

  TCategoriasXBuilder = class(TBuilderModelFactory, ICategoriasXBuilder,
    IThisAs<TCategoriasXBuilder>)
  protected
    procedure CreateSubClasses; override;
  public
    class function new(): ICategoriasXBuilder; overload;
    class function new(const AController: IController)
      : ICategoriasXBuilder; overload;
    function ThisAs: TCategoriasXBuilder;
    // implementaçoes
  end;

Implementation

// uses Builder.Model.Classe1;

/// Add Sub-Classes of Builder

procedure TCategoriasXBuilder.CreateSubClasses;
begin
  /// Add Sub-Classes here
  // FBuilder.Add('comandoA', TSubClass1Item);
end;

function TCategoriasXBuilder.ThisAs: TCategoriasXBuilder;
begin
  result := self;
end;

class function TCategoriasXBuilder.new(): ICategoriasXBuilder;
begin
  result := new(nil);
end;

class function TCategoriasXBuilder.new(const AController: IController)
  : ICategoriasXBuilder;
begin
  result := TCategoriasXBuilder.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<ICategoriasXBuilder, TCategoriasXBuilder>
  (TCategoriasXBuilder.classname, true);

end.
