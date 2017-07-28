unit MVCBr.DatabaseModel;
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


interface

uses System.Classes, System.SysUtils, MVCBr.Interf, MVCBr.DatabaseModel.Interf,
  Data.DB,
  MVCBr.PersistentModel;

type

  IDatabaseModel = MVCBr.DatabaseModel.Interf.IDatabaseModel;

  // TQueryModelFactory<T: Class> É o construtor de Query
  // Generic:   T:Class É a classe decendente de TDataset ligado ao framework utilizado
  TQueryModelFactory<T: Class> = class(TInterfacedObject, IQueryModel<T>)
  private
    FChangeProc: TProc<T>;
    FQuery: T;
    FDatabaseModel: IDatabaseModel;
    FColumns: String;
    FTable: string;
    FWhere: String;
    FOrderBy: String;
    FJoin: string;
    FGroupBy: string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function This: TQueryModelFactory<T>;
    function Query:T;
    procedure DoChange; virtual;
    class Function New(ADatabaseModel: IDatabaseModel; AChangeProc: TProc<T>)
      : TQueryModelFactory<T>;
    function Table(Const ATable: string): IQueryModel<T>;
    function Where(Const AWhere: string): IQueryModel<T>;
    function OrderBy(Const AOrderBY: string): IQueryModel<T>;
    function Join(const AJoin: string): IQueryModel<T>;
    function GroupBy(Const AGroup: string): IQueryModel<T>;
    function Columns(const AColumns: string): IQueryModel<T>;
    function GetModel: IDatabaseModel;
    procedure SetModel(const AModel: IDatabaseModel);
    function sql: string;
    function Dataset: TDataset;
  end;

  // Classe base para implementação de acesso a banco de dados
  // Onde     T: representa a classe de conexão
  // Q: a classe de query (TDataset type)
  TDatabaseModelFactory<T: class; Q: Class> = class(TDatabaseModelAbstract,
    IDatabaseModel)
  protected
    FOwner:TComponent;
    FConnection: T;
  public
    function GetOwned:TComponent;
    constructor Create(); override;
    destructor Destroy; override;
    // retorna interface base
    function ThisIntf: IDatabaseModel;
    // retorna o modelo abstract de herança para a classe
    function This: TDatabaseModelFactory<T, Q>; reintroduce; overload;
    // retorna a conexão ativa
    function GetConnection: T;
    // Seta a conexão ativa
    function Connection(const AConnection: T)
      : TDatabaseModelFactory<T, Q>; virtual;
    // inicializa nova Query
    // Params: AProcChange é chamada toda vez que um dado da query é alterada
    function NewQuery(const AProcChange: TProc<Q>): IQueryModel<Q>; virtual;
  end;

implementation

uses System.RTTI;

{ TQueryModelFactory }

function TQueryModelFactory<T>.Columns(const AColumns: string): IQueryModel<T>;
begin
  FColumns := AColumns;
  DoChange;
end;

constructor TQueryModelFactory<T>.create;
var
  ctx: TRTTIContext;
begin
  inherited create;
  FColumns := '*';
  FQuery := TMVCBr.InvokeCreate<T>([nil]);

  if Assigned(FQuery) then
    if not TObject(FQuery).InheritsFrom(TDataset) then
      raise Exception.create('O tipo de classe não é uma herança de TDataset');

end;

function TQueryModelFactory<T>.Dataset: TDataset;
begin
  result := TDataset(FQuery);
end;

destructor TQueryModelFactory<T>.destroy;
begin
  if Assigned(FQuery) then
    TObject(FQuery).DisposeOf;
  inherited;
end;

procedure TQueryModelFactory<T>.DoChange;
begin
  if Assigned(FChangeProc) then
    FChangeProc(FQuery);

end;

function TQueryModelFactory<T>.GetModel: IDatabaseModel;
begin
  result := FDatabaseModel;
end;

function TQueryModelFactory<T>.GroupBy(const AGroup: string): IQueryModel<T>;
begin
  result := self;
  FGroupBy := FGroupBy;
  DoChange;

end;

function TQueryModelFactory<T>.Join(const AJoin: string): IQueryModel<T>;
begin
  result := self;
  FJoin := AJoin;
  DoChange;
end;

class function TQueryModelFactory<T>.New(ADatabaseModel: IDatabaseModel;
  AChangeProc: TProc<T>): TQueryModelFactory<T>;
begin
  result := TQueryModelFactory<T>.create();
  result.FDatabaseModel := ADatabaseModel;
  result.FChangeProc := AChangeProc;
end;

function TQueryModelFactory<T>.OrderBy(const AOrderBY: string): IQueryModel<T>;
begin
  result := self;
  FOrderBy := AOrderBY;
  DoChange;
end;

function TQueryModelFactory<T>.Query: T;
begin
  result := FQuery;
end;

procedure TQueryModelFactory<T>.SetModel(const AModel: IDatabaseModel);
begin
  FDatabaseModel := AModel;
end;

function TQueryModelFactory<T>.sql: string;
begin
  result := 'select ' + FColumns + ' from ' + FTable;
  if FJoin <> '' then
    result := result + ' ' + FJoin;
  if FWhere <> '' then
    result := result + ' ' + FWhere;
  if FGroupBy <> '' then
    result := result + ' ' + FGroupBy;
  if FOrderBy <> '' then
    result := result + ' ' + FOrderBy;

end;

function TQueryModelFactory<T>.Table(const ATable: string): IQueryModel<T>;
begin
  result := self;
  FTable := ATable;
  DoChange;
end;

function TQueryModelFactory<T>.This: TQueryModelFactory<T>;
begin
  result := self;
end;

function TQueryModelFactory<T>.Where(const AWhere: string): IQueryModel<T>;
begin
  result := self;
  FWhere := AWhere;
  DoChange;
end;

{ TDatabaseModelFactory<T> }

function TDatabaseModelFactory<T, Q>.Connection(const AConnection: T)
  : TDatabaseModelFactory<T, Q>;
begin
  result := self;
  if FConnection = AConnection then

  FConnection := AConnection;
end;

constructor TDatabaseModelFactory<T, Q>.create;
begin
  inherited;
  FConnection := TMVCBr.InvokeCreate<T>([ GetOwned ]);
end;

destructor TDatabaseModelFactory<T, Q>.destroy;
begin
  inherited;
end;

function TDatabaseModelFactory<T, Q>.GetConnection: T;
begin
  result := FConnection;
end;

function TDatabaseModelFactory<T, Q>.GetOwned: TComponent;
begin
   result := FOwner;
end;

function TDatabaseModelFactory<T, Q>.NewQuery(const AProcChange: TProc<Q>)
  : IQueryModel<Q>;
var
  Intf: IDatabaseModel;
  obj: TQueryModelFactory<Q>;
begin
  Intf := self;
  obj := TQueryModelFactory<Q>.New(ThisIntf, AProcChange);
  obj.SetModel(Intf);
  result := obj;
end;

function TDatabaseModelFactory<T, Q>.This: TDatabaseModelFactory<T, Q>;
begin
  result := self;
end;

function TDatabaseModelFactory<T, Q>.ThisIntf: IDatabaseModel;
begin
  result := self;
end;

end.
