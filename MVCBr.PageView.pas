/// <summary>
/// PageView é adapter para gerar controller para PageViews Abstract
/// </summary>
unit MVCBr.PageView;
{ *************************************************************************** }
{ }
{ MVCBr é o resultado de esforços de um grupo }
{ }
{ Copyright (C) 2017 MVCBr }
{ }
{ amarildo lacerda }
{ http://www.tireideletra.com.br }
{ }
{ }
{ *************************************************************************** }
{ }
{ Licensed under the Apache License, Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. }
{ You may obtain a copy of the License at }
{ }
{ http://www.apache.org/licenses/LICENSE-2.0 }
{ }
{ Unless required by applicable law or agreed to in writing, software }
{ distributed under the License is distributed on an "AS IS" BASIS, }
{ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{ See the License for the specific language governing permissions and }
{ limitations under the License. }
{ }
{ *************************************************************************** }

interface

uses {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, System.SysUtils, MVCBr.Interf, MVCBr.Controller,
  System.JSON, System.Generics.Collections,
  System.ThreadSafe,
  MVCBr.Component, MVCBr.FormView;

type
  TPageView = class;
  TCustomPageViewFactory = class;

  IPageView = interface
    ['{FCAA865A-3ED1-46B2-AFCA-627F511B3A2C}']
    function This: TPageView;
    procedure Remove;
    procedure SetTab(const Value: TObject);
    function GetTab: TObject;
    property Tab: TObject read GetTab write SetTab;
    procedure SetPageIndex(const idx: integer);
  end;

  IPageViews = interface(IModel)
    ['{60605589-283D-4403-B434-D32A024BB049}']
    procedure SetPageContainer(const Value: TComponent);

    function GetPageContainer: TComponent;
    property PageContainer: TComponent read GetPageContainer
      write SetPageContainer;

    function GetItems(idx: integer): TPageView;
    procedure SetItems(idx: integer; const Value: TPageView);
    function Count: integer;

    property Items[idx: integer]: TPageView read GetItems write SetItems;
    function FindViewByID(Const AID: String): TPageView;
    function AddView(AView: IView): TPageView; overload;
    function AddView(AView: IView; AProc: TProc<IView>): TPageView; overload;
    function AddView(Const AController: TGuid): TPageView; overload;
    function FindView(Const AGuid: TGuid): TPageView; overload;
    function FindView(Const AView: IView): TPageView; overload;
    function IndexOf(Const AGuid: TGuid): integer;

  end;

  /// TPageControllerView - Atributos para o PageView
  TPageView = class(TInterfacedObject, IPageView)
  strict private
    FController: IController;
  private
    FView: TObject;
    FOwner: TCustomPageViewFactory;
    FText: string;
    FTab: TObject;
    FID: String;
    FOnBeforeShowDelegate: TProc<IView>;
    FGuid: TGuid;
    FControllerGuid: TGuid;
    procedure SetText(const Value: string);
    function GetText: string;
    procedure SetTab(const Value: TObject);
    function GetTab: TObject;
    procedure SetOnBeforeShowDelegate(const Value: TProc<IView>);
    procedure SetController(const Value: IController);
    function GetView: TObject;
    procedure SetGuid(const Value: TGuid);
    procedure SetControllerGuid(const Value: TGuid);
  protected
    FReleased: Boolean;
    FClassType: TClass;
    FOnClose: TProc<TObject>;
    procedure SetID(const Value: String);
  public
    Destructor Destroy; override;
    function GetOwner: TCustomPageViewFactory;
    function This: TPageView;
    property Text: string read GetText write SetText;
    property Tab: TObject read GetTab write SetTab;
    property ID: String read FID write SetID;
    property View: TObject read GetView;
    property Guid: TGuid read FGuid write SetGuid;
    property ControllerGuid: TGuid read FControllerGuid write SetControllerGuid;
    property Controller: IController read FController write SetController;
    procedure Remove; virtual;
    procedure SetPageIndex(const idx: integer); virtual;
    property OnCloseDelegate: TProc<TObject> read FOnClose write FOnClose;
    property OnBeforeShowDelegate: TProc<IView> read FOnBeforeShowDelegate
      write SetOnBeforeShowDelegate;
  end;

  TPageViewClass = class of TPageView;

  /// Adaptador para associar a lista de View com o TPageControl ativo
  /// Cada View é mostrado em uma aba do PageControl
  TCustomPageViewFactory = class(TComponentFactory, IModel)
  private
    FActivePageIndex: integer;
    FAfterViewCreate: TNotifyEvent;
    function GetItems(idx: integer): TPageView;
    procedure SetItems(idx: integer; const Value: TPageView);
    procedure SetActivePageIndex(const Value: integer);
    procedure SetAfterViewCreate(const Value: TNotifyEvent);
    function IndexOfController(AGuid: TGuid): integer;
  protected
    FPageContainer: TComponent;
    FList: TThreadSafeObjectList<TPageView>;
    function GetPageViewClass: TPageViewClass; virtual;
    procedure SetPageContainer(const Value: TComponent); virtual;
    function GetPageContainer: TComponent; virtual;
    /// ligação para o PageControl component
    property PageContainer: TComponent read GetPageContainer
      write SetPageContainer;
    procedure Init(APageView: TPageView); virtual;
    Procedure DoQueryClose(const APageView: TPageView;
      var ACanClose: Boolean); virtual;
    Procedure DoViewCreate(Sender: TObject); virtual;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;
  public
    destructor Destroy; override;
    procedure AfterConstruction; override;
    function NewTab(APageView: TPageView;ACaption:String=''): TObject; virtual;
    function GetPageTabClass: TComponentClass; virtual;
    function GetPageContainerClass: TComponentClass; virtual;
    function Count: integer;
    procedure Remove(APageView: TPageView); overload; virtual;
    procedure Remove(AGuid: TGuid); overload; virtual;
    function ActivePage: TPageView; virtual;
    procedure SetActivePage(Const Tab: TObject); virtual;
    property ActivePageIndex: integer read FActivePageIndex
      write SetActivePageIndex;

    property Items[idx: integer]: TPageView read GetItems write SetItems;
    function PageViewIndexOf(APageView: TPageView): integer;
    function NewItem(Const ACaption: string): TPageView; virtual;

    function AddView(AView: IView; ABeforeShow: TProc<IView>): TPageView;
      overload; virtual;
    function AddView(AView: IView): TPageView; overload; virtual;
    function AddView(Const AController: TGuid): TPageView; overload; virtual;
    function AddView(Const AController: TGuid; ABeforeShow: TProc<IView>)
      : TPageView; overload; virtual;
    function AddForm(AClass: TFormClass; ABoforeShow: TProc<IView>)
      : TPageView; virtual;

    function FindViewByID(Const AID: String): TPageView; virtual;
    function FindViewByClassName(const AClassName: String): TPageView; virtual;
    function FindView(Const AGuidController: TGuid): TPageView;
      overload; virtual;
    function FindView(Const AView: IView): TPageView; overload; virtual;

    procedure ViewEvent(AMessage: TJsonValue); overload; virtual;
    procedure ViewEvent(AMessage: String); overload; virtual;

    function IndexOf(Const AGuidController: TGuid): integer;
    property AfterViewCreate: TNotifyEvent read FAfterViewCreate
      write SetAfterViewCreate;
  end;

implementation

{ TPageControllerView }

destructor TPageView.Destroy;
begin
  if FReleased then
    exit;
  FReleased := true;
  if assigned(OnCloseDelegate) then
    OnCloseDelegate(self);
  /// controle da instancia é feito no controller
  FView := nil;
  FController := nil;
  inherited;
end;

function TPageView.GetOwner: TCustomPageViewFactory;
begin
  result := FOwner;
end;

function TPageView.GetTab: TObject;
begin
  result := FTab;
end;

function TPageView.GetText: string;
begin
  result := FText;
end;

function TPageView.GetView: TObject;
begin
  result := FView;
end;

procedure TPageView.Remove;
begin
  if assigned(FOwner) then
    FOwner.Remove(self);
end;

procedure TPageView.SetController(const Value: IController);
var
  v: IView;
begin
  FController := Value;
  if assigned(Value) then
  begin
    v := Value.GetView;
    if assigned(Value) and (v <> nil) then
    begin
      FView := v.This;
      FID := v.GetID;
    end;
  end;
end;

procedure TPageView.SetControllerGuid(const Value: TGuid);
begin
  FControllerGuid := Value;
end;

procedure TPageView.SetGuid(const Value: TGuid);
begin
  FGuid := Value;
end;

procedure TPageView.SetID(const Value: String);
begin
  FID := Value;
end;

procedure TPageView.SetOnBeforeShowDelegate(const Value: TProc<IView>);
begin
  FOnBeforeShowDelegate := Value;
end;

procedure TPageView.SetPageIndex(const idx: integer);
begin

end;

procedure TPageView.SetTab(const Value: TObject);
begin
  FTab := Value;
end;

procedure TPageView.SetText(const Value: string);
begin
  FText := Value;
end;

function TPageView.This: TPageView;
begin
  result := self;
end;

{ TPageControlFactory }

function TCustomPageViewFactory.AddView(AView: IView; ABeforeShow: TProc<IView>)
  : TPageView;
var
  ATitle: String;
begin
  if AView.Title <> '' then
    ATitle := AView.Title
  else if AView.This.InheritsFrom(TForm) then
    ATitle := TForm(AView.This).Caption;

  result := NewItem(ATitle);
  result.Controller := AView.GetController;
  result.FView := AView.This;
  result.Guid := TMVCBr.GetGuid(AView);
  result.OnBeforeShowDelegate := ABeforeShow;
  DoViewCreate(AView.This);
  Init(result);
  if assigned(AView) then
    AView.DoCommand('pageview', []);

end;

function TCustomPageViewFactory.ActivePage: TPageView;
begin
  result := FList { .Items } [FActivePageIndex];
end;

function TCustomPageViewFactory.AddForm(AClass: TFormClass;
  ABoforeShow: TProc<IView>): TPageView;
var
  ref: TForm;
  vw: IView;
begin
  // checa se o formulario ja esta carregao e reutiliza
  result := FindViewByClassName(AClass.ClassName);
  if assigned(result) then
  begin
    SetActivePage(result.This.FTab);
    exit;
  end;
  // instancia novo formulario
  ref := AClass.Create(self);
  if supports(ref, IView, vw) then
  begin
    result := AddView(vw, ABoforeShow);
    exit;
  end;
  // usa um stub para embeded de uma formulario como (sem IVIEW)
  result := AddView(TViewFactoryAdapter.New(ref, false), ABoforeShow);
end;

function TCustomPageViewFactory.AddView(Const AController: TGuid): TPageView;
begin
  result := AddView(AController, nil);
end;

function TCustomPageViewFactory.IndexOfController(AGuid: TGuid): integer;
var
  i: integer;
  d: string;
begin
  result := -1;
  d := AGuid.ToString;
  for i := 0 to FList.Count - 1 do
    if sametext(FList.Items[i].ControllerGuid.ToString, d) then
    begin
      result := i;
      exit;
    end;
end;

function TCustomPageViewFactory.AddView(const AController: TGuid;
  ABeforeShow: TProc<IView>): TPageView;
var
  LController: IController;
  LView: IView;
  LGuid: TGuid;
  LPageView: TPageView;
begin
  result := nil;

  if IndexOfController(AController) >= 0 then
  begin
    LPageView := FindView(AController);
    if assigned(LPageView) and assigned(LPageView.Tab) then
      SetActivePage(LPageView.Tab);
    result := LPageView;
    exit;
  end;

  LController := ResolveController(AController);

  if not assigned(LController) then
    raise exception.Create
      ('Parâmetro não é um controller ou não pertence ao projeto.');

  // checa se já existe uma aba para a mesma view
  LView := LController.GetView;
  if not assigned(LView) then
    exit;

  if LView.GetController = nil then
    LView.SetController(LController);
  result := FindView(LView);

  if assigned(result) then
  begin
    Init(result);
    exit;
  end;

  result := AddView(LView, ABeforeShow);
  result.ControllerGuid := AController;

end;

function TCustomPageViewFactory.AddView(AView: IView): TPageView;
begin
  result := AddView(AView, nil);
end;

procedure TCustomPageViewFactory.AfterConstruction;
begin
  inherited;
  FList := TThreadSafeObjectList<TPageView>.Create;
end;

procedure TCustomPageViewFactory.DoQueryClose(const APageView: TPageView;
  var ACanClose: Boolean);
begin
  ACanClose := true;
end;

procedure TCustomPageViewFactory.DoViewCreate(Sender: TObject);
begin
  if assigned(FAfterViewCreate) then
    FAfterViewCreate(Sender);
end;

function TCustomPageViewFactory.Count: integer;
begin
  result := FList.Count;
end;

destructor TCustomPageViewFactory.Destroy;
begin
  FPageContainer := nil;
  FList.DisposeOf;
  inherited;
end;

function TCustomPageViewFactory.IndexOf(const AGuidController: TGuid): integer;
var
  i: integer;
  obj: TPageView;
  p: string;
begin
  result := -1;
  p := AGuidController.ToString;
  for i := 0 to Count - 1 do
  begin
    obj := TPageView(Items[i]);
    if obj.ControllerGuid.ToString = p then
    begin
      result := i;
      exit;
    end;
  end;
end;

procedure TCustomPageViewFactory.Init(APageView: TPageView);
begin
end;

function TCustomPageViewFactory.FindView(const AGuidController: TGuid)
  : TPageView;
var
  i: integer;
begin
  result := nil;
  i := IndexOf(AGuidController);
  if i >= 0 then
    result := Items[i];
end;

function TCustomPageViewFactory.FindView(const AView: IView): TPageView;
var
  i: integer;
  obj: TObject;
begin
  result := nil;
  try
    for i := 0 to Count - 1 do
    begin
      obj := Items[i];
      if obj.InheritsFrom(TPageView) then
        if Items[i].View.Equals(AView.This) then
        begin
          result := Items[i];
          exit;
        end;
    end;
  except
  end;
end;

function TCustomPageViewFactory.FindViewByClassName(const AClassName: String)
  : TPageView;
var
  i: integer;
  frm: TObject;
begin
  result := nil;
  for i := 0 to Count - 1 do
  begin
    if not assigned(Items[i].View) then
      continue;
    if Items[i].This.View.InheritsFrom(TViewFactoryAdapter) then
      frm := TViewFactoryAdapter(Items[i].This.View).Form
    else
      frm := Items[i].View;
    if sametext(frm.ClassName, AClassName) then
    begin
      result := Items[i];
      exit;
    end;
  end;
end;

function TCustomPageViewFactory.FindViewByID(const AID: String): TPageView;
var
  i: integer;
begin
  result := nil;
  for i := 0 to FList.Count - 1 do
    if sametext(AID, FList.Items[i].ID) then
    begin
      result := FList.Items[i];
      exit;
    end;
end;

function TCustomPageViewFactory.GetItems(idx: integer): TPageView;
begin
  result := FList.Items[idx];
end;

function TCustomPageViewFactory.GetPageContainer: TComponent;
begin
  result := FPageContainer;
end;

function TCustomPageViewFactory.GetPageContainerClass: TComponentClass;
begin
  raise exception.Create('Error: implements in inherited class');
end;

function TCustomPageViewFactory.GetPageTabClass: TComponentClass;
begin
  raise exception.Create('Error: implements in inherited class');
end;

function TCustomPageViewFactory.GetPageViewClass: TPageViewClass;
begin
  result := TPageView;
end;

function TCustomPageViewFactory.NewItem(const ACaption: string): TPageView;
begin
  result := GetPageViewClass.Create;
  FList.Add(result);
  result.FOwner := self;
  result.Text := ACaption;
  result.Tab := NewTab(result,ACaption);
  if result.Tab <> nil then
    result.FClassType := result.Tab.ClassType;
end;

function TCustomPageViewFactory.NewTab(APageView: TPageView;ACaption:String=''): TObject;
begin
  result := GetPageTabClass.Create(nil);
end;

procedure TCustomPageViewFactory.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;
  if AOperation = TOperation.opRemove then
    if AComponent = FPageContainer then
      FPageContainer := nil;
end;

function TCustomPageViewFactory.PageViewIndexOf(APageView: TPageView): integer;
var
  i: integer;
begin
  result := -1;
  if not assigned(APageView) then
    exit;

  for i := 0 to FList.Count - 1 do
  begin
    if APageView.Tab.Equals(Items[i].Tab) then
    begin
      result := i;
      exit;
    end;
  end;
end;

procedure TCustomPageViewFactory.Remove(AGuid: TGuid);
var
  i: integer;
begin
  if assigned(FList) then
    for i := FList.Count - 1 downto 0 do
      if AGuid.ToString = FList.Items[i].ControllerGuid.ToString then
      begin
        FList.Delete(i);
        exit;
      end;
end;

procedure TCustomPageViewFactory.Remove(APageView: TPageView);
var
  i: integer;
begin
  if assigned(FList) then
    for i := FList.Count - 1 downto 0 do
      if APageView.ControllerGuid.ToString = FList.Items[i].ControllerGuid.ToString
      then
      begin
        FList.Delete(i);
        exit;
      end;
end;

procedure TCustomPageViewFactory.SetActivePage(const Tab: TObject);
begin
  // implementar na class herdada;
end;

procedure TCustomPageViewFactory.SetActivePageIndex(const Value: integer);
begin
  FActivePageIndex := Value;
end;

procedure TCustomPageViewFactory.SetAfterViewCreate(const Value: TNotifyEvent);
begin
  FAfterViewCreate := Value;
end;

procedure TCustomPageViewFactory.SetItems(idx: integer; const Value: TPageView);
begin
  FList.Items[idx] := Value;
end;

procedure TCustomPageViewFactory.SetPageContainer(const Value: TComponent);
begin
  FPageContainer := Value;
end;

procedure TCustomPageViewFactory.ViewEvent(AMessage: String);
var
  i: integer;
  LHandled: Boolean;
  v: IView;
begin
  for i := 0 to Count - 1 do
  begin
    if supports(Items[i].View, IView, v) then
      v.ViewEvent(AMessage, LHandled);
    v := nil;
    if LHandled then
      exit;
  end;
end;

procedure TCustomPageViewFactory.ViewEvent(AMessage: TJsonValue);
var
  i: integer;
  LHandled: Boolean;
  v: IView;
begin
  for i := 0 to Count - 1 do
  begin
    if supports(Items[i].View, IView, v) then
      v.ViewEvent(AMessage, LHandled);
    v := nil;
    if LHandled then
      exit;
  end;
end;

end.
