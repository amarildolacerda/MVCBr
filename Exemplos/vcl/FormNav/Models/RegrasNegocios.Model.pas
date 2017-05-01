{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 26/03/2017 11:56:19                                  // }
{ //************************************************************// }
Unit RegrasNegocios.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

{ .$I ..\inc\mvcbr.inc }
uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  RegrasNegocios.Model.Interf, // %Interf,
  MVCBr.Controller;

Type
  TRegrasNegociosModel = class(TModelFactory, IRegrasNegociosModel,
    IThisAs<TRegrasNegociosModel>)
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(): IRegrasNegociosModel; overload;
    class function new(const AController: IController)
      : IRegrasNegociosModel; overload;
    function ThisAs: TRegrasNegociosModel;
    // implementaçoes

    function Validar(txt:string):boolean;
  end;

Implementation

uses VCL.Dialogs;

constructor TRegrasNegociosModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
end;

destructor TRegrasNegociosModel.Destroy;
begin
  inherited;
end;

function TRegrasNegociosModel.ThisAs: TRegrasNegociosModel;
begin
  result := self;
end;

function TRegrasNegociosModel.Validar(txt: string): boolean;
begin
   showMessage(txt);
end;

class function TRegrasNegociosModel.new(): IRegrasNegociosModel;
begin
  result := new(nil);
end;

class function TRegrasNegociosModel.new(const AController: IController)
  : IRegrasNegociosModel;
begin
  result := TRegrasNegociosModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<IRegrasNegociosModel, TRegrasNegociosModel>
  (TRegrasNegociosModel.classname, true);

end.
