{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 08/04/2017 15:02:38                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit tabelaPriceView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, FMX.Types, FMX.Controls,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.TabControl,
  FMX.Edit,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, System.Rtti, FMX.Grid.Style,
  Data.Bind.EngExt, FMX.Bind.DBEngExt, FMX.Bind.Grid, System.Bindings.Outputs,
  FMX.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.ScrollBox, FMX.Grid, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.ImageList, FMX.ImgList;

type
  /// Interface para a VIEW
  ItabelaPriceView = interface(IView)
    ['{4E2B86B6-378F-43F7-AE90-58777B3AFCDF}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TtabelaPriceView = class(TFormFactory { TFORM } , IView,
    IThisAs<TtabelaPriceView>, ItabelaPriceView,
    IViewAs<ItabelaPriceView>, ILayout)
    Layout1: TLayout;
    TabControl1: TTabControl;
    tabValores: TTabItem;
    tabTaxaEquivalente: TTabItem;
    tabCalcular: TTabItem;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    GridPanelLayout1: TGridPanelLayout;
    Label1: TLabel;
    edValorFinanciado: TEdit;
    Label2: TLabel;
    edValorEntrada: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edNrParcelas: TEdit;
    edTaxaJuros: TEdit;
    SpeedButton3: TSpeedButton;
    GridPanelLayout2: TGridPanelLayout;
    Label6: TLabel;
    edEqTaxaConhecida: TEdit;
    Label7: TLabel;
    edEqPeriodoDado: TEdit;
    Label9: TLabel;
    edEqPeriodoDesejado: TEdit;
    Label8: TLabel;
    edEqCalculado: TEdit;
    FDMemTable1: TFDMemTable;
    FDMemTable1n: TIntegerField;
    FDMemTable1Value: TCurrencyField;
    StringGrid1: TStringGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    ImageList1: TImageList;
    VertScrollBox1: TVertScrollBox;
    SpeedButton4: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure edEqTaxaConhecidaExit(Sender: TObject);
    procedure edEqPeriodoDadoExit(Sender: TObject);
    procedure edEqPeriodoDesejadoExit(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    FInited: Boolean;
  protected
    FEquivalente: Double;
    procedure checkControls;
    procedure Init; override;
    procedure calcular;
    procedure calculoEq;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TtabelaPriceView;
    function ViewAs: ItabelaPriceView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
    function GetLayout: TObject;

    function ViewEvent(AMessage: string; var AHandled: Boolean): IView;
      override;

  end;

Implementation

uses System.Finance;

{$R *.FMX}

type
  /// EditHelper para expor property Value (numeric)
  TEditHelper = class helper for TEdit
  private
    procedure SetValue(const Value: Double);
    function GetValue: Double;
  public
    property Value: Double read GetValue write SetValue;
  end;

function TtabelaPriceView.Update: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TtabelaPriceView.ViewAs: ItabelaPriceView;
begin
  result := self;
end;

function TtabelaPriceView.ViewEvent(AMessage: string;
  var AHandled: Boolean): IView;
begin
  /// recebe mensagem do forme principal indicando qual ABA deve
  /// manter visivel
  if AMessage.Equals('tab.valores') then
    TabControl1.ActiveTab := tabValores
  else if AMessage.Equals('tab.equivalente') then
    TabControl1.ActiveTab := tabTaxaEquivalente;

end;

class function TtabelaPriceView.New(aController: IController): IView;
begin
  result := TtabelaPriceView.create(nil);
  result.Controller(aController);
end;

procedure TtabelaPriceView.edEqPeriodoDesejadoExit(Sender: TObject);
begin
  calculoEq;
end;

procedure TtabelaPriceView.Button1Click(Sender: TObject);
begin
  /// prepara para o calculo da planilha
  TabControl1.ActiveTab := tabCalcular;
  checkControls;
  calcular;
end;

procedure TtabelaPriceView.Button2Click(Sender: TObject);
begin
  calculoEq;
  edTaxaJuros.Value := edEqCalculado.Value;
  TabControl1.ActiveTab := tabValores;
end;

procedure TtabelaPriceView.calcular;
var
  pmt: Double;
  i: integer;
  n: integer;
begin

  /// calculo matemático da planilha
  n := trunc(edNrParcelas.Value);
  pmt := PMTAtEndOf(edValorFinanciado.Value, edValorEntrada.Value,
    edTaxaJuros.Value, n);

  StringGrid1.BeginUpdate;
  try
    FDMemTable1.DisableControls;
    try
      FDMemTable1.EmptyDataSet;
      if not FDMemTable1.active then
        FDMemTable1.open;
      for i := 1 to n do
        with FDMemTable1 do
        begin
          append;
          fieldByName('n').AsInteger := i;
          fieldByName('value').AsFloat := pmt;
          post;
        end;
      FDMemTable1.First;
    finally
      FDMemTable1.EnableControls
    end;
  finally
    StringGrid1.EndUpdate;
  end;
end;

procedure TtabelaPriceView.calculoEq;
var
  n, i, d: Double;
begin
  FEquivalente := 0;

  n := edEqPeriodoDado.Value;
  i := edEqTaxaConhecida.Value;
  d := edEqPeriodoDesejado.Value;

  /// calculo de taxa equivalente
  FEquivalente := EquivalentRate(i, n, d);

  edEqCalculado.Value := FEquivalente;

end;

procedure TtabelaPriceView.checkControls;
begin
  SpeedButton1.enabled := TabControl1.TabIndex > 0;
  SpeedButton2.enabled := TabControl1.TabIndex < TabControl1.TabCount - 1;

  SpeedButton4.enabled := TabControl1.ActiveTab <> tabCalcular;

end;

function TtabelaPriceView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TtabelaPriceView.edEqTaxaConhecidaExit(Sender: TObject);
begin
  calculoEq;
end;

procedure TtabelaPriceView.edEqPeriodoDadoExit(Sender: TObject);
begin
  calculoEq
end;

function TtabelaPriceView.GetLayout: TObject;
begin
  result := Layout1;
end;

procedure TtabelaPriceView.Init;
begin
  TabControl1.ActiveTab := tabValores;
  checkControls;
  // incluir incializações aqui
end;

procedure TtabelaPriceView.TabControl1Change(Sender: TObject);
begin
  checkControls;
end;

function TtabelaPriceView.This: TObject;
begin
  result := inherited This;
end;

function TtabelaPriceView.ThisAs: TtabelaPriceView;
begin
  result := self;
end;

function TtabelaPriceView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

procedure TtabelaPriceView.SpeedButton1Click(Sender: TObject);
begin
  TabControl1.TabIndex := TabControl1.TabIndex - 1;
end;

procedure TtabelaPriceView.SpeedButton2Click(Sender: TObject);
begin
  TabControl1.TabIndex := TabControl1.TabIndex + 1;
end;

procedure TtabelaPriceView.SpeedButton3Click(Sender: TObject);
begin
  TabControl1.ActiveTab := tabTaxaEquivalente;
  edEqTaxaConhecida.Value := edTaxaJuros.Value;
  edEqPeriodoDado.Value := 1;
  edEqPeriodoDesejado.Value := 1;
  calculoEq;
end;

procedure TtabelaPriceView.SpeedButton4Click(Sender: TObject);
begin
  if TabControl1.ActiveTab = tabValores then
  begin
    TabControl1.ActiveTab := tabCalcular;
    calcular;
  end
  else if TabControl1.ActiveTab = tabTaxaEquivalente then
  begin
    calculoEq;
    TabControl1.ActiveTab := tabValores;
  end;
end;

{ TEditHelper }

function TEditHelper.GetValue: Double;
begin
  text := stringReplace(text, ',', FormatSettings.DecimalSeparator,
    [rfReplaceAll]);
  text := stringReplace(text, '.', FormatSettings.DecimalSeparator,
    [rfReplaceAll]);
  result := StrToFloatDef(text, 0);
end;

procedure TEditHelper.SetValue(const Value: Double);
begin
  text := FormatFloat('0.00', Value);
end;

end.
