{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 29/08/2017 22:42:33                                  // }
{ //************************************************************// }

Unit LiveORM.Model;

/// <summary>
/// ORMBrClientesModel; Create by Template MVCBrORMBrFBModel
/// Dependencies:  FireDAC, MVCBr and ORMBr
/// </summary>
/// <auth> amarildo lacerda, MVCBr </auth>
interface

uses System.Classes, System.SysUtils,
  System.Json, System.RTTI,
  {MVCBr}
  MVCBr.Interf, MVCBr.OrmModel, MVCBr.Controller,
  {Firedac}
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client,
  {ORMBr}
  OrmBr.Factory.FireDAC,
  // OrmBr.types.database,
  OrmBr.Container.fdmemtable,
  OrmBr.Container.dataset.interfaces,
  OrmBr.Factory.interfaces,
  OrmBr.DML.generator.Firebird,
  OrmBr.Container.objectset.interfaces,
  OrmBr.Container.objectset,
  OrmBr.Criteria,
  OrmBr.Criteria.ResultSet,
  {Local ORMBr Model}
  OrmBr.Model.Clientes;

type
  TClientesModel = class;

  /// <summary> Interface Model for FB Model </summary>
  IClientesModel = interface(IModel)

    function This: TClientesModel;
  end;

  IClientes = IContainerDataset<TClientes>;

  /// <summary>   Implements Interface Model for FB</summary>
  TClientesModel = class(TOrmModelFactory, IClientesModel)
  private
    FConnection: IDBConnection;
    function GetBuscarCidade(AWhere: string): IDBResultSet;
  protected
    FClientes: IClientes; // FClientes: IContainerObjectSet<TClientes>;
  public
    procedure CreateDependencies; virtual;
    constructor Create(AController: IController; AConnection: TFDConnection);
    class function New(AController: IController; AConnection: TFDConnection)
      : IClientesModel;
    destructor Destroy; override;
    function This: TClientesModel;
    procedure Release; override;
    function GetMemDataset<T: Class, Constructor>(AMemDataset: TFdMemTable)
      : IContainerDataset<T>;
    function GetObjectSet<T: Class, Constructor>: IContainerObjectSet<T>;
    function GetClientes(AMemTable: TFdMemTable): IClientes;
  end;

Implementation

/// Usando Criteria
function TClientesModel.GetBuscarCidade(AWhere: string): IDBResultSet;
begin
  result := TCriteria.New.SetConnection(FConnection)
    .SQL(CreateCriteria.Select.All.From('BuscarCidade').Where(AWhere).AsString)
    .AsResultSet;
end;

procedure TClientesModel.CreateDependencies;
begin
  // FClientes:= TContainerObjectSet<TClientes>.Create(FConnection);
  /// put here yours dependencies and init vars
end;

function TClientesModel.GetClientes(AMemTable: TFdMemTable): IClientes;
begin
  if assigned(AMemTable) then
    if not assigned(FClientes) then
      FClientes := GetMemDataset<TClientes>(AMemTable);
  result := FClientes;
end;

constructor TClientesModel.Create(AController: IController;
  AConnection: TFDConnection);
begin
  inherited Create;
  SetController(AController);
  if assigned(AConnection) then
    FConnection := TFactoryFiredac.Create(AConnection, dnFirebird);
  CreateDependencies;
end;

/// <summary>Class Function NEW to create new instance for interfaced object</summary>
/// <param name="AController">IController implementation</param>
/// <param name="AConnection">Instance of FireDAC FDConnections</param>
class function TClientesModel.New(AController: IController;
  AConnection: TFDConnection): IClientesModel;
begin
  result := TClientesModel.Create(AController, AConnection);
end;

/// <summary>Release to free internal vars</summary>
procedure TClientesModel.Release;
begin
  FConnection := nil;
  inherited;
end;

destructor TClientesModel.Destroy;
begin
  Release;
  inherited;
end;

function TClientesModel.This: TClientesModel;
begin
  result := self;
end;

function TClientesModel.GetMemDataset<T>(AMemDataset: TFdMemTable)
  : IContainerDataset<T>;
begin
  result := TContainerFDMemTable<T>.Create(FConnection, AMemDataset);
end;

function TClientesModel.GetObjectSet<T>: IContainerObjectSet<T>;
begin
  result := TContainerObjectSet<T>.Create(FConnection);
end;

end.
