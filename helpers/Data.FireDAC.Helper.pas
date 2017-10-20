unit Data.FireDAC.Helper;

interface

uses
  System.Classes, System.SysUtils,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB,
  Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Controls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type

  TFDQueryHelper = class helper for TFDQuery
  public
    procedure AsyncOpen(AProc: TProc = nil);
    function Clone(AOwner: TComponent): TFDQuery;
  end;

  TFDConnectionHelper = class helper for TFDCustomConnection
  public
    function Clone(AOwner: TComponent): TFDCustomConnection;
  end;

implementation

{ TFDQueryHelper }

procedure TFDQueryHelper.AsyncOpen(AProc: TProc);
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      System.TMonitor.Enter(self);
      try
        DisableControls;
        try
          resourceOptions.CmdExecMode := amNonBlocking;
          open;

          while command.state = TFDPhysCommandState.csExecuting do;
          TThread.Queue(nil,
            procedure
            begin
              if assigned(AProc) then
                AProc;
            end);

        finally
          TThread.Queue(nil,
            procedure
            begin
              EnableControls;
            end);
        end;
      finally
        System.TMonitor.Exit(self);
      end;
    end).start;
end;

function TFDQueryHelper.Clone(AOwner: TComponent): TFDQuery;
begin
  result := TFDQuery.create(AOwner);
  result.sql.Assign(self.sql);
  result.resourceOptions.Assign(self.resourceOptions);
  result.Aggregates.Assign(self.Aggregates);
  result.UpdateOptions.Assign(self.UpdateOptions);
  result.formatOptions.Assign(self.formatOptions);
  result.fieldOptions.Assign(self.fieldOptions);
  result.filter := self.filter;
  result.filtered := self.filtered;
  result.fetchOptions.assign(self.FetchOptions);
  if assigned(Connection) then
    result.Connection := Connection.Clone(result);
end;

{ TFDConnectionHelper }

function TFDConnectionHelper.Clone(AOwner: TComponent): TFDCustomConnection;
begin
  result := TFDConnection.create(AOwner);
  result.Assign(self);
  if connected then
    result.connected := true;
end;

end.
