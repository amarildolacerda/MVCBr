{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br                                // }
{ //************************************************************// }
{ // Data: 09/02/2017 20:39:40                                  // }
{ //************************************************************// }
unit RexSauro.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
{ .$I ..\inc\mvcbr.inc }
interface

uses Classes, forms, SysUtils, MVCBr.Interf, MVCBr.Model,
  ClasseDino,
  RexSauro.Model.Interf, MVCBr.Controller;

type
  TRexSauroModel = class(TModelFactory, IRexSauroModel, IThisAs<TRexSauroModel>)
  protected
    FRexSauroBase: TRexSauro;
  public
    Constructor Create; override;
    Destructor Destroy; override;
    function Base: TRexSauro;
    class function new: IRexSauroModel; overload;
    class function new(const AController: IController): IRexSauroModel;
      overload;
    function ThisAs: TRexSauroModel;
    procedure AfterInit; override;
    // Codigo para a ClassModel
    // metodos  <TRexSauro                                                                    //
    procedure execute();
    procedure Execute2(const A: integer; texto: string);
    procedure Execute3(const A: integer; texto: string);
    // functions  <TRexSauro                                                                    //
    function GetTexto(): string;
    function GetItem(item: integer): string;
  end;

implementation

Constructor TRexSauroModel.Create;
begin
  inherited Create;
  FRexSauroBase := TMVCBr.InvokeCreate<TRexSauro>([nil]);
end;

function TRexSauroModel.Base: TRexSauro;
begin
  result := FRexSauroBase;
end;

Destructor TRexSauroModel.Destroy;
begin
  inherited;
end;

function TRexSauroModel.ThisAs: TRexSauroModel;
begin
  result := self;
end;

class function TRexSauroModel.new: IRexSauroModel;
begin
  result := new(nil);
end;

procedure TRexSauroModel.AfterInit;
begin
  // executado apos concluido o controller
end;

class function TRexSauroModel.new(const AController: IController)
  : IRexSauroModel;
begin
  result := TRexSauroModel.Create;
  result.Controller(AController);
end;

procedure TRexSauroModel.execute();
begin
  Base.execute();
end;

procedure TRexSauroModel.Execute2(const A: integer; texto: string);
begin
  Base.Execute2(A, texto);
end;

procedure TRexSauroModel.Execute3(const A: integer; texto: string);
begin
  Base.Execute3(A, texto);
end;

function TRexSauroModel.GetTexto(): string;
begin
  result := Base.GetTexto();;
end;

function TRexSauroModel.GetItem(item: integer): string;
begin
  result := Base.GetItem(item);;
end;

end.
