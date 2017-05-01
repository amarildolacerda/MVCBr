unit masterDetailView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.StorageBin, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, oData.Comp.Client,
  MVCBr.FormView,
  MVCBr.ODataDatasetBuilder, FireDAC.Comp.DataSet, MVCBr.ODataFDMemTable,
  Vcl.StdCtrls;

type
  TForm61 = class(TFormFactory)
    ODataFDMemTable1: TODataFDMemTable;
    ODataDatasetBuilder1: TODataDatasetBuilder;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ODataFDMemTable2: TODataFDMemTable;
    ODataDatasetBuilder2: TODataDatasetBuilder;
    DBGrid2: TDBGrid;
    DataSource2: TDataSource;
    ODataFDMemTable2codigo: TStringField;
    ODataFDMemTable2descricao: TStringField;
    ODataFDMemTable2grupo: TStringField;
    ODataFDMemTable2unidade: TStringField;
    ODataFDMemTable2preco: TFloatField;
    FDQuery1: TFDQuery;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure ODataDatasetBuilder2AfterExecute(Sender: TObject);
    procedure ODataFDMemTable2AfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
    FAbriu: boolean;
  public
    { Public declarations }
  end;

var
  Form61: TForm61;

implementation

{$R *.dfm}

procedure TForm61.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  /// checa se o Master e o Detail estão no mesmo registro..
  /// quando os registros forem diferentes... recarregar o Detail
  if FAbriu then
    if ODataFDMemTable1.fieldByName('codigo').asString <> ODataFDMemTable2.fieldByName('grupo').asString then
    begin
      IF ODataFDMemTable2.UpdatesPending then
      BEGIN
        Memo1.Lines.Add(ODataFDMemTable2.Changes.ToString);
        ODataFDMemTable2.ApplyUpdates();
      END;
      FAbriu := false;
      try
        ODataDatasetBuilder2.execute;
      finally
        FAbriu := true;
      end;
    end;

end;

procedure TForm61.FormCreate(Sender: TObject);
begin
  /// executa o Master
  ODataDatasetBuilder1.execute;
  /// executa o Detail
  ODataDatasetBuilder2.execute;
  /// para evitar chamar o Detail antes de ser inicializado
  FAbriu := true;
end;

procedure TForm61.ODataDatasetBuilder2AfterExecute(Sender: TObject);
begin
  /// mostar o conteudo do detail chamado no servidor
  Memo1.Lines.Add(ODataDatasetBuilder2.RestClient.Resource);

end;

procedure TForm61.ODataFDMemTable2AfterInsert(DataSet: TDataSet);
begin
  if FAbriu then
    ODataFDMemTable2.fieldByName('grupo').asString := ODataFDMemTable1.fieldByName('codigo').asString;
end;

end.
