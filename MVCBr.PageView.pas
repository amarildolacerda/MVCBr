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
  System.JSON,
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
  end;

  IPageViews = interface(IModel)
    ['{60605589-283D-4403-B434-D32A024BB049}']
    procedure SetPageContainer(const Value: TComponent);

    function GetPageContainer: TComponent;
    property PageContainer: TComponent read GetPageContainer
      write SetPageContainer;

    function GetItems(idx: Integer): IPageView;
    procedure SetItems(idx: Integer; const Value: IPageView);
    function Count: Integer;

    property Items[idx: Integer]: IPageView read GetItems write SetItems;
    function FindViewByID(Const AID: String): IPageView;
    function AddView(AView: IView): IPageView; overload;
    function AddView(Const AController: TGuid): IPageView; overload;
    function FindView(Const AGuid: TGuid): IPageView; overload;
    function FindView(Const AView: IView): IPageView; overload;
    function IndexOf(Const AGuid: TGuid): Integer;

  end;

  /// TPageControllerView - Atributos para o PageView
  TPageView = class(TMVCFactoryAbstract, IPageView)
  private
    FOwner: TCustomPageViewFactory;
    FText: string;
    FTab: TObject;
    FID: String;
    FView: IView;
    FController:IController;
    procedure SetText(const Value: string);
    function GetText: string;
    procedure SetTab(const Value: TObject);
    function GetTab: TObject;
    procedure SetView(const Value: IView);
  protected
    FClassType: TClass;
    procedure SetID(const Value: String); override;
  public
    Destructor Destroy;override;
    function GetOwner: TCustomPageViewFactory;
    function This: TPageView;
    property Text: string read GetText write SetText;
    property Tab: TObject read GetTab write SetTab;
    property ID: String read FID write SetID;
    property View: IView read FView write SetView;
    procedure Remove; virtual;
  end;

  /// Adaptador para associar a lista de View com o TPageControl ativo
  /// Cada View é mostrado em uma aba do PageControl
  TCustomPageViewFactory = class(TComponentFactory, IModel)
  private
    FActivePageIndex: Integer;
    FAfterViewCreate: TNotifyEvent;
    function GetItems(idx: Integer): IPageView;
    procedure SetItems(idx: Integer; const Value: IPageView);
    procedure SetActivePageIndex(const Value: Integer);
    procedure SetAfterViewCreate(const Value: TNotifyEvent);
  protected
    FPageContainer: TComponent;
    FList: IInterfaceList; // TMVCInterfacedList<IPageView>;
    procedure SetPageContainer(const Value: TComponent); virtual;
    function GetPageContainer: TComponent; virtual;
    /// ligação para o PageControl component
    property PageContainer: TComponent read GetPageContainer
      write SetPageContainer;
    procedure Init(APageView: IPageView); virtual;
    procedure Remove(APageView: IPageView); virtual;
    Procedure DoQueryClose(const APageView: IPageView;
      var ACanClose: Boolean); virtual;
    Procedure DoViewCreate(Sender: TObject); virtual;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;
  public
    destructor Destroy; override;
    procedure AfterConstruction; override;
    function NewTab(APageView: IPageView): TObject; virtual;
    function GetPageTabClass: TComponentClass; virtual;
    function GetPageContainerClass: TComponentClass; virtual;
    function Count: Integer;
    function ActivePage: IPageView; virtual;
    procedure SetActivePage(Const Tab: TObject); virtual;
    property ActivePageIndex: Integer read FActivePageIndex
      write SetActivePageIndex;

    property Items[idx: Integer]: IPageView read GetItems write SetItems;
    function PageViewIndexOf(APageView: IPageView): Integer;
    function NewItem(Const ACaption: string): IPageView; virtual;

    function AddView(AView: IView): IPageView; overload; virtual;
    function AddView(Const AController: TGuid): IPageView; overload; virtual;
    function AddView(Const AController: TGuid; ABeforeShow: TProc<IView>)
      : IPageView; overload; virtual;
    function AddForm(AClass: TFormClass): IPageView; virtual;

    function FindViewByID(Const AID: String): IPageView; virtual;
    function FindViewByClassName(const AClassName: String): IPageView; virtual;
    function FindView(Const AGuid: TGuid): IPageView; overload; virtual;
    function FindView(Const AView: IView): IPageView; overload; virtual;

    procedure ViewEvent(AMessage: TJsonValue);overload;virtual;
    procedure ViewEvent(AMessage: String);overload;virtual;

    function IndexOf(Const AGuid: TGuid): Integer;
    property AfterViewCreate: TNotifyEvent read FAfterViewCreate
      write SetAfterViewCreate;
  end;

