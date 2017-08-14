{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/07/2017 00:06:18                                  // }
{ //************************************************************// }

Unit Categorias.Model;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model, MVCBr.ModelBuilder,
  Categorias.Model.Interf,
  MVCBr.Patterns.Builder, MVCBr.Controller,
  System.RTTI;

Type

  TCategoriasModel = class(TModelBuilderFactory, ICategoriasModel,
    IThisAs<TCategoriasModel>)
  protected
    procedure CreateSubClasses; override;
  public
    class function new(): ICategoriasModel; overload;
    class function new(const AController: IController)
      : ICategoriasModel; overload;
    function ThisAs: TCategoriasModel;
    // implementaçoes
  end;

Implementation

// uses Builder.Model.Classe1;

/// Add Sub-Classes of Builder

procedure TCategoriasModel.CreateSubClasses;
begin
  /// Add Sub-Classes here
  // FBuilder.Add('comandoA', TSubClass1Item);
end;

function TCategoriasModel.ThisAs: TCategoriasModel;
begin
  result := self;
end;

class function TCategoriasModel.new(): ICategoriasModel;
begin
  result := new(nil);
end;

class function TCategoriasModel.new(const AController: IController)
  : ICategoriasModel;
begin
  result := TCategoriasModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<ICategoriasModel, TCategoriasModel>
  (TCategoriasModel.classname, true);

end.
