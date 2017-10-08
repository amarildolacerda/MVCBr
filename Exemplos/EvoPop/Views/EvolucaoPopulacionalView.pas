{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 29/09/2017 21:07:49                                  // }
{ //************************************************************// }

/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit EvolucaoPopulacionalView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, FMXTee.Engine, FMX.Controls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, Data.Bind.EngExt, FMX.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, FMX.Bind.Editors, MVCBr.Component, MVCBr.PageView,
  MVCBr.FMX.PageView, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.StdCtrls,
  FMX.Controls.Presentation, FMXTee.Series, FMXTee.Procs, FMXTee.Chart,
  FMX.ListView, FMX.Layouts, FMX.TabControl, FMX.Types,
  EvolucaoPopulacional.Controller.Interf, System.Generics.Collections;

type
  /// Interface para a VIEW
  IEvolucaoPopulacionalView = interface(IView)
    ['{E8D5D91F-5C0F-491C-A944-27D4CB0935FF}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TEvolucaoPopulacionalView = class(TFormFactory { TFORM } , IView,
    IThisAs<TEvolucaoPopulacionalView>, IEvolucaoPopulacionalView,
    IViewAs<IEvolucaoPopulacionalView>)
    Chart1: TChart;
    memDados: TFDMemTable;
    memDadosAno: TIntegerField;
    memDadosMundo: TFloatField;
    memDadosAfrica: TFloatField;
    memDadosAsia: TFloatField;
    memDadosEuropa: TFloatField;
    memDadosAmLatina: TFloatField;
    memDadosAmNorte: TFloatField;
    memDadosOceania: TFloatField;
    Series1: TLineSeries;
    DataSource1: TDataSource;
    Timer1: TTimer;
    memEventos: TFDMemTable;
    memEventosano: TIntegerField;
    memEventosnome: TStringField;
    ListView1: TListView;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    Series2: TFastLineSeries;
    Layout1: TLayout;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    FMXPageViewManager1: TFMXPageViewManager;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FList: TList<TGuid>;
    FInited: boolean;
    FAnoCorrente: integer;
    FAnoBase: integer;
    FAnoProxPonto: integer;
    FValorProx: Double;
  protected
    function ProxPonto: integer;
    function Next: integer;
    function Controller(const aController: IController): IView; override;

    procedure CreateTabView(idx: integer);
    procedure addGuids;
    [weak]
    function ControllerAs: IEvolucaoPopulacionalController;

  public
    { Public declarations }
    procedure Init; override;
    class function New(aController: IController): IView;
    function ThisAs: TEvolucaoPopulacionalView;
    function ViewAs: IEvolucaoPopulacionalView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

uses winapi.mmSystem,
  Dados.Model.Interf, Data.DB.Helper;

{$R *.fmx}

function TEvolucaoPopulacionalView.ViewAs: IEvolucaoPopulacionalView;
begin
  result := self;
end;

procedure TEvolucaoPopulacionalView.CreateTabView(idx: integer);
begin

end;

procedure TEvolucaoPopulacionalView.FormDestroy(Sender: TObject);
begin
  FList.free;
end;

procedure TEvolucaoPopulacionalView.FormShow(Sender: TObject);
begin
  FList := TList<TGuid>.create;
  addGuids;
  Chart1.Series[0].Clear;
end;

procedure TEvolucaoPopulacionalView.Init;
var
  LDados: IDadosModel;
begin
  inherited;
  LDados := GetModel<IDadosModel>;

  memDados.open;
  LDados.CarregarDataset('dados.json', memDados);

  memEventos.open;
  LDados.CarregarDataset('eventos.json', memEventos);

  memDados.first;
  FAnoCorrente := memDados.FieldByName('ano').asInteger;
  FAnoProxPonto := ProxPonto;
  Timer1.enabled := true;
end;

class function TEvolucaoPopulacionalView.New(aController: IController): IView;
begin
  result := TEvolucaoPopulacionalView.create(nil);
  result.Controller(aController);
end;

function TEvolucaoPopulacionalView.Next: integer;
begin
  memDados.Next;
  result := memDados.values['ano'];

  FAnoCorrente := result;
  FAnoBase := result;
  FAnoProxPonto := ProxPonto;
end;

function TEvolucaoPopulacionalView.ProxPonto: integer;
begin
  if memDados.eof = false then
  begin
    try
      memDados.Next;
      if not memDados.eof then
      begin
        result := memDados.values['ano'];
        FValorProx := memDados.values['mundo'];
      end;
    finally
      memDados.Prior;
    end;
  end;
end;

procedure TEvolucaoPopulacionalView.addGuids;
begin

end;

function TEvolucaoPopulacionalView.Controller(const aController
  : IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;

end;

function TEvolucaoPopulacionalView.ControllerAs
  : IEvolucaoPopulacionalController;
begin
  result := GetController as IEvolucaoPopulacionalController;
end;

function TEvolucaoPopulacionalView.ThisAs: TEvolucaoPopulacionalView;
begin
  result := self;
end;

procedure TEvolucaoPopulacionalView.Timer1Timer(Sender: TObject);
var
  LDados: IDadosModel;
  v, r: Double;
  sNome: string;
  x: integer;

  function Calcular(v: Double): Double;
  var
    va: Double;
  begin
    va := (FValorProx - v) / (FAnoProxPonto - FAnoBase);
    result := FValorProx - ((FAnoProxPonto - FAnoCorrente) * va);
  end;

begin
  LDados := GetModel<IDadosModel>;
  r := Calcular(memDados.values['mundo']);
  // a diferença para cada ano

  // procura evento
  sNome := '';
  memEventos.Filter := 'ano=' + FAnoCorrente.ToString;
  memEventos.Filtered := true;
  while memEventos.eof = false do
  begin
    sNome := sNome + memEventos.values['nome'];
    FDMemTable1.append;
    FDMemTable1.Fields.FillFromJson(memEventos.Fields.ToJson);
    FDMemTable1.Post;
    memEventos.Next;
    sndPlaySound('chord.wav', SND_NODEFAULT Or SND_ASYNC { Or SND_LOOP } );
    ControllerAs.Notification('Evento', '', memEventos.values['nome']);
  end;

  x := Chart1.Series[0].Add(r, FAnoCorrente.ToString);
  x := Chart1.Series[1].Add(memDados.values['amlatina'], FAnoCorrente.ToString);

  inc(FAnoCorrente);
  if FAnoCorrente >= FAnoProxPonto then
  begin
    Next;
    if memDados.eof or (FAnoProxPonto < FAnoCorrente) then
      Timer1.enabled := false;

  end;
end;

function TEvolucaoPopulacionalView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

procedure TEvolucaoPopulacionalView.SpeedButton1Click(Sender: TObject);
begin
  if TabControl1.TabIndex < TabControl1.TabCount - 1 then
    TabControl1.TabIndex := TabControl1.TabIndex + 1
  else if TabControl1.TabIndex = TabControl1.TabCount - 1 then
    CreateTabView(TabControl1.TabIndex);
end;

procedure TEvolucaoPopulacionalView.SpeedButton2Click(Sender: TObject);
begin
  if TabControl1.TabIndex > 0 then
    TabControl1.TabIndex := TabControl1.TabIndex - 1;
end;

end.