implementation

{ TPageControllerView }

destructor TPageView.Destroy;
begin
  //FView := nil;
  //FController := nil;
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

procedure TPageView.Remove;
begin
  if assigned(FOwner) then
    FOwner.Remove(self);
end;

procedure TPageView.SetID(const Value: String);
begin
  FID := Value;
end;

procedure TPageView.SetTab(const Value: TObject);
begin
  FTab := Value;
end;

procedure TPageView.SetText(const Value: string);
begin
  FText := Value;
end;

procedure TPageView.SetView(const Value: IView);
begin
  FView := Value;
  FID := Value.GetID;
end;

function TPageView.This: TPageView;
begin
  result := self;
end;

{ TPageControlFactory }

function TCustomPageViewFactory.AddView(AView: IView): IPageView;
begin
  result := NewItem(AView.Title);
  result.This.View := AView;
  result.this.FController := AView.GetController;
  DoViewCreate(AView.This);
  Init(result);
end;

function TCustomPageViewFactory.ActivePage: IPageView;
begin
  result := FList.Items[FActivePageIndex] as IPageView;
end;

function TCustomPageViewFactory.AddForm(AClass: TFormClass): IPageView;
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
    result := AddView(vw);
    exit;
  end;
  // usa um stub para embeded de uma formulario como (sem IVIEW)
  result := AddView(TViewFactoryAdapter.New(ref, false));
end;

function TCustomPageViewFactory.AddView(Const AController: TGuid): IPageView;
begin
  result := AddView(AController, nil);
end;

function TCustomPageViewFactory.AddView(const AController: TGuid;
  ABeforeShow: TProc<IView>): IPageView;
var
  LController: IController;
  LView: IView;
begin
  result := nil;
  LController := ResolveController(AController);

  assert(assigned(LController), 'Parâmetro não é um controller');

  // checa se já existe uma aba para a mesma view
  LView := LController.GetView;
  if LView.GetController = nil then
    LView.SetController(LController);
  if not assigned(LView) then
    exit;

  result := FindView(LView);
  if assigned(result) then
  begin
    Init(result);
    exit;
  end;

  // criar nova aba
  if assigned(ABeforeShow) then
    ABeforeShow(LView);

  result := AddView(LView);

end;

procedure TCustomPageViewFactory.AfterConstruction;
begin
  inherited;
  FList := TMVCInterfacedList<IPageView>.Create;
end;

procedure TCustomPageViewFactory.DoQueryClose(const APageView: IPageView;
  var ACanClose: Boolean);
begin
  ACanClose := true;
end;

procedure TCustomPageViewFactory.DoViewCreate(Sender: TObject);
begin
  if assigned(FAfterViewCreate) then
    FAfterViewCreate(Sender);
end;

function TCustomPageViewFactory.Count: Integer;
begin
  result := FList.Count;
end;

destructor TCustomPageViewFactory.Destroy;
begin
  FList := nil; // .DisposeOf;
  inherited;
end;

function TCustomPageViewFactory.IndexOf(const AGuid: TGuid): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if supports(Items[i].This, AGuid) then
    begin
      result := i;
      exit;
    end;
end;

procedure TCustomPageViewFactory.Init(APageView: IPageView);
begin
end;

function TCustomPageViewFactory.FindView(const AGuid: TGuid): IPageView;
var
  i: Integer;
begin
  result := nil;
  i := IndexOf(AGuid);
  if i >= 0 then
    result := Items[i];
