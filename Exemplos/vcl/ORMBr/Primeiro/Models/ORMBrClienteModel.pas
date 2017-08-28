unit ORMBrClienteModel;

/// <summary>
/// ORMBrClientesFactoryModel; Create by Template MVCBrORMBrFBModel
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
  TClientesFactoryModel = class;

  /// <summary> Interface Model for FB Model </summary>
  IClientesFactoryModel = interface(IModel)

    function This: TClientesFactoryModel;
  end;

  IClientes = IContainerDataset<TClientes>;

  /// <summary>   Implements Interface Model for FB</summary>
  TClientesFactoryModel = class(TOrmModelFactory, IClientesFactoryModel)
  private
    FConnection: IDBConnection;
    function ValidateEstadoExiste(AValue: String): boolean;
    function GetProdutos(AWhere: string): IDBResultSet;
  protected
    FClientes: IClientes; // FClientes: IContainerObjectSet<TClientes>;
  public
    procedure CreateDependencies; virtual;
    constructor Create(AController: IController; AConnection: TFDConnection);
    class function New(AController: IController; AConnection: TFDConnection)
      : IClientesFactoryModel;
    destructor Destroy; override;
    function This: TClientesFactoryModel;
    procedure Release; override;
    function GetMemDataset<T: Class, Constructor>(AMemDataset: TFdMemTable)
      : IContainerDataset<T>;
    function GetObjectSet<T: Class, Constructor>: IContainerObjectSet<T>;
    function GetClientes(AMemTable: TFdMemTable): IClientes;
  end;

Implementation

procedure TClientesFactoryModel.CreateDependencies;
begin
  // FClientes:= TContainerObjectSet<TClientes>.Create(FConnection);
  /// put here yours dependencies and init vars
end;

function TClientesFactoryModel.GetClientes(AMemTable: TFdMemTable): IClientes;
begin
  if assigned(AMemTable) then
    if not assigned(FClientes) then
      FClientes := GetMemDataset<TClientes>(AMemTable);
  result := FClientes;
end;

constructor TClientesFactoryModel.Create(AController: IController;
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
class function TClientesFactoryModel.New(AController: IController;
  AConnection: TFDConnection): IClientesFactoryModel;
begin
  result := TClientesFactoryModel.Create(AController, AConnection);
end;

/// <summary>Release to free internal vars</summary>
procedure TClientesFactoryModel.Release;
begin
  FConnection := nil;
  inherited;
end;

destructor TClientesFactoryModel.Destroy;
begin
  Release;
  inherited;
end;

function TClientesFactoryModel.This: TClientesFactoryModel;
begin
  result := self;
end;

function TClientesFactoryModel.GetMemDataset<T>(AMemDataset: TFdMemTable)
  : IContainerDataset<T>;
begin
  result := TContainerFDMemTable<T>.Create(FConnection, AMemDataset);
end;

function TClientesFactoryModel.GetObjectSet<T>: IContainerObjectSet<T>;
begin
  result := TContainerObjectSet<T>.Create(FConnection);
end;

/// Validacao usando Criteria
function TClientesFactoryModel.ValidateEstadoExiste(AValue: String): boolean;
var
  LValidarSet: IDBResultSet;
begin
  LValidarSet := TCriteria.New.SetConnection(FConnection)
    .SQL(CreateCriteria.Select.All.From('estados').First(1)
    .Where('nome=' + quotedstr(AValue)).AsString).AsResultSet;
  result := LValidarSet.RecordCount > 0;
end;

/// Usando Criteria
function TClientesFactoryModel.GetProdutos(AWhere: string): IDBResultSet;
begin
  result := TCriteria.New.SetConnection(FConnection)
    .SQL(CreateCriteria.Select.All.From('Produtos').Where(AWhere).AsString)
    .AsResultSet;
end;

end.
