{ *************************************************************************** }
{ }
{ Projeto MVCBr }
{ Coder: amarildo lacerda }
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
  Créditos: Ivan Cesar - fornecendo o Dataset com DeltaJSON
}
{ *************************************************************************** }

unit MVCBr.ODataDatasetBuilder;

interface

uses system.Classes, system.SysUtils, Data.db,
  oData.Comp.Client, MVCBr.idHTTPRestClient,
  MVCBr.ODataDatasetAdapter;

type

  TODataDatasetBuilder = class(TODataBuilder)
  private
    FState: TDataSetState;
    FOldAfterOpen: TDatasetNotifyEvent;
    FOldBeforePost: TDatasetNotifyEvent;
    FOldAfterPost: TDatasetNotifyEvent;
    FOldBeforeDelete: TDatasetNotifyEvent;
    FRestClient: TIdHTTPRestClient;
    FDataset: TDataset;
    FAdapter: TODataDatasetAdapter;
  protected
    procedure SetDataset(const Value: TDataset); virtual;
    procedure SetRestClient(const Value: TIdHTTPRestClient); virtual;
    procedure SetAdapter(const Value: TODataDatasetAdapter); virtual;
    procedure ClearChanges; virtual;
    procedure DoAfterOpen(sender: TDataset); virtual;
    procedure DoBeforePost(sender: TDataset); virtual;
    procedure DoAfterPost(sender: TDataset); virtual;
    procedure DoBeforeDelete(sender: TDataset); virtual;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;

  public
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
    procedure ApplyUpdates(); virtual;
    property RestClient: TIdHTTPRestClient read FRestClient write SetRestClient;
    property Adapter: TODataDatasetAdapter read FAdapter write SetAdapter;
    function Execute: Boolean; override;
    function Builder:TODataBuilder;virtual;
  published
    property Dataset: TDataset read FDataset write SetDataset;
  end;

implementation

uses MVCBr.Common, MVCBr.ODataDataSet.Common;

{ TODataClient }

procedure TODataDatasetBuilder.ApplyUpdates();
var
  o: IODataDataSet;
begin
  if supports(FDataset, IODataDataSet, o) then
  begin
    if FAdapter.Builder.ApplyUpdates(o.Changes) then
      ClearChanges;
  end
  else
  begin
    FAdapter.ApplyUpdates();
    ClearChanges;
  end;
end;

function TODataDatasetBuilder.Builder: TODataBuilder;
begin
 if assigned(FAdapter) and assigned(FAdapter.Builder) then
    result := FAdapter.Builder;
end;

procedure TODataDatasetBuilder.ClearChanges;
var
  o: IODataDataSet;
begin
  if supports(FDataset, IODataDataSet, o) then
  begin
    o.ClearChanges;
  end
  else
    FAdapter.ClearChanges;
end;

constructor TODataDatasetBuilder.create(AOwner: TComponent);
begin
  inherited;
  FAdapter := TODataDatasetAdapter.create(self);
  FAdapter.RootElement := 'value';
  FAdapter.Builder := self; // TODataBuilder.create(FAdapter);
  RestClient := TIdHTTPRestClient.create(self);
  with RestClient do
  begin
    AcceptCharset := 'UTF-8';
    Accept := 'application/json; odata.metadata=minimal';
    AcceptEncoding := 'gzip';
  end;
end;

destructor TODataDatasetBuilder.destroy;
begin
  FAdapter.Builder := nil;
  FAdapter.Free;
  inherited;
end;

procedure TODataDatasetBuilder.DoAfterOpen(sender: TDataset);
begin
  if assigned(FOldAfterOpen) then
    FOldAfterOpen(sender);
  ClearChanges;
end;

procedure TODataDatasetBuilder.DoAfterPost(sender: TDataset);
var
  o: IODataDataSet;
begin
  if supports(FDataset, IODataDataSet, o) then
    // nao faz nada - controle é do component
  else if FState = dsInsert then
    FAdapter.AddRowSet(rctInserted, FDataset)
  else if FState = dsEdit then
    FAdapter.AddRowSet(rctModified, FDataset);
end;

procedure TODataDatasetBuilder.DoBeforeDelete(sender: TDataset);
var
  o: IODataDataSet;
begin
  if assigned(FOldBeforeDelete) then
    FOldBeforeDelete(sender);
  if supports(FDataset, IODataDataSet, o) then
    // nao faz nada - é responsabilidade do compoennt
  else
    FAdapter.AddRowSet(rctDeleted, FDataset);

end;

procedure TODataDatasetBuilder.DoBeforePost(sender: TDataset);
begin
  if assigned(FOldBeforePost) then
    FOldBeforePost(sender);
  FState := sender.State;
end;

function TODataDatasetBuilder.Execute: Boolean;
begin
  FAdapter.BeforeOpenDelegate(
    procedure(ds: TDataset)
    var
      o: IODataDataSet;
    begin
      if supports(ds, IODataDataSet, o) then
      begin
        o.KeyFields := FAdapter.ResourceKeys;
        o.UpdateTable := FAdapter.ResourceName;
      end;
    end);
  result := FAdapter.Execute;
  if result then
    ClearChanges;
end;

procedure TODataDatasetBuilder.Notification(AComponent: TComponent;
AOperation: TOperation);
begin
  if AOperation = TOperation.opRemove then
  begin
    if AComponent = FDataset then
      FDataset := nil;
    if AComponent = FRestClient then
      FRestClient := nil;
    if AComponent = FAdapter then
      FAdapter := nil;
  end;
  inherited;
end;

procedure TODataDatasetBuilder.SetAdapter(const Value: TODataDatasetAdapter);
begin
  FAdapter := Value;
end;

procedure TODataDatasetBuilder.SetDataset(const Value: TDataset);
var
  o: IODataDataSet;
begin
  if (FDataset <> nil) then
  begin
    FDataset.AfterOpen := FOldAfterOpen;
    FDataset.BeforePost := FOldBeforePost;
    FDataset.AfterPost := FOldAfterPost;
  end;
  FDataset := Value;
  if not assigned(Value) then
    exit;

  FOldAfterOpen := FDataset.AfterOpen;
  FDataset.AfterOpen := DoAfterOpen;

  FOldBeforePost := FDataset.BeforePost;
  FDataset.BeforePost := DoBeforePost;

  FOldAfterPost := FDataset.AfterPost;
  FDataset.AfterPost := DoAfterPost;

  FAdapter.Dataset := Value;

  if supports(Value, IODataDataSet, o) then
    o.SetApplyUpdateDelegate(
      procedure(sender: TDataset)
      begin
        ApplyUpdates;
      end);

end;

procedure TODataDatasetBuilder.SetRestClient(const Value: TIdHTTPRestClient);
begin
  FRestClient := Value;
  FAdapter.Builder.RestClient := Value;
  FAdapter.ResponseJSON := Value;
end;

end.
