Unit ACBrValidador.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

{ .$I ..\inc\mvcbr.inc }
uses Classes, forms, SysUtils, MVCBr.Interf, MVCBr.Model,
  ACBrValidador.Model.Interf, // %Interf,
  ACBrValidador,
  MVCBr.Controller;

Type
  TACBrValidadorModel = class(TModelFactory, IACBrValidadorModel,
    IThisAs<TACBrValidadorModel>)
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(): IACBrValidadorModel; overload;
    class function new(const AController: IController)
      : IACBrValidadorModel; overload;
    function ThisAs: TACBrValidadorModel;

    // ACBr
    function ValidarCPF(const Documento: String): String;
    function ValidarCNPJ(const Documento: String): String;
    function ValidarCNPJouCPF(const Documento: String): String;
    function ValidarIE(const AIE, AUF: String): String;
    function ValidarSuframa(const Documento: String): String;
    function ValidarGTIN(const Documento: String): String;
    function ValidarRenavam(const Documento: String): String;
    function ValidarEmail(const Documento: string): String;
    function ValidarCEP(const ACEP, AUF: String): String; overload;
    function ValidarCEP(const ACEP: Integer; AUF: String): String; overload;
    function ValidarCNH(const Documento: String): String;
    function ValidarUF(const AUF: String): String;

    Function FormatarFone(const AValue: String; DDDPadrao: String = ''): String;
    Function FormatarCPF(const AValue: String): String;
    Function FormatarCNPJ(const AValue: String): String;
    function FormatarCNPJouCPF(const AValue: String): String;
    function FormatarPlaca(const AValue: string): string;
    Function FormatarIE(const AValue: String; UF: String): String;
    Function FormatarCheque(const AValue: String): String;
    Function FormatarPIS(const AValue: String): String;
    Function FormatarCEP(const AValue: String): String; overload;
    Function FormatarCEP(const AValue: Integer): String; overload;
    function FormatarSUFRAMA(const AValue: String): String;

    Function FormatarMascaraNumerica(ANumValue, Mascara: String): String;

    function ValidarDocumento(const TipoDocto: TACBrValTipoDocto;
      const Documento: String; const Complemento: String = ''): String;
    function FormatarDocumento(const TipoDocto: TACBrValTipoDocto;
      const Documento: String): String;

    function Modulo11(const Documento: string; const Peso: Integer = 2;
      const Base: Integer = 9): String;
    function MascaraIE(AValue: String; UF: String): String;

  end;

Implementation

constructor TACBrValidadorModel.Create;
begin
  inherited;
  ModelTypes := [mtCommon];
end;

destructor TACBrValidadorModel.Destroy;
begin
  inherited;
end;

function TACBrValidadorModel.FormatarCEP(const AValue: Integer): String;
begin
  result := ACBrValidador.FormatarCEP(AValue);
end;

function TACBrValidadorModel.FormatarCEP(const AValue: String): String;
begin
  result := ACBrValidador.FormatarCEP(AValue);
end;

function TACBrValidadorModel.FormatarCheque(const AValue: String): String;
begin
  result := ACBrValidador.FormatarCheque(AValue);
end;

function TACBrValidadorModel.FormatarCNPJ(const AValue: String): String;
begin
  result := ACBrValidador.FormatarCNPJ(AValue);
end;

function TACBrValidadorModel.FormatarCNPJouCPF(const AValue: String): String;
begin
  result := ACBrValidador.FormatarCNPJouCPF(AValue);
end;

function TACBrValidadorModel.FormatarCPF(const AValue: String): String;
begin
  result := ACBrValidador.FormatarCPF(AValue);
end;

function TACBrValidadorModel.FormatarDocumento(const TipoDocto
  : TACBrValTipoDocto; const Documento: String): String;
begin
  result := ACBrValidador.FormatarDocumento(TipoDocto, Documento);
end;

function TACBrValidadorModel.FormatarFone(const AValue: String;
  DDDPadrao: String): String;
