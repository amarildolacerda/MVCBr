{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 03/03/2017 11:35:23                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit WSConfigView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  MVCBr.ObjectConfigList, MVCBr.View,
  MVCBr.FormView, MVCBr.Controller,
  VCL.Controls, VCL.StdCtrls;

type
  /// Interface para a VIEW
  IWSConfigView = interface(IView)
    ['{3DCAFC16-0A94-403F-8EAA-F328F6588A66}']
    // incluir especializacoes aqui
  end;

  /// Object Factory que implementa a interface da VIEW
  TWSConfigView = class(TFormFactory { TFORM } , IView, IThisAs<TWSConfigView>,
    IWSConfigView, IViewAs<IWSConfigView>)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbDriver: TComboBox;
    Label2: TLabel;
    edServer: TEdit;
    Label3: TLabel;
    edBancoDados: TEdit;
    Label4: TLabel;
    edUsuario: TEdit;
    Label5: TLabel;
    edSenha: TEdit;
    Button1: TButton;
    GroupBox2: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  protected
    FList: IObjectConfigList;
    procedure AddControls;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TWSConfigView;
    function ViewAs: IWSConfigView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function Update: IView; override;
  end;

Implementation

{$R *.DFM}

function TWSConfigView.Update: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TWSConfigView.ViewAs: IWSConfigView;
begin
  result := self;
end;

procedure TWSConfigView.FormCreate(Sender: TObject);
begin
   FList := TObjectConfigModel.new;
   FList.FileName := ExtractFilePath(ParamStr(0))+'MVCBrServer.ini';
   AddControls;
   FList.ReadConfig;
end;

class function TWSConfigView.New(aController: IController): IView;
begin
  result := TWSConfigView.create(nil);
  result.Controller(aController);
end;

procedure TWSConfigView.AddControls;
begin
   FList.Add(cbDriver);
   FList.Add(edServer);
   FList.Add(edBancoDados);
   FList.Add(edUsuario);
   FList.Add(edSenha);
end;

procedure TWSConfigView.Button1Click(Sender: TObject);
begin
  FList.WriteConfig;
  close;
end;

function TWSConfigView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
end;

function TWSConfigView.This: TObject;
begin
  result := inherited This;
end;

function TWSConfigView.ThisAs: TWSConfigView;
begin
  result := self;
end;

function TWSConfigView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

end.
