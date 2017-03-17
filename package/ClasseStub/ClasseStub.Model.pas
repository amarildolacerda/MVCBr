{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/02/2017 22:22:58                                  // }
{ //************************************************************// }
unit ClasseStub.Model;

///
/// <summary>
/// Model para implementar regras de negócio
/// </summary>
///
{ .$I ..\inc\mvcbr.inc }
interface

uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  uClasseStub,
  ClasseStub.Model.Interf, MVCBr.Controller;

type
  ///
  /// <summary>
  /// Implementado Objeto Factory para o Model TClasseStubModel
  /// </summary>
  ///
  TClasseStubModel = class(TModelFactory, IClasseStubModel,
    IThisAs<TClasseStubModel>)
  protected
    FClasseStubBase: TClasseStub<Iunknown,TObject>;
  public
    Constructor Create; override;
    Destructor Destroy; override;
    function Base: TClasseStub<Iunknown,TObject>;
    class function new: IClasseStubModel; overload;
    class function new(const AController: IController)
      : IClasseStubModel; overload;
    function ThisAs: TClasseStubModel;
    procedure AfterInit; override;
    // Codigo para a ClassModel
    // metodos  <TClasseStub<TInterface; T: Class>                                                                    //
    // functions  <TClasseStub<TInterface; T: Class>                                                                    //
    function GetCaption(): String;
  end;

implementation

/// Implementações
Constructor TClasseStubModel.Create;
begin
  inherited Create;
end;

function TClasseStubModel.Base: TClasseStub<TInterface; T: Class>;
begin
  result := FClasseStub<TInterface; T: Class>
  Base;
end;

Destructor TClasseStubModel.Destroy;
begin
  inherited;
end;

/// ThisAs Retorna o Object Factory do Model (instância)
function TClasseStubModel.ThisAs: TClasseStubModel;
begin
  result := self;
end;

/// Criar nova instância para o Model
class function TClasseStubModel.new: IClasseStubModel;
begin
  result := new(nil);
end;

procedure TClasseStubModel.AfterInit;
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
class function TClasseStubModel.new(const AController: IController)
  : IClasseStubModel;
begin
  result := TClasseStubModel.Create;
  result.Controller(AController);
end;

function TClasseStubModel<TInterface, T>.GetCaption(): <;
begin
  result := Base.GetCaption<TInterface, T>();
end;

Initialization

TMVCRegister.RegisterType<IClasseStubModel, TClasseStubModel>
  (TClasseStubModel.classname, true);

end.
