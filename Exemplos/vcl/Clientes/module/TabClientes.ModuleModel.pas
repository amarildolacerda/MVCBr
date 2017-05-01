// Implementação para o interface:  ITabClientesModuleModel
// Data: 31/01/2017 22:34:45
// Criado automático pelo assistente do MVCBr (amarildo lacerda)
//
// ---------------------------------------------------------------
Unit TabClientes.ModuleModel;

{ .$I ..\inc\mvcbr.inc }
interface

uses Forms, System.Classes, System.SysUtils, System.RTTI,
  TabClientes.ModuleModel.Interf, MVCBr.ModuleModel,
  MVCBr.Interf, MVCBr.Model, MVCBr.Controller, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

Type
  // Class para implementar o ITabClientesModuleModel
  TTabClientesModuleModel = class(TModuleFactory, ITabClientesModuleModel,
    IThisAs<TTabClientesModuleModel>)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
  private
  protected
    function ThisAs: TTabClientesModuleModel;
  public
    class Function New(): ITabClientesModuleModel; overload;
    class function New(const AController: IController)
      : ITabClientesModuleModel; overload;
    // incluir as especializações da interface  ITabClientesModuleModel


    function Update:IModel;override;
    // implentação
    function GetDatasource: TDataSource;
    procedure Recarregar(  ACodigo:string );


  end;

implementation

{$R *.dfm}
uses Dialogs;

function TTabClientesModuleModel.ThisAs: TTabClientesModuleModel;
begin
  result := self;
end;

function TTabClientesModuleModel.Update: IModel;
begin
   //
   showmessage('TabClientesModel Update');

   result := inherited;
end;

class Function TTabClientesModuleModel.New(): ITabClientesModuleModel;
begin
  result := New(nil);
end;

function TTabClientesModuleModel.GetDatasource: TDataSource;
begin
  if not FDQuery1.active then
    FDQuery1.open;
  result := DataSource1;
end;

class function TTabClientesModuleModel.New(const AController: IController)
  : ITabClientesModuleModel;
begin
  result := TTabClientesModuleModel.create(nil);
  result.Controller(AController);
end;

procedure TTabClientesModuleModel.Recarregar(ACodigo: string);
begin
   ShowMessage('Recarregar '+ACodigo);
end;


end.
