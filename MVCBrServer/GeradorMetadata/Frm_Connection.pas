{
  Autor: Código original obtido do ORMBr
         "o código é de um coder desconhecido (Isaque)";

  Alterações (MVCBr):
     23/05/2017 - por: amarildo lacerda
         * alterado o form para suporte s IVIEW

}
unit Frm_Connection;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, {Frm_Principal,}
  MVCBr.Interf, MVCBr.FormView,
  Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Mask, Vcl.Buttons, db;

type

  IFrmConnection = Interface(IView)
    ['{9DC4299F-FFC9-464D-8F59-8B317D5DC8C3}']
  End;

  TFrmConnection = class(TFormFactory, IFrmConnection)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBComboBox1: TDBComboBox;
    DBEdit1: TDBEdit;
    Label5: TLabel;
    Label6: TLabel;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    btnSalvar: TBitBtn;
    btnCancel: TBitBtn;
    SpeedButton1: TSpeedButton;
    OD: TOpenDialog;
    DBEdit6: TDBEdit;
    Label7: TLabel;
    Label8: TLabel;
    DBEdit7: TDBEdit;
    SpeedButton2: TSpeedButton;
    procedure btnSalvarClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DBComboBox1Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConnection: TFrmConnection;

implementation

{$R *.dfm}

uses GeradorMetadata.Controller.Interf;

procedure TFrmConnection.FormDeactivate(Sender: TObject);
var ctrController:IGeradorMetadataController;

begin

  ctrController := resolveController<IGeradorMetadataController>;
  ctrController.CDS_CNN_cancel;

  //FrmPrincipal.CDS_CNN.Cancel;
  Close;
end;

procedure TFrmConnection.SpeedButton1Click(Sender: TObject);
begin
  if OD.Execute() then
    DBEdit3.Text := OD.FileName;
end;

procedure TFrmConnection.SpeedButton2Click(Sender: TObject);
begin
  if OD.Execute() then
    DBEdit7.Text := OD.FileName;
end;

procedure TFrmConnection.btnCancelClick(Sender: TObject);
begin
  //FrmPrincipal.CDS_CNN.Cancel;
  with resolveController<IGeradorMetadataController> do
      CDS_CNN_cancel;

  Close;
end;

procedure TFrmConnection.btnSalvarClick(Sender: TObject);
begin
  with resolveController<IGeradorMetadataController> do
       CDS_CNN_Post;
 // FrmPrincipal.CDS_CNN.Post;
  Close;
end;

procedure TFrmConnection.DBComboBox1Change(Sender: TObject);
begin
  Label7.Visible := DBComboBox1.ItemIndex
    in [DBComboBox1.Items.IndexOf('Firebird'),
    DBComboBox1.Items.IndexOf('MySQL'), DBComboBox1.Items.IndexOf('Interbase'),
    DBComboBox1.Items.IndexOf('PostgreSQL')];
  DBEdit6.Visible := Label7.Visible;
end;

end.
