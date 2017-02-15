unit MVCBr.VCL.PageControl;

interface

uses VCL.Forms, System.Classes, System.SysUtils,
  MVCBr.Interf, MVCBr.controller, MVCBr.view,
  MVCBr.FormView, System.Generics.Collections,
  VCL.Controls, VCL.ComCtrls;

type
  // mvc.controller
  TOnControllerRegisterMenuItemEvent = procedure(AParent: integer;
    ACaption: String; AIdAcesso: Int64; AProc: TProc) of object;

  TTabSheetHacked = TTabSheet;
  TPageControlHacked = TPageControl;

  TJvTabSheetStored = class(TTabSheetHacked)
  private
    FFormID: String;
    procedure SetFormID(const Value: String);
  public
    property FormID: String read FFormID write SetFormID;
  end;



  // TFormClass = class of TForm;

  TPageControlContainerItem = class
  public
    Caption: string;
    Instance: IView;
    Form: TForm;
    oldOnClose: TCloseEvent;
  end;

  TPageControlContainer = class(TObjectList<TPageControlContainerItem>)
  public
    function Find(AID: string): integer;
    function FindID(AID: string): IView;
    function AddForm(const ACaption: string;
      const AView: TPageControlContainerItem): integer; virtual;
    function GetItem(const idx: integer): TPageControlContainerItem; virtual;
    procedure Close(Const AView:IView);
  end;

  TPageControlController = class(TComponent, IObservable)
  private
    FPageControl: TComponent;
    FContainer: TPageControlContainer;
    FDatabasename: string;
    FFilial: Double;
    FDirRelatorios: string;
    FOnRegisterMenuItem: TOnControllerRegisterMenuItemEvent;

    procedure SetPageControl(const Value: TComponent);
    procedure SetDatabasename(const Value: string);
    procedure SetFilial(const Value: Double);
    procedure SetDirRelatorios(const Value: string);
    procedure SetOnRegisterMenuItem(const Value
      : TOnControllerRegisterMenuItemEvent);
    function FindInterf(AForm: TComponent): IView;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure InitPage(APage: TJvTabSheetStored);
    procedure DoClose(Sender: TObject; var Action: TCloseAction);
    function IndexOfTab(AGid: String): integer;
    function GetPageControl: TPageControlHacked;
  public
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
    function Add(Value: TPageControlContainerItem): integer; overload;
    function AddForm(AForm: TForm): TForm; overload;
    function AddForm(AClass: TFormClass): TForm; overload;
    // Observer
    procedure Remove(Value: IObserver);
    procedure Close(Value: IView);
    procedure UpdateAll;
    function Count: integer;
    procedure AddForm(ACaption: string; Value: IView); overload;
    procedure NewPage(ACaption: String; Value: IView); overload;
    function NewPage: TJvTabSheetStored; overload;
    procedure DoCloseForm(Sender: IView; var ARemoveu: boolean);
    procedure CanClose(Sender: TObject; var ACanClose: boolean);
    procedure RegisterMenuItemControl(AParent: integer; ACaption: String;
      AIdAcesso: Int64; AProc: TProc);
  published
    property PageControl: TComponent read FPageControl write SetPageControl;
    property Databasename: string read FDatabasename write SetDatabasename;
    property Filial: Double read FFilial write SetFilial;
    property DirRelatorios: string read FDirRelatorios write SetDirRelatorios;
    property OnRegisterMenuItemControl: TOnControllerRegisterMenuItemEvent
      read FOnRegisterMenuItem write SetOnRegisterMenuItem;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Store', [TPageControlController]);
end;

type

  TcxPageControlHelper = class helper for TPageControlHacked
  public
    procedure ShowTabFromID(AID: string);
    function Find(AID: String): integer;
  end;
  { TJvTabSheetStored }

procedure TJvTabSheetStored.SetFormID(const Value: String);
begin
  FFormID := Value;
end;

{ TcxPageControlHelper }

function TcxPageControlHelper.Find(AID: String): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to PageCount - 1 do
    with TJvTabSheetStored(Pages[i]) do
      if FormID = AID then
      begin
        result := i;
        exit;
      end;
end;

procedure TcxPageControlHelper.ShowTabFromID(AID: string);
var
  tb: TJvTabSheetStored;
  i: integer;
begin
  i := Find(AID);
  if i >= 0 then
    ActivePage := Pages[i];
