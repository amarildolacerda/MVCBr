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
{
  Alterações:
  16/04/2017 - por amarildo lacerda
  . + Params;
  . + OnGetParams evento;
  . + Criar Params com base no Filter
}

unit MVCBr.ODataDatasetBuilder;

interface

uses system.Classes, system.SysUtils, Data.db,
  oData.Comp.Client,
  MVCBr.HTTPRestClient.Common,
  MVCBr.HTTPRestClient,
  MVCBr.ODataDatasetAdapter;

type

  TODataDatasetBuilder = class(TODataCustomBuilder)
  private
    FRef: Integer;
    FState: TDataSetState;
    FOldBeforeOpen: TDatasetNotifyEvent;
    FOldAfterOpen: TDatasetNotifyEvent;
    FOldBeforePost: TDatasetNotifyEvent;
    FOldAfterPost: TDatasetNotifyEvent;
    FOldBeforeDelete: TDatasetNotifyEvent;
    FRestClient: TMVCBrHttpRestClientAbstract;
    FDataset: TDataset;
    FAdapter: TODataDatasetAdapter;
    FOnGetParams: TODataGetResourceParams;
    procedure SetOnGetParams(const Value: TODataGetResourceParams);
    function GetParams: TParams;
    procedure setParams(const Value: TParams);
  protected
    procedure SetFilter(const Value: string); override;

    procedure SetDataset(const Value: TDataset); virtual;
    procedure SetRestClient(const Value: TMVCBrHttpRestClientAbstract); virtual;
    procedure SetAdapter(const Value: TODataDatasetAdapter); virtual;
    procedure ClearChanges; virtual;
    procedure DoBeforeOpen(sender: TDataset); virtual;
    procedure DoAfterOpen(sender: TDataset); virtual;
    procedure DoBeforePost(sender: TDataset); virtual;
    procedure DoAfterPost(sender: TDataset); virtual;
    procedure DoBeforeDelete(sender: TDataset); virtual;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;

  public
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
    procedure ApplyUpdates(); virtual;
    property RestClient: TMVCBrHttpRestClientAbstract read FRestClient write SetRestClient;
    property Adapter: TODataDatasetAdapter read FAdapter write SetAdapter;
    function Execute: Boolean; override;
    function Builder: TODataCustomBuilder; virtual;
  published
    property Dataset: TDataset read FDataset write SetDataset;
    property Params: TParams read GetParams write setParams;
    property OnGetParams: TODataGetResourceParams read FOnGetParams write SetOnGetParams;
    property URI;
    property BaseURL;
    property ServicePrefix;
    property Service;
    property ResourceName;
    property Resource;
    property &Select;
    property &Filter;
    property &TopRows;
    property &SkipRows;
    property &Count;
    property &Expand;
    property &Order;
    property OnBeforeApplyUpdates;
    property OnAfterApplyUpdates;
    property BeforeExecute;
    property AfterExecute;

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
    o := nil;
  end
  else
  begin
    FAdapter.ApplyUpdates();
    ClearChanges;
  end;
end;

function TODataDatasetBuilder.Builder: TODataCustomBuilder;
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
    o := nil;
  end
  else
    FAdapter.ClearChanges;
end;

constructor TODataDatasetBuilder.create(AOwner: TComponent);
begin
  inherited;
  FRef := 0;
  FAdapter := TODataDatasetAdapter.create(self);
  FAdapter.RootElement := 'value';
  FAdapter.Builder := self; // TODataBuilder.create(FAdapter);
  SetRestClient( TMVCBrHttpRestClientAbstract(THTTPRestClient.create(self) ) );
  with RestClient do
  begin
    AcceptCharset := 'UTF-8';
    Accept := 'application/json';
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
begin
  if supports(FDataset, IODataDataSet) then
    // nao faz nada - controle é do component
  else if FState = dsInsert then
    FAdapter.AddRowSet(rctInserted, FDataset)
  else if FState = dsEdit then
    FAdapter.AddRowSet(rctModified, FDataset);
end;

procedure TODataDatasetBuilder.DoBeforeDelete(sender: TDataset);
begin
  if assigned(FOldBeforeDelete) then
    FOldBeforeDelete(sender);
  if supports(FDataset, IODataDataSet) then
    // nao faz nada - é responsabilidade do compoennt
  else
    FAdapter.AddRowSet(rctDeleted, FDataset);

end;

procedure TODataDatasetBuilder.DoBeforeOpen(sender: TDataset);
begin
  if assigned(FOldBeforeOpen) then
    FOldBeforeOpen(sender);
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
        o := nil;
      end;
    end);
  inc(FRef);
  try
    FAdapter.Builder := self;
    FAdapter.OnGetParams := FOnGetParams;
    result := FAdapter.Execute;
  finally
    dec(FRef);
  end;
  if result then
    ClearChanges;
end;

function TODataDatasetBuilder.GetParams: TParams;
begin
  if assigned(FAdapter) then
    result := FAdapter.Params;
end;

procedure TODataDatasetBuilder.Notification(AComponent: TComponent; AOperation: TOperation);
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
    FDataset.BeforeOpen := FOldBeforeOpen;
  end;
  FDataset := Value;
  if not assigned(Value) then
    exit;

  FOldBeforeOpen := FDataset.BeforeOpen;
  FDataset.BeforeOpen := DoBeforeOpen;

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

procedure TODataDatasetBuilder.SetFilter(const Value: string);
var
  rst: String;
  p: string;
  n: Integer;
  prms: TParams;
begin
  inherited;
  prms := Params;
  if not assigned(prms) then
    exit;
  /// criar os parametros;
  rst := Value;
  repeat
    n := rst.IndexOf('{');
    if n < 0 then
      exit;
    rst := rst.Remove(0, n + 1);
    n := rst.IndexOf('}');
    p := rst.Substring(0, n);
    if prms.FindParam(p) = nil then
      with prms.AddParameter do
      begin
        Name := p;
        DataType := ftstring;
      end;
  until rst = '';
end;

procedure TODataDatasetBuilder.SetOnGetParams(const Value: TODataGetResourceParams);
begin
  FOnGetParams := Value;
end;

procedure TODataDatasetBuilder.setParams(const Value: TParams);
begin
  if assigned(FAdapter) then
    FAdapter.Params := Value;
end;

procedure TODataDatasetBuilder.SetRestClient(const Value: TMVCBrHttpRestClientAbstract);
begin
  FRestClient := Value;
  FAdapter.Builder.RestClient := Value;
  FAdapter.ResponseJSON := Value;
end;

end.