end;

function TCustomPageViewFactory.FindView(const AView: IView): IPageView;
var
  i: Integer;
begin
  result := nil;
  try
    for i := 0 to Count - 1 do
      if supports(Items[i].This, IPageView) then
        if Items[i].This.View = AView then
        begin
          result := Items[i];
          exit;
        end;
  except
  end;
end;

function TCustomPageViewFactory.FindViewByClassName(const AClassName: String)
  : IPageView;
var
  i: Integer;
  frm: TObject;
begin
  result := nil;
  for i := 0 to Count - 1 do
  begin
    if not assigned(Items[i].This.FView) then
      continue;
    if Items[i].This.View.This.InheritsFrom(TViewFactoryAdapter) then
      frm := TViewFactoryAdapter(Items[i].This.View.This).Form
    else
      frm := Items[i].This.FView.This;
    if sametext(frm.ClassName, AClassName) then
    begin
      result := Items[i];
      exit;
    end;
  end;
end;

function TCustomPageViewFactory.FindViewByID(const AID: String): IPageView;
var
  i: Integer;
begin
  result := nil;
  for i := 0 to FList.Count - 1 do
    if sametext(AID, (FList.Items[i] as IPageView).This.ID) then
    begin
      result := FList.Items[i] as IPageView;
      exit;
    end;
end;

function TCustomPageViewFactory.GetItems(idx: Integer): IPageView;
begin
  result := FList.Items[idx] as IPageView;
end;

function TCustomPageViewFactory.GetPageContainer: TComponent;
begin
  result := FPageContainer;
end;

function TCustomPageViewFactory.GetPageContainerClass: TComponentClass;
begin
  raise Exception.Create('Error: implements in inherited class');
end;

function TCustomPageViewFactory.GetPageTabClass: TComponentClass;
begin
  raise Exception.Create('Error: implements in inherited class');
end;

function TCustomPageViewFactory.NewItem(const ACaption: string): IPageView;
var
  obj: TPageView;
begin
  obj := TPageView.Create;
  FList.Add(obj);
  obj.FOwner := self;
  obj.Text := ACaption;
  obj.Tab := NewTab(obj);
  if obj.Tab <> nil then
    obj.FClassType := obj.Tab.ClassType;
  result := obj;
end;

function TCustomPageViewFactory.NewTab(APageView: IPageView): TObject;
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

function TCustomPageViewFactory.PageViewIndexOf(APageView: IPageView): Integer;
var
  i: Integer;
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

procedure TCustomPageViewFactory.Remove(APageView: IPageView);
var
  i: Integer;
begin
  if assigned(FList) then
    for i := FList.Count - 1 downto 0 do
      if APageView.This.ID = (FList.Items[i] as IPageView).This.ID then
      begin
        FList.Delete(i);
        exit;
      end;
end;

procedure TCustomPageViewFactory.SetActivePage(const Tab: TObject);
begin
  // implementar na class herdada;
end;

procedure TCustomPageViewFactory.SetActivePageIndex(const Value: Integer);
begin
  FActivePageIndex := Value;
end;

procedure TCustomPageViewFactory.SetAfterViewCreate(const Value: TNotifyEvent);
begin
  FAfterViewCreate := Value;
end;

procedure TCustomPageViewFactory.SetItems(idx: Integer; const Value: IPageView);
begin
  FList.Items[idx] := Value;
end;

procedure TCustomPageViewFactory.SetPageContainer(const Value: TComponent);
begin
  FPageContainer := Value;
end;

procedure TCustomPageViewFactory.ViewEvent(AMessage: String);
var
  i: Integer;
  LHandled: Boolean;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].This.FView.ViewEvent(AMessage, LHandled);
    if LHandled then
       exit; 
  end;
end;

procedure TCustomPageViewFactory.ViewEvent(AMessage: TJsonValue);
var
  i: Integer;
  LHandled: Boolean;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].This.FView.ViewEvent(AMessage, LHandled);
    if LHandled then
       exit; 
  end;
end;

end.
