{ *************************************************************************** }
{ }
{ Projeto MVCBr }
{ Coder: Ivan Cesar }
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
{
  Objetivo: base para utilizar em conjunto com um Dataset para capturar as alterações em um DeltaJSON

  Marcações:
  +  adicionado recurso
  -  retirado
  *  alteração
  =  nao ocorreu mudança que interfira relacionamento codigo anterior.

  Alterações:
  23/03/2017 + procedure SetApplyUpdateDelegate( const AProc:TProc ); por: amarildo lacerda

}
{ *************************************************************************** }

unit MVCBr.ODataFDMemTable;

interface

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  MVCBr.Common,
  MVCBr.ODataDataSet.Common;

type
  TODataFDMemTable = class(TFDMemTable, IODataDataSet)
  protected
    procedure DoBeforeDelete; override;
    procedure DoBeforePost; override;
    procedure DoBeforeApplyUpdates(Sender: TFDDataset);
    procedure DoBeforeOpen; override;
    procedure DoAfterOpen; override;

  private
    FLoading: boolean;
    FChanges: TJSONArray;
    FKeyFields: string;
    FUpdateTable: string;
    FApplyDelegate: TProc<TDataset>;
    procedure SetKeyFields(const AValue: string);
    procedure SetUpdateTable(const AValue: string);
    function GetChanges: TJSONArray;
    function GetKeyFields: string;
    function GetUpdateTable: string;
    procedure CheckKeyFields;
    procedure SetApplyUpdateDelegate(const AProc: TProc<TDataset>);
    procedure SetLoading(const Value: boolean);
    function GetLoading: boolean;

  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Property Loading: boolean read FLoading write SetLoading;
    function ApplyDelegateTo(const AProc: TProc<TDataset>): TODataFDMemTable;
    function UpdatesPending: boolean;
    procedure ClearChanges;
    procedure CancelUpdates; reintroduce;
    procedure MergeChangeLog; reintroduce;
    property Changes: TJSONArray read GetChanges;
  published
    property KeyFields: string read GetKeyFields write SetKeyFields;
    property UpdateTable: string read GetUpdateTable write SetUpdateTable;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents(CMVCBrComponentPalletName, [TODataFDMemTable]);
end;

{ TODataFDMemTable }

constructor TODataFDMemTable.Create(AOwner: TComponent);
begin
  inherited;
  FLoading := false;
  FChanges := TJSONArray.Create;
  BeforeApplyUpdates := DoBeforeApplyUpdates;
end;

destructor TODataFDMemTable.Destroy;
var
  i: integer;
begin
  FChanges.free;//DisposeOf;
  inherited;
end;

procedure TODataFDMemTable.DoAfterOpen;
begin
  inherited;
  FLoading := false;
end;

procedure TODataFDMemTable.DoBeforeApplyUpdates(Sender: TFDDataset);
begin
  if not FLoading then
    if assigned(FApplyDelegate) then
      FApplyDelegate(Sender);
end;

procedure TODataFDMemTable.DoBeforeDelete;
begin
  inherited;
  if not FLoading then
  begin
    CheckKeyFields;
    FChanges.AddElement(DeletedDataRowToJsonObject(Self, FKeyFields));
  end;
end;

procedure TODataFDMemTable.DoBeforeOpen;
begin
  inherited;
  FLoading := true;
end;

procedure TODataFDMemTable.DoBeforePost;
begin
  inherited;
  if not FLoading then
  begin
    CheckKeyFields;
    FChanges.AddElement(ModifiedDataRowToJsonObject(Self, FKeyFields));
  end;
end;

function TODataFDMemTable.ApplyDelegateTo(const AProc: TProc<TDataset>)
  : TODataFDMemTable;
begin
  result := Self;
  SetApplyUpdateDelegate(AProc);
end;

procedure TODataFDMemTable.CancelUpdates;
begin
  inherited;
  ClearChanges;
end;

procedure TODataFDMemTable.CheckKeyFields;
begin
  Assert(not FKeyFields.IsEmpty, 'KeyFields deve ser informado.' + sLineBreak);
end;

procedure TODataFDMemTable.ClearChanges;
begin
  while FChanges.count > 0 do
    FChanges.Remove(0);
end;

function TODataFDMemTable.GetChanges: TJSONArray;
begin
  result := FChanges;
end;

function TODataFDMemTable.GetKeyFields: string;
begin
  result := FKeyFields;
end;

function TODataFDMemTable.GetLoading: boolean;
begin
  result := FLoading;
end;

function TODataFDMemTable.GetUpdateTable: string;
begin
  result := FUpdateTable;
end;

procedure TODataFDMemTable.MergeChangeLog;
begin
  inherited;
  ClearChanges;
end;

procedure TODataFDMemTable.SetApplyUpdateDelegate(const AProc: TProc<TDataset>);
begin
  FApplyDelegate := AProc;
end;

procedure TODataFDMemTable.SetKeyFields(const AValue: string);
begin
  FKeyFields := AValue.Trim;
end;

procedure TODataFDMemTable.SetLoading(const Value: boolean);
begin
  FLoading := Value;
end;

procedure TODataFDMemTable.SetUpdateTable(const AValue: string);
begin
  FUpdateTable := AValue.Trim;
end;

function TODataFDMemTable.UpdatesPending: boolean;
begin
  result := FChanges.count > 0;
end;

end.
