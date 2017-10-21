{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 20/10/2017 06:38:15                                  // }
{ //************************************************************// }

/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit FireDACMultiThreadView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf, System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB,
  VCL.ExtCtrls, VCL.DBCtrls, VCL.Controls, VCL.Grids, VCL.DBGrids, VCL.StdCtrls,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  /// Interface para a VIEW
  IFireDACMultiThreadView = interface(IView)
    ['{F7D09183-5636-4C8A-8EC1-873A1DA159F0}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TFireDACMultiThreadView = class(TFormFactory { TFORM } , IView,
    IThisAs<TFireDACMultiThreadView>, IFireDACMultiThreadView,
    IViewAs<IFireDACMultiThreadView>)
    Memo1: TMemo;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    Button1: TButton;
    DBNavigator1: TDBNavigator;
    Button2: TButton;
    GridPanel1: TGridPanel;
    Bevel1: TBevel;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    FInited: boolean;
    function NovoGrid: TDataSource;
  protected
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function ThisAs: TFireDACMultiThreadView;
    function ViewAs: IFireDACMultiThreadView;
    function ShowView(const AProc: TProc<IView>): integer; override;
  end;

Implementation

{$R *.DFM}

uses Data.FireDAC.Helper, System.threading;

function TFireDACMultiThreadView.ViewAs: IFireDACMultiThreadView;
begin
  result := self;
end;

class function TFireDACMultiThreadView.New(aController: IController): IView;
begin
  result := TFireDACMultiThreadView.create(nil);
  result.Controller(aController);
end;

function TFireDACMultiThreadView.NovoGrid: TDataSource;
var
  grid: TDbGrid;
begin
  grid := TDbGrid.create(self);
  grid.Parent := GridPanel1;
  grid.Align := alClient;
  result := TDataSource.create(grid);
  grid.dataSource := result;
end;

procedure TFireDACMultiThreadView.Button1Click(Sender: TObject);
var
  qry: TFDQuery;
begin
  // clone
  qry := FDQuery1.clone(self);
  qry.AsyncOpen(
    procedure
    begin
      NovoGrid.DataSet := qry;
    end);
end;

procedure TFireDACMultiThreadView.Button2Click(Sender: TObject);
begin
  begin
    // clone
    FDQuery1.connection := FDConnection1.clone(FDQuery1);
    FDQuery1.AsyncOpen(
      procedure
      begin
        NovoGrid.DataSet := FDQuery1;
      end);
  end;

end;

procedure TFireDACMultiThreadView.Button3Click(Sender: TObject);
begin
  GridPanel1.ControlCollection.Clear;
  System.threading.TParallel.&For(0, 3,
    procedure(index: integer)
    begin
      Button1Click(nil);
    end);
end;

function TFireDACMultiThreadView.Controller(const aController
  : IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    init;
    FInited := true;
  end;
end;

function TFireDACMultiThreadView.ThisAs: TFireDACMultiThreadView;
begin
  result := self;
end;

function TFireDACMultiThreadView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
