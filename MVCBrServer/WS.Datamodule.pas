{ //************************************************************// }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017                                           // }
{ //************************************************************// }
unit WS.Datamodule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Phys, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL,
{$IFDEF LINUX}
  FireDAC.CONSOLEUI.Wait,
{$ELSE}
  FireDAC.VCLUI.Wait,
  FireDAC.Phys.MSAcc,
  FireDAC.Phys.MSAccDef,
  FireDAC.Comp.UI,
{$ENDIF}
  FireDAC.DApt, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Comp.Client,
  FireDAC.Phys.IBBase, Data.DB, FireDAC.Phys.PGDef, FireDAC.Phys.PG,
  FireDAC.Phys.OracleDef, FireDAC.Phys.Oracle;

type
  TWSDatamodule = class(TDataModule)
    procedure FDManager1AfterLoadConnectionDefFile(Sender: TObject);
  private
    { Private declarations }
    procedure AfterConstruction; override;
  public
    { Public declarations }
  end;

  TFDQueryAuto = class(TFDQuery)
  public
    constructor create(AOwner: TComponent); override;
  end;

  TFDStoredProcAuto = class(TFDStoredProc)
  public
    constructor create(AOwner: TComponent); override;

  end;

procedure RegisterAutoLoadResource;

var
  WSDatamodule: TWSDatamodule;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }
// uses FireDAC.Adpt;
uses oData.ServiceModel, System.JSON, System.SyncObjs, WS.Common;

{$R *.dfm}

var
  FContainer: TComponent;
  // ConnectionStrings: string;
{$IFDEF LINUX}
{$ELSE}
  FDGUIxWaitCursor1: TFDGUIxWaitCursor;
{$ENDIF}
  // FDConnection1: TFDConnection;
  FDPhysFBDriverLink1: TFDPhysFBDriverLink;
  // FDSchemaAdapter1: TFDSchemaAdapter;
  FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
  FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
  FDPhysPgDriverLink1: TFDPhysPgDriverLink;
  FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;

  // FDManager1: TFDManager;
  LInited: boolean = false;

procedure InitConfig;
begin
  if not LInited then
  begin
    /// inicializa a estrutura do FireDAC
    FDPhysFBDriverLink1 := TFDPhysFBDriverLink.create(FContainer);
    FDPhysMySQLDriverLink1 := TFDPhysMySQLDriverLink.create(FContainer);
    FDPhysMSSQLDriverLink1 := TFDPhysMSSQLDriverLink.create(FContainer);
    FDPhysPgDriverLink1 := TFDPhysPgDriverLink.create(FContainer);
    FDPhysOracleDriverLink1 := TFDPhysOracleDriverLink.create(FContainer);

{$IFDEF MSWINDOWS}
    FDGUIxWaitCursor1 := TFDGUIxWaitCursor.create(FContainer);
{$ENDIF}
  end;
end;

procedure SetConnectionProp(fd: TFDCustomConnection);
var
  LVendorLib: string;
  LDriverID: string;
  old: char;
begin
  InitConfig;
  /// pega a configuração de usuario
  if WSConnectionString <> '' then
  begin
    old := fd.Params.Delimiter;
    try
      fd.Params.Delimiter := ';';
      fd.Params.DelimitedText := stringReplace(WSConnectionString, '\\', '\',
        [rfReplaceAll]);
    finally
      fd.Params.Delimiter := old;
    end;
  end;

  LVendorLib := fd.Params.Values['VendorLib'];
  LDriverID := fd.Params.Values['DriverId'].ToUpper;

  if not LVendorLib.IsEmpty then
    if LDriverID.Equals('PG') then
    begin
      FDPhysPgDriverLink1.VendorLib := LVendorLib;
    end
    else if LDriverID.Equals('FB') then
      FDPhysFBDriverLink1.VendorLib := LVendorLib
    else if LDriverID.Equals('MYSQL') then
      FDPhysMySQLDriverLink1.VendorLib := LVendorLib
    else if LDriverID.Equals('ORA') then
      FDPhysOracleDriverLink1.VendorLib := LVendorLib
    else if LDriverID.Equals('MSSQL') then
      FDPhysMSSQLDriverLink1.VendorLib := LVendorLib;

end;

procedure TWSDatamodule.AfterConstruction;
begin
  inherited;
end;

procedure TWSDatamodule.FDManager1AfterLoadConnectionDefFile(Sender: TObject);
begin

end;

{ TFDQueryAuto }
var
  LQueryCount: Integer = 0;

constructor TFDQueryAuto.create(AOwner: TComponent);
var
  old: char;
  LConn: String;
begin
  inherited;
  ConnectionName := 'MVCBr_DB';
  TInterlocked.Add(LQueryCount, 0);

  name := '__query__' + LQueryCount.ToString;
  connection := FDManager.AcquireConnection(ConnectionName, name);
  if connection.Params.count = 0 then
  begin
    assert(WSConnectionString <> '',
      'Falta configurar a conexão de banco de dados');
    SetConnectionProp(connection);
  end;

end;

{ TFDStoredProcAuto }

constructor TFDStoredProcAuto.create(AOwner: TComponent);
begin
  inherited;
  ConnectionName := 'MVCBr_DB';
  TInterlocked.Add(LQueryCount, 0);

  name := '__query__' + LQueryCount.ToString;
  connection := FDManager.AcquireConnection(ConnectionName, name);
  if connection.Params.count = 0 then
  begin
    assert(WSConnectionString <> '',
      'Falta configurar a conexão de banco de dados');
    SetConnectionProp(connection);
  end;

end;

procedure ODataAutoRegisterResources;
var
  AList: TStringList;
  i, x: Integer;
  ANome, AResource: string;
  FQuery: TFDQueryAuto;
begin
  try
    AList := TStringList.create;
    try
      FQuery := TFDQueryAuto.create(nil);
      try
        if assigned(FQuery.connection) then
        begin
          FQuery.connection.GetTableNames('', '', '', AList, [osMy],
            [tkTable, tkView]);
          for i := 0 to AList.count - 1 do
            if AList[i].ToUpper().StartsWith('ODATA_') then
            begin
              ANome := AList[i].toLower;
              AResource := ANome;
              x := ANome.IndexOf('_');
              if x >= 0 then
                AResource := ANome.Substring(x + 1);
              ODataServices.RegisterResource(AResource, ANome, '', 24, '*', '',
                'GET', nil);
            end;
        end;
        ODataServices.SaveToJsonFile('OData.ServiceModel.new.json');
      finally
        FQuery.free;
      end;
    finally
      AList.free;
    end;
  except
  end;
end;

threadvar FFirstLoad: boolean;

procedure RegisterAutoLoadResource;
begin
  if not FFirstLoad then
    try
      FFirstLoad := true;
      if RegisterODataCustomServiceLoad(ODataAutoRegisterResources, false) then
        TODataServices.Invalidate;
    except
    end;
end;

initialization

FFirstLoad := false;
FContainer := TComponent.create(nil);

finalization

FreeAndNil(WSDatamodule);
FreeAndNil(FContainer);

end.
