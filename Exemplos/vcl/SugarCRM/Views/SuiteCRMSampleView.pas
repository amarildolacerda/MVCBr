{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 05/05/2017 14:43:07                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit SuiteCRMSampleView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.Controls, VCL.StdCtrls,
  SuiteCRMSample.Controller.Interf,
  SuiteCRM.Model,
  VCL.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  REST.Response.Adapter, REST.FDSocial;

type
  /// Interface para a VIEW
  ISugarCRMSampleView = interface(IView)
    ['{6D69CBAB-65F6-433A-951B-EBD7CAD2C9CA}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TSugarCRMSampleView = class(TFormFactory { TFORM } , IView,
    IThisAs<TSugarCRMSampleView>, ISugarCRMSampleView,
    IViewAs<ISugarCRMSampleView>)
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    FDMemTable1: TFDMemTable;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    RESTSocialMemTableAdapter1: TRESTSocialMemTableAdapter;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    FInited: Boolean;
    procedure InitCRMParmas;
    procedure msg(a1, a2: string);
  protected
    FSuiteCRM: ISuiteCRMModel;
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TSugarCRMSampleView;
    function ViewAs: ISugarCRMSampleView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

Implementation

{$R *.DFM}
uses System.JSON;

function TSugarCRMSampleView.Update: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TSugarCRMSampleView.ViewAs: ISugarCRMSampleView;
begin
  result := self;
end;

class function TSugarCRMSampleView.New(aController: IController): IView;
begin
  result := TSugarCRMSampleView.create(nil);
  result.Controller(aController);

end;

procedure TSugarCRMSampleView.Button1Click(Sender: TObject);
begin
  InitCRMParmas;
  try
    FSuiteCRM.Login(LabeledEdit3.Text, LabeledEdit4.Text);
  except
  end;
  msg(FSuiteCRM.RequestText, FSuiteCRM.ResponseText);
end;

procedure TSugarCRMSampleView.Button2Click(Sender: TObject);
var
  r: TSuiteCRMAccount;
begin
  InitCRMParmas;
  assert(FSuiteCRM.sessionID > '', 'Falta login');

  r.id :=  '999';  //TGuid.NewGuid.ToString;  // nao funcionou - da erro no insert.
  // r.assigned_user_name := 'teste novo account';
  r.name := 'teste novo account';

  // r.nome :=  r.name;
  FSuiteCRM.Accounts.CreateID(r);

  msg(FSuiteCRM.RequestText, FSuiteCRM.ResponseText);
  Edit1.Text := FSuiteCRM.Accounts.CurrentID;
end;

procedure TSugarCRMSampleView.Button3Click(Sender: TObject);
begin
  InitCRMParmas;
  FSuiteCRM.Accounts.Get(Edit1.Text);
  msg(FSuiteCRM.RequestText, FSuiteCRM.ResponseText);
  Edit1.Text := FSuiteCRM.Accounts.CurrentID;
end;

procedure TSugarCRMSampleView.Button4Click(Sender: TObject);
begin
  InitCRMParmas;
  FSuiteCRM.Accounts.GetCount('');
  msg(FSuiteCRM.RequestText, FSuiteCRM.ResponseText);
end;

procedure TSugarCRMSampleView.Button5Click(Sender: TObject);
var rst:string;
  a:TJsonArray;
begin
  InitCRMParmas;
  FSuiteCRM.Accounts.Get_Entry_List('', '');
  msg(FSuiteCRM.RequestText, FSuiteCRM.ResponseText);

  rst := FSuiteCRM.ToJson;

  //TJSONObject.ParseJSONValue(rst).TryGetValue<TJsonArray>(a) ;

  RESTSocialMemTableAdapter1.FromJson(rst); //FromJsonArray(a);


  Memo1.lines.add(FSuiteCRM.ToJson);
end;

procedure TSugarCRMSampleView.Button6Click(Sender: TObject);
begin
  InitCRMParmas;
  FSuiteCRM.Users.get_user_id;
  msg(FSuiteCRM.RequestText, FSuiteCRM.ResponseText);
end;

function TSugarCRMSampleView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

procedure TSugarCRMSampleView.InitCRMParmas;
begin
  // FSuiteCRM.Init( LabeledEdit1.text, LabeledEdit2.text, LabeledEdit3.text, LabeledEdit4.text   );
  FSuiteCRM.BaseURL := LabeledEdit1.Text;
  FSuiteCRM.PathURL := LabeledEdit2.Text;
end;

procedure TSugarCRMSampleView.msg(a1, a2: string);
begin
  Memo1.lines.clear;
  Memo1.lines.add(a1);
  Memo1.lines.add('-----------------');
  Memo1.lines.add(a2);
end;

procedure TSugarCRMSampleView.Init;
begin
  // incluir incializações aqui
  FSuiteCRM := getModel<ISuiteCRMModel>;
end;

function TSugarCRMSampleView.This: TObject;
begin
  result := inherited This;
end;

function TSugarCRMSampleView.ThisAs: TSugarCRMSampleView;
begin
  result := self;
end;

function TSugarCRMSampleView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
