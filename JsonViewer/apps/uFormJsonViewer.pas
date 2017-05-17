unit uFormJsonViewer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ActnList, StdActns, ImgList, Menus,
  MVCBr.FormView, MVCBr.Interf, System.JSON,
  ComCtrls, jsontreeview, jsondoc, System.ImageList, System.Actions,
  Vcl.DBActns, MVCBr.Component, MVCBr.PageView, MVCBr.Vcl.PageView;

type
  IFormJsonViewer = interface(IView)
    ['{CB23EFE1-231A-407E-A887-4390596958E3}']
  end;

  TFormJsonViewer = class(TFormFactory, IFormJsonViewer)
    Panel1: TPanel;
    ActionList1: TActionList;
    ImageList1: TImageList;
    EditPaste1: TEditPaste;
    EditClear1: TEditDelete;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ActionToggleVisibleChildrenCounts: TAction;
    ActionToggleVisibleByteSizes: TAction;
    PopupMenu1: TPopupMenu;
    VisibleChildrenCounts1: TMenuItem;
    VisibleByteSizes1: TMenuItem;
    FileOpen1: TFileOpen;
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    VCLPageViewManager1: TVCLPageViewManager;
    FileSaveAs1: TFileSaveAs;
    procedure ActionToggleVisibleChildrenCountsExecute(Sender: TObject);
    procedure ActionToggleVisibleByteSizesExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditPaste1Execute(Sender: TObject);
    procedure EditClear1Execute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
    FFileName: string;
    FChanging: boolean;
    JSONTreeView1: TJSONTreeView;
    JSONDocument1: TJSONDocument;
    procedure FromJson(AJson: string);
    procedure ChangeControls;
  public
    { Public declarations }
    class function New: IView;

    function ViewEvent(AMessage: TJsonValue; var AHandled: boolean)
      : IView; override;

  end;

var
  FormJsonViewer: TFormJsonViewer;

implementation

uses Clipbrd, System.JSON.Helper, JsonEdit.Controller.Interf, JsonEditView;

{$R *.dfm}

procedure TFormJsonViewer.FormCreate(Sender: TObject);
begin
  /// init controls;
  JSONDocument1 := TJSONDocument.create(self);
  JSONTreeView1 := TJSONTreeView.create(self);
  JSONTreeView1.JSONDocument := JSONDocument1;
  JSONTreeView1.parent := TabSheet1;
  JSONTreeView1.Align := alClient;

  ActionToggleVisibleByteSizes.Checked := JSONTreeView1.VisibleByteSizes;
  ActionToggleVisibleChildrenCounts.Checked :=
    JSONTreeView1.VisibleChildrenCounts;

end;

procedure TFormJsonViewer.FormShow(Sender: TObject);
begin
  /// add view to pagecontrol
  VCLPageViewManager1.AddView(IJsonEditController);
  PageControl1.TabIndex := 0;
end;

procedure TFormJsonViewer.ActionToggleVisibleByteSizesExecute(Sender: TObject);
begin
  JSONTreeView1.VisibleByteSizes := not JSONTreeView1.VisibleByteSizes;
end;

procedure TFormJsonViewer.ActionToggleVisibleChildrenCountsExecute
  (Sender: TObject);
begin
  JSONTreeView1.VisibleChildrenCounts :=
    not JSONTreeView1.VisibleChildrenCounts;
end;

procedure TFormJsonViewer.Button1Click(Sender: TObject);
var
  st: TStringList;
begin
  /// open file from disk
  with TOpenDialog.create(self) do
    try
      DefaultExt := '*.json';
      Filter := 'Json File|*.json;Texto|*.txt;*.*|*.*';
      if execute then
        try
          self.FFileName := FileName;
          st := TStringList.create;
          st.LoadFromFile(self.FFileName);
          if st.count > 0 then
            FromJson(st.text);
          ChangeControls;
        finally
          st.free;
        end;
    finally
      free;
    end;
end;

procedure TFormJsonViewer.Button2Click(Sender: TObject);
var
  AView: IJsonEditView;
begin
  // save to
  AView := GetView<IJsonEditView>;
  if assigned(AView) then
  begin
    AView.SaveToFile(FFileName);
    if AView.GetFilename<>'' then
       FFileName := AView.GetFilename;
    ChangeControls;
  end;
end;

procedure TFormJsonViewer.ChangeControls;
begin
  caption := 'Filename: ' + FFileName;
end;

procedure TFormJsonViewer.EditClear1Execute(Sender: TObject);
begin
  FromJson('');

end;

procedure TFormJsonViewer.FromJson(AJson: string);
var
  j: IJsonObject;
  AHandled: boolean;
begin
  try
    /// change tree
    JSONDocument1.JsonText := AJson;
    JSONTreeView1.Items.BeginUpdate;
    JSONTreeView1.LoadJson;
    JSONTreeView1.Items.EndUpdate;
  finally
  end;

  /// check if need send mensage to memo.text changed
  if not FChanging then
  begin
    j := TInterfacedJSON.New;
    j.addPair('to', 'memo');
    j.addPair('text', AJson);
    /// send message to memo.text changed
    ApplicationController.ViewEvent(j.JsonValue, AHandled);
  end;

end;

class function TFormJsonViewer.New: IView;
begin
  result := TFormJsonViewer.create(nil);
end;

function TFormJsonViewer.ViewEvent(AMessage: TJsonValue;
  var AHandled: boolean): IView;
begin
  /// check event send to me
  with AMessage as TJsonObject do
    if Contains('text') then
    begin
      if Value['to'] = 'tree' then
      begin
        try
          /// yes its to me
          FChanging := true;
          try
            FromJson(Value['text']);
          finally
            FChanging := false;
          end;
        except
        end;
        /// its my, then sign stop loop
        AHandled := true;
      end;
    end;
end;

procedure TFormJsonViewer.EditPaste1Execute(Sender: TObject);
begin
  FromJson(Clipboard.AsText);
end;

end.
