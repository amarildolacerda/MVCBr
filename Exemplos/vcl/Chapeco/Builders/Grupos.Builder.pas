{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/07/2017 01:08:42                                  // }
{ //************************************************************// }

Unit Grupos.Builder;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model, MVCBr.ModelBuilder,
  Grupos.Builder.Interf,
  MVCBr.Patterns.Builder, MVCBr.Controller,
  System.RTTI;

Type

  TGruposBuilder = class(TModelBuilderFactory, IGruposBuilder,
    IThisAs<TGruposBuilder>)
  protected
    procedure CreateSubClasses; override;
  public
    class function new(): IGruposBuilder; overload;
    class function new(const AController: IController): IGruposBuilder;
      overload;
    function ThisAs: TGruposBuilder;
    // implementaçoes
  end;

Implementation

// uses Builder.Model.Classe1;

/// Add Sub-Classes of Builder

procedure TGruposBuilder.CreateSubClasses;
begin
  /// Add Sub-Classes here
  // FBuilder.Add('comandoA', TSubClass1Item);
end;

function TGruposBuilder.ThisAs: TGruposBuilder;
begin
  result := self;
end;

class function TGruposBuilder.new(): IGruposBuilder;
begin
  result := new(nil);
end;

class function TGruposBuilder.new(const AController: IController)
  : IGruposBuilder;
begin
  result := TGruposBuilder.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<IGruposBuilder, TGruposBuilder>
  (TGruposBuilder.classname, true);

end.