begin
  result := ACBrValidador.FormatarFone(AValue, DDDPadrao);
end;

function TACBrValidadorModel.FormatarIE(const AValue: String;
  UF: String): String;
begin
  result := ACBrValidador.FormatarIE(AValue,UF);
end;

function TACBrValidadorModel.FormatarMascaraNumerica(ANumValue,
  Mascara: String): String;
begin
  result := ACBrValidador.FormatarMascaraNumerica(ANumValue, Mascara);
end;

function TACBrValidadorModel.FormatarPIS(const AValue: String): String;
begin
  result := ACBrValidador.FormatarPIS(AValue);
end;

function TACBrValidadorModel.FormatarPlaca(const AValue: string): string;
begin
  result := ACBrValidador.FormatarPlaca(AValue);
end;

function TACBrValidadorModel.FormatarSUFRAMA(const AValue: String): String;
begin
  result := ACBrValidador.FormatarSUFRAMA(AValue);
end;

function TACBrValidadorModel.MascaraIE(AValue, UF: String): String;
begin
  result := ACBrValidador.MascaraIE(AValue, UF);
end;

function TACBrValidadorModel.Modulo11(const Documento: string;
  const Peso, Base: Integer): String;
begin
  result := ACBrValidador.Modulo11(Documento, Peso, Base);
end;

function TACBrValidadorModel.ThisAs: TACBrValidadorModel;
begin
  result := self;
end;

function TACBrValidadorModel.ValidarCEP(const ACEP: Integer;
  AUF: String): String;
begin
  result := ACBrValidador.ValidarCEP(ACEP, AUF);
end;

function TACBrValidadorModel.ValidarCEP(const ACEP, AUF: String): String;
begin
  result := ACBrValidador.ValidarCEP(ACEP, AUF);
end;

function TACBrValidadorModel.ValidarCNH(const Documento: String): String;
begin
  result := ACBrValidador.ValidarCNH(Documento);
end;

function TACBrValidadorModel.ValidarCNPJ(const Documento: String): String;
begin
  result := ACBrValidador.ValidarCNPJ(Documento);
end;

function TACBrValidadorModel.ValidarCNPJouCPF(const Documento: String): String;
begin
  result := ACBrValidador.ValidarCNPJouCPF(Documento);
end;

function TACBrValidadorModel.ValidarCPF(const Documento: String): String;
begin
  result := ACBrValidador.ValidarCPF(Documento);
end;

function TACBrValidadorModel.ValidarDocumento(const TipoDocto
  : TACBrValTipoDocto; const Documento, Complemento: String): String;
begin
  result := ACBrValidador.ValidarDocumento(TipoDocto, Documento)
end;

function TACBrValidadorModel.ValidarEmail(const Documento: string): String;
begin
  result := ACBrValidador.ValidarEmail(Documento);
end;

function TACBrValidadorModel.ValidarGTIN(const Documento: String): String;
begin
  result := ACBrValidador.ValidarGTIN(Documento);
end;

function TACBrValidadorModel.ValidarIE(const AIE, AUF: String): String;
begin
  result := ACBrValidador.ValidarIE(AIE, AUF);
end;

function TACBrValidadorModel.ValidarRenavam(const Documento: String): String;
begin
  result := ACBrValidador.ValidarRenavam(Documento);
end;

function TACBrValidadorModel.ValidarSuframa(const Documento: String): String;
begin
  result := ACBrValidador.ValidarSuframa(Documento);
end;

function TACBrValidadorModel.ValidarUF(const AUF: String): String;
begin
  result := ACBrValidador.ValidarUF(AUF);
end;

class function TACBrValidadorModel.new(): IACBrValidadorModel;
begin
  result := new(nil);
end;

class function TACBrValidadorModel.new(const AController: IController)
  : IACBrValidadorModel;
begin
  result := TACBrValidadorModel.Create;
  result.Controller(AController);
end;

end.
