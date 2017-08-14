{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/07/2017 00:04:10                                  // }
{ //************************************************************// }

Unit Setores.Model;

interface

uses
  System.SysUtils,
{$IFDEF FMX} FMX.Forms,
{$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf, MVCBr.Model, MVCBr.ModelBuilder,
  Setores.Model.Interf,
  MVCBr.Patterns.Builder, MVCBr.Controller,
  System.RTTI;

Type

  TSetoresModel = class(TModelBuilderFactory, ISetoresModel,
    IThisAs<TSetoresModel>)
  protected
    procedure CreateSubClasses; override;
  public
    class function new(): ISetoresModel; overload;
    class function new(const AController: IController): ISetoresModel; overload;
    function ThisAs: TSetoresModel;
    // implementaçoes
  end;

Implementation

// uses Builder.Model.Classe1;

/// Add Sub-Classes of Builder

procedure TSetoresModel.CreateSubClasses;
begin
  /// Add Sub-Classes here
  // FBuilder.Add('comandoA', TSubClass1Item);
end;

function TSetoresModel.ThisAs: TSetoresModel;
begin
  result := self;
end;

class function TSetoresModel.new(): ISetoresModel;
begin
  result := new(nil);
end;

class function TSetoresModel.new(const AController: IController): ISetoresModel;
begin
  result := TSetoresModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<ISetoresModel, TSetoresModel>
  (TSetoresModel.classname, true);

end.
