{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 09/07/2017 21:26:14                                  // }
{ //************************************************************// }

Unit CacularJuros.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}

interface

{ .$I ..\inc\mvcbr.inc }
uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  CacularJuros.Model.Interf, // %Interf,
  MVCBr.Controller;

Type

  TCacularJurosModel = class(TModelFactory, ICacularJurosModel,
    IThisAs<TCacularJurosModel>)
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(): ICacularJurosModel; overload;
    class function new(const AController: IController)
      : ICacularJurosModel; overload;
    function ThisAs: TCacularJurosModel;

    // implementaçoes

    function Calcular: double;

  end;

Implementation

function TCacularJurosModel.Calcular: double;
begin
  result := 10*10;
end;

constructor TCacularJurosModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
end;

destructor TCacularJurosModel.Destroy;
begin
  inherited;
end;

function TCacularJurosModel.ThisAs: TCacularJurosModel;
begin
  result := self;
end;

class function TCacularJurosModel.new(): ICacularJurosModel;
begin
  result := new(nil);
end;

class function TCacularJurosModel.new(const AController: IController)
  : ICacularJurosModel;
begin
  result := TCacularJurosModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<ICacularJurosModel, TCacularJurosModel>
  (TCacularJurosModel.classname, true);

end.
