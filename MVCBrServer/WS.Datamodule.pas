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
  FireDAC.Phys, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys.MSAcc,
  FireDAC.Phys.MSAccDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Comp.UI,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL;

type
  TWSDatamodule = class(TDataModule)
    FDManager1: TFDManager;
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDSchemaAdapter1: TFDSchemaAdapter;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
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

var
  WSDatamodule: TWSDatamodule;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }
// uses FireDAC.Adpt;
uses System.SyncObjs, WS.Common ;

{$R *.dfm}

var
  ConnectionStrings: string;

procedure TWSDatamodule.AfterConstruction;
begin
  inherited;
  ConnectionStrings := FDConnection1.Params.Text;

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
begin
  inherited;
  ConnectionName := 'MVCBr_Firebird';
  TInterlocked.Add(LQueryCount, 0);

  name := '__query__' + LQueryCount.ToString;
  Connection := FDManager.AcquireConnection(ConnectionName, name);
  if Connection.Params.count = 0 then
  begin
    Connection.Params.values['driverid'] := 'FB';
    Connection.Params.values['server'] := 'localhost';
    Connection.Params.values['database'] := 'mvcbr';
    Connection.Params.values['user_name'] := 'sysdba';
    Connection.Params.values['password'] := 'masterkey';
    if WSConnectionString <> '' then
    begin
      old := Connection.Params.Delimiter;
      try
        Connection.Params.Delimiter := ';';
        Connection.Params.DelimitedText := WSConnectionString;
      finally
        Connection.Params.Delimiter := old;
      end;
    end;
  end;
end;

end.
