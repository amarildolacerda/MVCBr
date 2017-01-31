// Implementação para o interface:  IPessoasModuleModel
// Data: 31/01/2017 11:27:00
// Criado automático pelo assistente do MVCBr (amarildo lacerda)
//
// ---------------------------------------------------------------
Unit Pessoas.ModuleModel;

{ .$I ..\inc\mvcbr.inc }
interface

uses Forms, System.Classes, System.SysUtils, System.RTTI,
  Pessoas.ModuleModel.Interf, MVCBr.ModuleModel,
  MVCBr.Interf, MVCBr.Model, MVCBr.Controller, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

Type
  // Class para implementar o IPessoasModuleModel
  TPessoasModuleModel = class(TModuleFactory, IPessoasModuleModel,
    IThisAs<TPessoasModuleModel>)
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    FDTable1Codigo: TIntegerField;
    FDTable1Nome: TStringField;
    DataSource1: TDataSource;
  private
  protected
    function ThisAs: TPessoasModuleModel;
  public
    class Function New(): IPessoasModuleModel; overload;
    class function New(const AController: IController)
      : IPessoasModuleModel; overload;
    // incluir as especializações da interface  IPessoasModuleModel

    function CadastroDatasource: TDataSource;

  end;

implementation

{$R *.dfm}

function TPessoasModuleModel.ThisAs: TPessoasModuleModel;
begin
  result := self;
end;

class Function TPessoasModuleModel.New(): IPessoasModuleModel;
begin
  result := New(nil);
end;

function TPessoasModuleModel.CadastroDatasource: TDataSource;
begin
  if FDTable1.Active = false then
  begin
    try
      FDTable1.CreateTable;
    except
    end;
    FDTable1.open;
  end;
  result := DataSource1;
end;

class function TPessoasModuleModel.New(const AController: IController)
  : IPessoasModuleModel;
begin
  result := TPessoasModuleModel.create(nil);
  result.Controller(AController);
end;

end.
