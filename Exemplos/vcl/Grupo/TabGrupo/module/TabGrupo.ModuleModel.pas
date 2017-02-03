{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br                                // }
{ //************************************************************// }
{ // Data: 02/02/2017 22:18:54                                                // }
{ //************************************************************// }
// Implementação para o interface:  ITabGrupoModuleModel
// Data: 02/02/2017 22:18:54
// Criado automático pelo assistente do MVCBr (amarildo lacerda)
//
// ---------------------------------------------------------------
Unit TabGrupo.ModuleModel;

{ .$I ..\inc\mvcbr.inc }
interface

uses Forms, System.Classes, System.SysUtils, System.RTTI,
  TabGrupo.ModuleModel.Interf, MVCBr.ModuleModel,
  MVCBr.Interf, MVCBr.Model, MVCBr.Controller, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

Type
  // Class para implementar o ITabGrupoModuleModel
  TTabGrupoModuleModel = class(TModuleFactory, ITabGrupoModuleModel,
    IThisAs<TTabGrupoModuleModel>)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    procedure FDQuery1AfterScroll(DataSet: TDataSet);
  private
  protected
    FCodigoSelecionadoEvent : TProc;
    function ThisAs: TTabGrupoModuleModel;
  public
    class Function New(): ITabGrupoModuleModel; overload;
    class function New(const AController: IController)
      : ITabGrupoModuleModel; overload;
    // incluir as especializações da interface  ITabGrupoModuleModel

    function GetDataSource: TDataSource;
    procedure ProcurarGrupo(ANomeGrupo: String; AProc:TProc);
    function GetGrupoSelecionado: string;

  end;

implementation

{$R *.dfm}

function TTabGrupoModuleModel.ThisAs: TTabGrupoModuleModel;
begin
  result := self;
end;

class Function TTabGrupoModuleModel.New(): ITabGrupoModuleModel;
begin
  result := New(nil);
end;

function TTabGrupoModuleModel.GetGrupoSelecionado: string;
begin
  result := FDQuery1.fieldByName('grupo').asString;
end;

procedure TTabGrupoModuleModel.FDQuery1AfterScroll(DataSet: TDataSet);
begin
  //  com anonimous
  // if assigned(FCodigoSelecionadoEvent) then
  //     FCodigoSelecionadoEvent;

  // com observer
  GetController.UpdateByModel(self);

end;

function TTabGrupoModuleModel.GetDataSource: TDataSource;
begin
  if not FDQuery1.active then
    FDQuery1.open;
  result := DataSource1;
end;

class function TTabGrupoModuleModel.New(const AController: IController)
  : ITabGrupoModuleModel;
begin
  result := TTabGrupoModuleModel.create(nil);
  result.Controller(AController);
end;

procedure TTabGrupoModuleModel.ProcurarGrupo(ANomeGrupo: String; AProc : TProc);
begin
  FCodigoSelecionadoEvent := AProc;
  FDQuery1.close;
  FDQuery1.sql.text := 'select * from ctgrupo where nome like (' +
    QuotedStr(ANomeGrupo + '%') + ')';
  FDQuery1.open;
end;

end.