end;

{ TPageControlController }

function TPageControlController.Add(Value: TPageControlContainerItem): integer;
begin
  result := FContainer.Add(Value);
end;

procedure TPageControlController.AddForm(ACaption: string; Value: IView);
var
  i: integer;
  sw: TPageControlContainerItem;
begin
  // checar se ja foi acrescntado o mesmo objeto
  i := FContainer.Find(Value.GetID);
  if i >= 0 then
  begin // ja existe
    GetPageControl().ShowTabFromID(Value.GetID);
  end
  else
  begin // eh novo
    sw := TPageControlContainerItem.create;
    sw.Caption := ACaption;
    sw.Instance := Value;
    sw.Form := Value.This as TForm;
    FContainer.AddForm(ACaption, sw);
    NewPage(ACaption, Value);
    Value.ShowView();
  end;
end;

function TPageControlController.FindInterf(AForm: TComponent): IView;
var
  cmp: TComponent;
  i: integer;
begin
  result := nil;
  if supports(AForm, IView, result) then
    exit;
  for i := 0 to AForm.ComponentCount - 1 do
  begin
    cmp := AForm.Components[i];
    if supports(cmp, IView) then
    begin
      result := cmp as IView;
      exit;
    end;
  end;

end;

function TPageControlController.GetPageControl: TPageControlHacked;
begin
  result := TPageControlHacked(FPageControl);
end;

function TPageControlController.IndexOfTab(AGid: String): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to GetPageControl.PageCount - 1 do
    if GetPageControl.Pages[i].InheritsFrom(TJvTabSheetStored) then
    begin
      if TJvTabSheetStored(GetPageControl.Pages[i]).FormID = AGid then
      begin
        result := i;
        exit;
      end;
    end;
end;

procedure TPageControlController.InitPage(APage: TJvTabSheetStored);
begin
  APage.PageControl := GetPageControl;
  GetPageControl.ActivePage := APage;
end;

function TPageControlController.AddForm(AForm: TForm): TForm;
var
  LControl: TPageControlContainerItem;
  LView: IView;
  procedure SetForm(AForm: TForm);
  var
    i: integer;
  begin
    for i := 0 to FContainer.Count - 1 do
      with FContainer.GetItem(i) do
        if Form = AForm then
        begin
          Form := AForm;
          oldOnClose := AForm.OnClose;
          AForm.OnClose := DoClose;
        end;
  end;

begin
  result := AForm;
  if supports(result, IView) then
    AddForm(result.Caption, result as IView)
  else
  begin
    LView := FindInterf(result);
    if assigned(LView) then
    begin
      AddForm(result.Caption, LView);
      SetForm(result);
    end
    else
    begin
      LControl := TPageControlContainerItem.create;
      Add(LControl);
      SetForm(result);
    end;
  end;

end;

function TPageControlController.AddForm(AClass: TFormClass): TForm;

begin
  result := AddForm(AClass.create(FPageControl));
end;

procedure TPageControlController.CanClose(Sender: TObject;
  var ACanClose: boolean);
var
  id: String;
  intf: IView;
  i: integer;
  snd: TJvTabSheetStored;
begin
  snd := nil;
  if Sender.InheritsFrom(TPageControlHacked) then
  begin
    i := GetPageControl.ActivePageIndex;
    if (i >= 0) and (GetPageControl.Pages[i]).InheritsFrom(TJvTabSheetStored)
    then
      snd := TJvTabSheetStored(GetPageControl.Pages[i]);
    if snd <> nil then
    begin
      id := snd.FormID;
      i := FContainer.Find(id);
      if i >= 0 then
      begin
        intf := FContainer.items[i].Instance;
        ACanClose := true;
        // if assigned(intf) then
        // intf.this. FormCloseQuery(Sender, ACanClose);
        if ACanClose then
          FContainer.Delete(i);
      end;
    end;
  end;

end;

procedure TPageControlController.Close(Value: IView);
begin
  FContainer.Close(Value);
end;

function TPageControlController.Count: integer;
begin
  result := FContainer.Count;
end;

constructor TPageControlController.create(AOwner: TComponent);
begin
  inherited;
  if assigned(AOwner) and supports(AOwner, IMVCApplication) then
    MVCApplication := AOwner as IMVCApplication
  else
    MVCApplication := Self;
  FContainer := TStoreContainerClass.create;
  FContainer.OnClose := DoCloseForm;

