{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/05/2017 14:20:45                                  // }
{ //************************************************************// }
/// <summary>
/// Uma View representa a camada de apresentação ao usuário
/// deve esta associado a um controller onde ocorrerá
/// a troca de informações e comunicação com os Models
/// </summary>
unit JsonEditView;

interface

uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes, MVCBr.Interf,
  System.JSON,
  MVCBr.View, MVCBr.FormView, MVCBr.Controller, VCL.Controls, SynEdit, SynMemo,
  VCL.ExtCtrls;

type
  /// Interface para a VIEW
  IJsonEditView = interface(IView)
    ['{7C2E443D-C9A9-4689-AE69-207516B3872A}']
    // incluir especializacoes aqui
    procedure SetJsonText(AText: String);
    function GetJsonText: String;
    procedure SaveToFile(AFileName: string);
    procedure LoadFromFile(AFileName: String);
    function GetFilename: string;
    procedure SetFilename(const Value: string);
  end;

  /// Object Factory que implementa a interface da VIEW
  TJsonEditView = class(TFormFactory { TFORM } , IView, IThisAs<TJsonEditView>,
    IJsonEditView, IViewAs<IJsonEditView>)
    Timer1: TTimer;
    SynMemo1: TSynEdit;
    procedure SynMemo1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FInited: Boolean;
    FFilename: string;
    procedure UpdateText;
    function GetFilename: string;
    procedure SetFilename(const Value: string);
  protected
    FChanging: Boolean;
    FPending: Boolean;
    procedure Init;
    function Controller(const aController: IController): IView; override;
  public
    { Public declarations }
    class function New(aController: IController): IView;
    function This: TObject; override;
    function ThisAs: TJsonEditView;
    function ViewAs: IJsonEditView;
    function ShowView(const AProc: TProc<IView>): integer; override;
    function UpdateView: IView; override;
    function ViewEvent(AMessage: TJsonValue; var AHandled: Boolean)
      : IView; override;

    procedure SetJsonText(AText: String);
    function GetJsonText: String;
    procedure SaveToFile(AFileName: string);
    procedure LoadFromFile(AFileName: String);
    property Filename: string read GetFilename write SetFilename;
  end;

Implementation

{$R *.DFM}

uses Dialogs, System.JSON.Helper;

function TJsonEditView.UpdateView: IView;
begin
  result := self;
  { codigo para atualizar a View vai aqui... }
end;

function TJsonEditView.ViewAs: IJsonEditView;
begin
  result := self;
end;

class function TJsonEditView.New(aController: IController): IView;
begin
  result := TJsonEditView.create(nil);
  result.Controller(aController);
end;

function TJsonEditView.Controller(const aController: IController): IView;
begin
  result := inherited Controller(aController);
  if not FInited then
  begin
    Init;
    FInited := true;
  end;
end;

function TJsonEditView.GetFilename: string;
begin
  result := FFilename;
end;

function TJsonEditView.GetJsonText: String;
begin
  result := SynMemo1.Lines.text;
end;

procedure TJsonEditView.Init;
begin
  // incluir incializações aqui
end;

procedure TJsonEditView.LoadFromFile(AFileName: String);
begin
  SynMemo1.Lines.LoadFromFile(AFileName);
  FPending := true;
end;

function TJsonEditView.This: TObject;
begin
  result := inherited This;
end;

function TJsonEditView.ThisAs: TJsonEditView;
begin
  result := self;
end;

procedure TJsonEditView.UpdateText;
var
  j: IJsonObject;
  AHandled: Boolean;
begin
  /// prepare message to JsonTree  (main view)
  Timer1.Enabled := false;
  // send message change to main view
  j := TInterfacedJSON.New;
  j.addpair('to', 'tree');
  j.addpair('text', GetJsonText);
  /// send event to main view - reporting text changed
  ApplicationController.ViewEvent(j.JSONObject, AHandled);
  FPending := false;
end;

procedure TJsonEditView.Timer1Timer(Sender: TObject);
begin
  if FPending then
    UpdateText;
end;

procedure TJsonEditView.SaveToFile(AFileName: string);
begin
  /// check filename empty
  if AFileName = '' then
    with TSaveDialog.create(nil) do
      try
        DefaultExt := '*.json';
        filter := 'Arquivos Json|*.json';
        if execute then
        begin
          AFileName := Filename;
        end
        else
          exit;
      finally
        free;
      end;

  // check filename exists
  if fileexists(AFileName) then
    if MessageDlg('Substituir o arquivo ? ', TMsgDlgType.mtWarning,
      [mbYes, mbNo], 0) <> mrYes then
      exit;

  FFilename := AFileName;
  // save to disk
  SynMemo1.Lines.SaveToFile(AFileName);
end;

procedure TJsonEditView.SetFilename(const Value: string);
begin
  FFilename := Value;
end;

procedure TJsonEditView.SetJsonText(AText: String);
begin
  SynMemo1.Lines.text := AText;
  FPending := false;
end;

function TJsonEditView.ShowView(const AProc: TProc<IView>): integer;
begin
  inherited;
end;

function TJsonEditView.ViewEvent(AMessage: TJsonValue;
  var AHandled: Boolean): IView;
begin
  /// receive message from main form
  with AMessage as TJsonObject do
    if Contains('text') then
    begin
      if Value['to'] = 'memo' then
      begin
        try
          FChanging := true;
          try
            /// change edit text
            SetJsonText(Value['text']);
          finally
            FChanging := false;
          end;
        except
        end;
        AHandled := true;
      end;
    end;
end;

procedure TJsonEditView.SynMemo1Change(Sender: TObject);
var
  j: IJsonObject;
  AHandled: Boolean;
begin
  if FChanging then
    exit;
  /// timer to reflesh  JsonTree
  FPending := true;
  Timer1.Enabled := false;
  Timer1.Enabled := true;
end;

end.
