{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 10/10/2017 23:23:58                                  // }
{ //************************************************************// }

/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit MongoDBModelView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.MongoModel, BSONUtils,
  MVCBr.FDMongoDB,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, VCL.StdCtrls, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, VCL.Controls, VCL.Grids, VCL.DBGrids;

type
  /// Interface para a VIEW
  IMongoDBModelView = interface(IView)
    ['{838E21A9-69BC-4364-8498-711F0A51EEC4}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TMongoDBModelView = class(TFormFactory { TFORM } , IView,
    IThisAs<TMongoDBModelView>, IMongoDBModelView, IViewAs<IMongoDBModelView>)
    DBGrid1: TDBGrid;
    FDMemTable1: TFDMemTable;
    FDMemTable1nome: TStringField;
    DataSource1: TDataSource;
    Button1: TButton;
    FDMemTable1codigo: TStringField;
    DBGrid2: TDBGrid;
    Button2: TButton;
    DataSource2: TDataSource;
    MVCBrMongoConnection1: TMVCBrMongoConnection;
    MVCBrMongoDataset1: TMVCBrMongoDataset;
    MVCBrMongoDataset1codigo: TStringField;
    MVCBrMongoDataset1nome: TStringField;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FDMemTable1BeforePost(DataSet: TDataSet);
    procedure FDMemTable1BeforeDelete(DataSet: TDataSet);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormFactoryCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    FInited: boolean;
    FLoading: boolean;
  protected
    function Controller(const aController: IController): IView; override;
    procedure msg(ATexto: string);
  public
    { Public declarations }
    mongo: IMongoModel;

    FDMongoConnection: TMVCBrMongoConnection;
    FDMongoTable: TMVCBrMongoDataset;

    class function New(aController: IController): IView;
    function ThisAs: TMongoDBModelView;
    function ViewAs: IMongoDBModelView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

{$R *.DFM}

uses System.JSON.Helper, Data.DB.Helper;

function TMongoDBModelView.ViewAs: IMongoDBModelView;
begin
  result := self;
end;

class function TMongoDBModelView.New(aController: IController): IView;
begin
  result := TMongoDBModelView.create(nil);
  result.Controller(aController);
end;

procedure TMongoDBModelView.Button1Click(Sender: TObject);
var
  doc: IJSONDocArray;
  i: integer;
  item: IJSONDocument;
  j: string;
begin
  FLoading := true;
  try
    if not FDMemTable1.Active then
      FDMemTable1.Active := true;
    FDMemTable1.EmptyDataSet;
    mongo.getDataset('produtos', [], FDMemTable1);
  finally
    FLoading := false;
  end;
end;

procedure TMongoDBModelView.Button2Click(Sender: TObject);
begin
  // FDMongoTable.Open;
  MVCBrMongoDataset1.Open();
end;

procedure TMongoDBModelView.Button3Click(Sender: TObject);
begin
  MVCBrMongoDataset1.ApplyUpdates();
end;

procedure TMongoDBModelView.Button4Click(Sender: TObject);
var
  doc: IJSONDocument;
begin
  doc := MVCBrMongoConnection1.RunCommand( mongoJSON( '{"count":"produtos"}' )  );
  msg(doc.ToString);
end;

procedure TMongoDBModelView.Button5Click(Sender: TObject);
var
  doc: IJSONDocument;
begin
  doc := MVCBrMongoConnection1.RunCommand( mongoJSON( '{"find":"produtos","limit":2}' )  );
  msg(doc.ToString);

  MVCBrMongoDataset1.OpenWithCommand(MongoJSON(['limit',2]));


end;

function TMongoDBModelView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

procedure TMongoDBModelView.FDMemTable1BeforeDelete(DataSet: TDataSet);
var
  where: IJSONDocument;
begin
  if FLoading then
    exit;
  where := MongoJson(FDMemTable1.Fields.ToJson(true, 'codigo'));
  mongo.Delete('produtos', where);
end;

procedure TMongoDBModelView.FDMemTable1BeforePost(DataSet: TDataSet);
var
  where: IJSONDocument;
begin
  if FLoading then
    exit;
  if FDMemTable1.State in [dsInsert] then
    mongo.Insert('produtos', MongoJson(FDMemTable1.Fields.ToJson))
  else
  begin
    where := MongoJson(FDMemTable1.Fields.ToJson(true, 'codigo'));
    mongo.Update('produtos', where, MongoJson(FDMemTable1.Fields.ToJson));
  end;
end;

procedure TMongoDBModelView.FormFactoryCreate(Sender: TObject);
begin
  MVCBrMongoConnection1.Active := true;
end;

procedure TMongoDBModelView.msg(ATexto: string);
begin
  Memo1.lines.Insert(0, ATexto);
end;

function TMongoDBModelView.ThisAs: TMongoDBModelView;
begin
  result := self;
end;

function TMongoDBModelView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
  mongo := GetModel<IMongoModel>;
  MVCBrMongoConnection1.Params := mongo.this;

  { Criando no código
    FDMongoConnection := TMVCBrMongoConnection.create(self);
    FDMongoConnection.Params := mongo.this;

    FDMongoTable := TMVCBrMongoDataset.create(self);

    FDMongoTable.FieldDefs.Add('codigo', ftstring, 18);
    FDMongoTable.FieldDefs.Add('nome', ftstring, 50);
    FDMongoTable.FieldDefs.Update;

    FDMongoTable.CollectionName := 'produtos';
    FDMongoTable.KeyFields := 'codigo';

    FDMongoTable.Connection := FDMongoConnection;
    DataSource2.DataSet := FDMongoTable;
  }
end;

end.
