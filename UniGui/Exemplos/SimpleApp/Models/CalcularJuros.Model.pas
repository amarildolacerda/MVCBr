{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 14/07/2017 22:27:33                                  // }
{ //************************************************************// }

Unit CalcularJuros.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}

interface

{ .$I ..\inc\mvcbr.inc }
uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  CalcularJuros.Model.Interf, // %Interf,
  MVCBr.Controller;

Type

  TCalcularJurosModel = class(TModelFactory, ICalcularJurosModel,
    IThisAs<TCalcularJurosModel>)
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(): ICalcularJurosModel; overload;
    class function new(const AController: IController)
      : ICalcularJurosModel; overload;
    function ThisAs: TCalcularJurosModel;

    // implementaçoes
    function Calcular: Double;
    function GetDateFinished:TDateTime;
  end;

Implementation

function TCalcularJurosModel.Calcular: Double;
begin
  result := TThread.GetTickCount;
end;

constructor TCalcularJurosModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
end;

destructor TCalcularJurosModel.Destroy;
begin
  inherited;
end;

function TCalcularJurosModel.GetDateFinished: TDateTime;
begin
   result := now;
end;

function TCalcularJurosModel.ThisAs: TCalcularJurosModel;
begin
  result := self;
end;

class function TCalcularJurosModel.new(): ICalcularJurosModel;
begin
  result := new(nil);
end;

class function TCalcularJurosModel.new(const AController: IController)
  : ICalcularJurosModel;
begin
  result := TCalcularJurosModel.Create;
  result.Controller(AController);
end;

Initialization

TMVCRegister.RegisterType<ICalcularJurosModel, TCalcularJurosModel>
  (TCalcularJurosModel.classname, true);

end.
