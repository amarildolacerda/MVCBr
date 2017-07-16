// Unit de abstração de acesso a camada de banco de dados ligado a Data.DB
// Utilizar para fazer herança para os drivers de conexão
unit MVCBr.DatabaseModel.Interf;
{ *************************************************************************** }
{ }
{ MVCBr é o resultado de esforços de um grupo }
{ }
{ Copyright (C) 2017 MVCBr }
{ }
{ amarildo lacerda }
{ http://www.tireideletra.com.br }
{ }
{ }
{ *************************************************************************** }
{ }
{ Licensed under the Apache License, Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. }
{ You may obtain a copy of the License at }
{ }
{ http://www.apache.org/licenses/LICENSE-2.0 }
{ }
{ Unless required by applicable law or agreed to in writing, software }
{ distributed under the License is distributed on an "AS IS" BASIS, }
{ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{ See the License for the specific language governing permissions and }
{ limitations under the License. }
{ }
{ *************************************************************************** }

// Por: Amarildo Lacerda
// Historico:
//           + 29/01/2017 - Criada a primeira versao

interface

uses MVCBr.Interf, MVCBr.PersistentModel;

type

  TDatabaseModelAbstract = class;

  // IDatabaseModel Interface que implementa a conexao de persistencao ao banco de dados
  IDatabaseModel = interface(IPersistentModel)
    ['{26FC1185-D137-42B5-BA64-3D2D1D22E65F}']
    function This: TDatabaseModelAbstract;
    procedure SetConnectionString(const Value: string);
    function GetConnectionString: string;
    property ConnectionString:string read GetConnectionString write SetConnectionString;
  end;

  // IQueryModel<T> Interface para acesso a Query
  // onde  T é o tipo de objeto query assocado a interface
  IQueryModel<T> = interface
    ['{32E8A447-B035-4ABD-BA27-59017411E018}']
    // Tabela a selecionar
    function Table(Const ATable: string): IQueryModel<T>;
    // Colunas
    function Columns(const AColumns: string): IQueryModel<T>;
    // where
    function Where(Const AWhere: string): IQueryModel<T>;
    // Order by
    function OrderBy(Const AOrderBY: string): IQueryModel<T>;
    // Join
    function Join(const AJoin: string): IQueryModel<T>;
    // GroupBy
    function GroupBy(Const AGroup: string): IQueryModel<T>;

    // Retorna o MODEL associado ao query
    function GetModel: IDatabaseModel;
    // Atribui o MODEL associado
    procedure SetModel( const AModel:IDatabaseModel);
    // Retorna a instancia da Query associada
    function Query:T;
    // Operações com a Query

  end;


  TDatabaseModelAbstract = class(TPersistentModelFactory, IDatabaseModel)
  private
  protected
    FConnectionString: string;
    procedure SetConnectionString(const Value: string);virtual;
    function GetConnectionString: string;virtual;
  public
    // Na herança é necessario indicar o retorno para THIS
    function This: TDatabaseModelAbstract;reintroduce; overload;virtual;
    function GetConnection<T:Class>():T;
    property ConnectionString:string read GetConnectionString write SetConnectionString;
  end;

implementation

{ TDatabaseModelAbstract }

function TDatabaseModelAbstract.GetConnection<T>: T;
begin
   Result := T(Self);
end;

function TDatabaseModelAbstract.GetConnectionString: string;
begin
  result := FConnectionString;
end;

procedure TDatabaseModelAbstract.SetConnectionString(const Value: string);
begin
  FConnectionString := Value;
end;

function TDatabaseModelAbstract.This: TDatabaseModelAbstract;
begin
  result := nil;
end;


end.

