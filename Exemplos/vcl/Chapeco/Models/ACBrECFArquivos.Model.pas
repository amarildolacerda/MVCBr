{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 09/07/2017 19:19:43                                  // }
{ //************************************************************// }

unit ACBrECFArquivos.Model;

///
/// <summary>
/// Model para implementar regras de negócio
/// </summary>
///
{ .$I ..\inc\mvcbr.inc }
interface

uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  ACBrPAFClass,
  ACBrECFArquivos.Model.Interf, MVCBr.Controller;

type

  ///
  /// <summary>
  /// Implementado Objeto Factory para o Model TACBrECFArquivosModel
  /// </summary>
  ///
  TACBrECFArquivosModel = class(TModelFactory, IACBrECFArquivosModel,
    IThisAs<TACBrECFArquivosModel>)
  protected
    FACBrECFArquivosBase: TACBrECFArquivos;
  public
    Constructor Create; override;
    Destructor Destroy; override;
    function Base: TACBrECFArquivos;
    class function new: IACBrECFArquivosModel; overload;
    class function new(const AController: IController)
      : IACBrECFArquivosModel; overload;
    function ThisAs: TACBrECFArquivosModel;
    procedure AfterInit; override;
    // Codigo para a ClassModel


    // metodos  <TACBrECFArquivos                                                                    //

    procedure SetObject(Index: Integer; Item: TACBrECFArquivo);

    procedure Insert(Index: Integer; Obj: TACBrECFArquivo);


    // functions  <TACBrECFArquivos                                                                    //

    function Add(Obj: TACBrECFArquivo): Integer; overload;

    function Add(Nome: String): Integer; overload;

  end;

implementation

/// Implementações
Constructor TACBrECFArquivosModel.Create;
begin
  inherited Create;
  FACBrECFArquivosBase := TMVCBr.InvokeCreate<TACBrECFArquivos>([nil]);
end;

function TACBrECFArquivosModel.Base: TACBrECFArquivos;
begin
  result := FACBrECFArquivosBase;
end;

Destructor TACBrECFArquivosModel.Destroy;
begin
  inherited;
end;

/// ThisAs Retorna o Object Factory do Model (instância)
function TACBrECFArquivosModel.ThisAs: TACBrECFArquivosModel;
begin
  result := self;
end;

/// Criar nova instância para o Model
class function TACBrECFArquivosModel.new: IACBrECFArquivosModel;
begin
  result := new(nil);
end;

procedure TACBrECFArquivosModel.AfterInit;
begin
  // executado apos concluido a carga do controller
end;

/// <summary>
/// New - cria nova instância para o Model
/// </summary>
/// <param name="AController">
/// É o controller ao qual o Model esta associado
/// </param>
/// <returns>
/// retorna a interface
/// </returns>
class function TACBrECFArquivosModel.new(const AController: IController)
  : IACBrECFArquivosModel;
begin
  result := TACBrECFArquivosModel.Create;
  result.Controller(AController);
end;

procedure TACBrECFArquivosModel.SetObject(Index: Integer;
  Item: TACBrECFArquivo);
begin
  Base.SetObject(Index, Item);
end;

procedure TACBrECFArquivosModel.Insert(Index: Integer; Obj: TACBrECFArquivo);
begin
  Base.Insert(Index, Obj);
end;

function TACBrECFArquivosModel.Add(Obj: TACBrECFArquivo): Integer;
begin
  result := Base.Add(Obj);
end;

function TACBrECFArquivosModel.Add(Nome: String): Integer;
begin
  result := Base.Add(Nome);
end;

Initialization

TMVCRegister.RegisterType<IACBrECFArquivosModel, TACBrECFArquivosModel>
  (TACBrECFArquivosModel.classname, true);

end.
