{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 04/07/2017 22:36:17                                  // }
{ //************************************************************// }
Unit PDVSat.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

{ .$I ..\inc\mvcbr.inc }
uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  PDVSat.Model.Interf, // %Interf,
  System.RTTI,
  MVCBr.Patterns.Facade,
  MVCBr.Controller;

Type

  TPDVSatModel = class(TModelFactory, IPDVSatModel, IThisAs<TPDVSatModel>)
  protected
    class var FFacade: TMVCBrFacade;
  public
    Constructor Create; override;
    Destructor Destroy; override;

    class function Comandos: TMVCBrFacade;
    class procedure Release;

    class function new(): IPDVSatModel; overload;
    class function new(const AController: IController): IPDVSatModel; overload;
    function ThisAs: TPDVSatModel;
    // implementaçoes
    function ExecutarComando(AComando: TValue; AParametro: TValue): boolean;
  end;

procedure PDVDSatModelRegistrar(AComando: TValue; AFunc: TMVCBrFacateFunc);

Implementation

/// / livre de acoplamentos



procedure PDVDSatModelRegistrar(AComando: TValue; AFunc: TMVCBrFacateFunc);
begin
  TPDVSatModel.Comandos.add(AComando, AFunc);
end;

class function TPDVSatModel.Comandos: TMVCBrFacade;
begin
  if not assigned(FFacade) then
    FFacade := TMVCBrFacade.new;
  result := FFacade;
end;

constructor TPDVSatModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
end;

destructor TPDVSatModel.Destroy;
begin
  inherited;
end;

function TPDVSatModel.ExecutarComando(AComando, AParametro: TValue): boolean;
begin
  result := FFacade.Execute(AComando, AParametro);
end;

function TPDVSatModel.ThisAs: TPDVSatModel;
begin
  result := self;
end;

class function TPDVSatModel.new(): IPDVSatModel;
begin
  result := new(nil);
end;

class function TPDVSatModel.new(const AController: IController): IPDVSatModel;
begin
  result := TPDVSatModel.Create;
  result.Controller(AController);
end;

class procedure TPDVSatModel.Release;
begin
  if assigned(FFacade) then
    FFacade.free;
end;

Initialization

TMVCRegister.RegisterType<IPDVSatModel, TPDVSatModel>(TPDVSatModel.classname, true);

finalization

TPDVSatModel.Release;

end.
