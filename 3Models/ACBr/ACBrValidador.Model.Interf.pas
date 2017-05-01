Unit ACBrValidador.Model.Interf;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

uses Classes, forms, SysUtils, MVCBr.Interf, MVCBr.Model,
  // %Interf,
  ACBrValidador,
  MVCBr.Controller;

Type
  // Interface de acesso ao model
  IACBrValidadorModel = interface(IModel)
    ['{9C781AA2-48A3-45FC-B009-F22B195C0AFD}']
    // incluir aqui as especializações
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

end.