end;

destructor TPageControlController.destroy;
begin
  PageControl := nil;
  FreeAndNil(FContainer);
  MVCApplication := nil;
  inherited;
end;

procedure TPageControlController.DoClose(Sender: TObject;
  var Action: TCloseAction);
var
  i, n: integer;
  ARemoveu: boolean;
  o: TStoreContainerItemObject;
  LGid: String;
  tb: TJvTabSheetStored;
begin
  for i := FContainer.Count - 1 downto 0 do
  begin
    o := FContainer.GetItem(i);
    with o do
      if Sender.Equals(o.Form) then
      begin
        LGid := (o.intf as IMVCForm).GetID;
        n := IndexOfTab(LGid);
        if n >= 0 then
        begin
          tb := TJvTabSheetStored(GetPageControl.Pages[n]);
          GetPageControl.CloseTab(tb.TabIndex);
        end;
        exit;
      end;
  end;
end;

procedure TPageControlController.DoCloseForm(Sender: IMVCForm;
  var ARemoveu: boolean);
var
  id: string;
  i: integer;
  tb: TJvTabSheetStored;
  nTab: integer;
begin
  ARemoveu := false;
  if not assigned(FPageControl) then
    exit;

  id := Sender.GetID;
  nTab := -1;
  try
    for i := GetPageControl.PageCount - 1 downto 0 do
      if GetPageControl.Pages[i].InheritsFrom(TJvTabSheetStored) then
      begin
        tb := TJvTabSheetStored(GetPageControl.Pages[i]);
        if tb.FormID = id then
        begin
          nTab := i;
          ARemoveu := true;
          tb.free;
          break;
        end;
      end;
  except
  end;
  dec(nTab);
  if nTab >= 0 then
    GetPageControl.ActivePageIndex := nTab;

end;

procedure TPageControlController.NewPage(ACaption: String; Value: IMVCForm);
var
  tb: TJvTabSheetStored;
begin
  tb := NewPage;
  tb.Caption := ACaption;
  Value.Embbed(tb);
  tb.FormID := Value.GetID;
  Value.SetAlignForm(ord(alClient));
  tb.Invalidate;
end;

function TPageControlController.NewPage: TJvTabSheetStored;
begin
  result := TJvTabSheetStored.create(FPageControl);
  InitPage(result);
end;

procedure TPageControlController.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = TOperation.opRemove then
  begin
    if AComponent = FPageControl then
      FPageControl := nil;
  end;
end;

procedure TPageControlController.RegisterMenuItemControl(AParent: integer;
  ACaption: String; AIdAcesso: Int64; AProc: TProc);
begin
  if assigned(FOnRegisterMenuItem) then
    FOnRegisterMenuItem(AParent, ACaption, AIdAcesso, AProc);
end;

procedure TPageControlController.Remove(Value: IMVCContainerItem);
begin
  FContainer.Remove(Value);
end;

procedure TPageControlController.SetDatabasename(const Value: string);
begin
  FDatabasename := Value;
  UpdateAll;
end;

procedure TPageControlController.SetDirRelatorios(const Value: string);
begin
  FDirRelatorios := Value;
  UpdateAll;
end;

procedure TPageControlController.SetFilial(const Value: Double);
begin
  FFilial := Value;
  UpdateAll;
end;

procedure TPageControlController.SetOnRegisterMenuItem
  (const Value: TOnControllerRegisterMenuItemEvent);
begin
  FOnRegisterMenuItem := Value;
end;

procedure TPageControlController.SetPageControl(const Value: TComponent);
begin
  FPageControl := Value;
end;

procedure TPageControlController.UpdateAll;
begin
  FContainer.UpdateAll;
end;

{ TPageControlContainer }

function TPageControlContainer.AddForm(const ACaption: string;
  const AView: TPageControlContainerItem): integer;
begin
  AView.Add(AView);
end;

function TPageControlContainer.Find(AID: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if AID = items[i].Instance.GetID then
    begin
      result := i;
      exit;
    end;
end;

function TPageControlContainer.FindID(AID: string): IView;
var
  i: integer;
begin
  i := Find(AID);
  if i >= 0 then
    result := items[i].Instance;
end;

function TPageControlContainer.GetItem(const idx: integer)
  : TPageControlContainerItem;
begin

end;

end.
