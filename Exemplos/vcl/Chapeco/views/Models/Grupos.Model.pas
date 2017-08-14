{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/07/2017 23:35:34                                  // }
{ //************************************************************// }

Unit Grupos.Model;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model,
  Grupos.Model.Interf,
  MVCBr.Patterns.Builder, MVCBr.Controller,
  MVCBr.ModelBuilder,
  System.RTTI;

Type

  TGruposModel = class(TModelBuilderFactory, IGruposModel)
  protected
    procedure CreateSubClasses; override;
  public
    class function new(): IGruposModel; overload;
    class function new(const AController: IController): IGruposModel; overload;
    function ThisAs: TGruposModel;
    // implementaçoes
  end;

Implementation

// uses Builder.Model.Classe1;

/// Add Sub-Classes of Builder

procedure TGruposModel.CreateSubClasses;
begin

  /// Add Sub-Classes here
  // FBuilder.Add('comandoA', TSubClass1Item);
end;





function TGruposModel.ThisAs: TGruposModel;
begin
  result := self;
end;

class function TGruposModel.new(): IGruposModel;
begin
  result := new(nil);
end;

class function TGruposModel.new(const AController: IController): IGruposModel;
begin
  result := TGruposModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<IGruposModel, TGruposModel>
  (TGruposModel.classname, true);

end.
