unit MVCBr.UniFormView;

interface

uses
  System.Classes, System.SysUtils,
  MVCBr.Interf, MVCBr.View,
  System.Json, System.RTTI, System.UiTypes,
  uniGUIServer, uniGUIMainModule, uniGUIApplication,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm;

type

  TViewEventJsonNotify = procedure(AMessage: TJsonValue; var AHandled: boolean)
    of object;
  TViewCommandNotify = procedure(ACommand: string; const AArgs: array of TValue)
    of object;

  TUniGuiCloseEvent = procedure(sender: TObject; var Action: TCloseAction);

  TUniFormFactory = class(TUniForm, IView)
  private
    FShowModal: boolean;
    FID: string;
    [weak]
    FController: IController;
    [weak]
    FViewModel: IViewModel;
    FOnCommandEvent: TViewCommandNotify;
    FOnViewEvent: TViewEventJsonNotify;
    FOnViewUpdate: TNotifyEvent;
    FOnViewInit: TNotifyEvent;
    FOnCloseProc: TProc<IView>;
    FOnClose: TUniGuiCloseEvent;
    procedure SetOnCommandEvent(const Value: TViewCommandNotify);
    procedure SetOnViewEvent(const Value: TViewEventJsonNotify);
    procedure SetOnViewInit(const Value: TNotifyEvent);
    procedure SetOnViewUpdate(const Value: TNotifyEvent);
    procedure DoCloseView(sender: TObject; var ACloseAction: TCloseAction);
    procedure SetOnClose(const Value: TUniGuiCloseEvent);
  protected
    // IMVCIOC
    procedure release;

    // IMVCBBase
    [weak]
    function ApplicationControllerInternal: IApplicationController;
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
    property PropertyValue[ANome: string]: TValue read GetPropertyValue
      write SetPropertyValue;
    function GetGuid(AII: IInterface): TGuid;

    // IViewBase
    function This: TObject;
    function ThisAs: TUniFormFactory; virtual;
    function ShowView(const AProc: TProc<IView>): integer; overload; virtual;
    [weak]
    function ShowView(): IView; overload; virtual;
    [weak]
    function UpdateView: IView; virtual;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean); overload;

    // IView
    [weak]
    function ViewEvent(AMessage: string; var AHandled: boolean): IView;
      overload;
    [weak]
    function ViewEvent(AMessage: TJsonValue; var AHandled: boolean)
      : IView; overload;
    [weak]
    function Controller(const AController: IController): IView;
    [weak]
    function GetController: IController;
    procedure SetController(const AController: IController);
    [weak]
    function GetModel(AII: TGuid): IModel; overload;
    [weak]
    function GetViewModel: IViewModel;
    procedure SetViewModel(const AViewModel: IViewModel);
    function GetID: string;
    function GetTitle: String;
    procedure SetTitle(Const AText: String);
    property Title: string read GetTitle write SetTitle;
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); virtual;
    [weak]
    function ShowView(const AProcBeforeShow: TProc<IView>; AShowModal: boolean)
      : IView; overload;
    [weak]
    function ShowView(const AProcBeforeShow: TProc<IView>;
      const AProcOnClose: TProc<IView>): IView; overload; virtual;
    procedure UpdateObserver(AJson: TJsonValue); overload;
    procedure UpdateObserver(AName: string; AJson: TJsonValue); overload;
    procedure Init;

    property OnClose: TUniGuiCloseEvent read FOnClose write SetOnClose;

    // extra
    [weak]
    function ResolveController<TIController: IController>: TIController;
    [weak]
    function GetModel<TIModel>: TIModel; overload;

  published
    property OnViewInit: TNotifyEvent read FOnViewInit write SetOnViewInit;
    property OnViewEvent: TViewEventJsonNotify read FOnViewEvent
      write SetOnViewEvent;
    property OnViewCommand: TViewCommandNotify read FOnCommandEvent
      write SetOnCommandEvent;
    property OnViewUpdate: TNotifyEvent read FOnViewUpdate
      write SetOnViewUpdate;

  end;

{$IFNDEF BPL}

function TMVCBrUniMainModule: TUniGUIServerModuleClass;
procedure SetMVCBrUniMainModule(AClass: TUniGUIServerModuleClass);
{$ENDIF}

implementation

{$IFNDEF BPL}

uses MVCBr.ApplicationController;

var
  LGuiServerModule: TUniGUIServerModuleClass;

procedure SetMVCBrUniMainModule(AClass: TUniGUIServerModuleClass);
begin
  LGuiServerModule := AClass;
end;

function TMVCBrUniMainModule: TUniGUIServerModuleClass;
begin
  result := LGuiServerModule;
end;
{$ENDIF}
{ TUniViewFactory }

function TUniFormFactory.ApplicationControllerInternal: IApplicationController;
begin
{$IFNDEF BPL}
  result := MVCBr.ApplicationController.ApplicationController
{$ENDIF}
end;

function TUniFormFactory.Controller(const AController: IController): IView;
begin
  result := self;
  SetController(AController);
end;

procedure TUniFormFactory.DoCommand(ACommand: string;
  const AArgs: array of TValue);
begin

end;

function TUniFormFactory.GetController: IController;
begin
  result := FController;
end;

function TUniFormFactory.GetGuid(AII: IInterface): TGuid;
begin
  result := TMVCBr.GetGuid(AII);
end;

function TUniFormFactory.GetID: string;
begin
  result := FID;
end;

function TUniFormFactory.GetModel(AII: TGuid): IModel;
begin
  FController.GetModel(AII, result);
end;

function TUniFormFactory.GetPropertyValue(ANome: string): TValue;
begin
  result := TMVCBr.GetProperty(self, ANome);
end;

function TUniFormFactory.GetTitle: String;
begin
  result := Caption;
end;

function TUniFormFactory.GetViewModel: IViewModel;
begin
  result := FViewModel;
end;

procedure TUniFormFactory.Init;
begin
  // if not assigned(FController) then
  // raise Exception.Create('Não tem um controller associado');
end;

procedure TUniFormFactory.release;
begin
  FController := nil;
end;

function TUniFormFactory.ResolveController<TIController>: TIController;
begin
{$IFNDEF BPL}
  result := TApplicationController(ApplicationControllerInternal.This)
    .ResolveController<TIController>;
{$ENDIF}
end;

procedure TUniFormFactory.SetController(const AController: IController);
begin
  FController := AController;
end;

procedure TUniFormFactory.SetOnClose(const Value: TUniGuiCloseEvent);
begin
  FOnClose := Value;
end;

procedure TUniFormFactory.SetOnCommandEvent(const Value: TViewCommandNotify);
begin
  FOnCommandEvent := Value;
end;

procedure TUniFormFactory.SetOnViewEvent(const Value: TViewEventJsonNotify);
begin
  FOnViewEvent := Value;
end;

procedure TUniFormFactory.SetOnViewInit(const Value: TNotifyEvent);
begin
  FOnViewInit := Value;
end;

procedure TUniFormFactory.SetOnViewUpdate(const Value: TNotifyEvent);
begin
  FOnViewUpdate := Value;
end;

procedure TUniFormFactory.SetPropertyValue(ANome: string; const Value: TValue);
begin
  TMVCBr.SetProperty(self, ANome, Value);
end;

procedure TUniFormFactory.SetTitle(const AText: String);
begin
  Caption := AText;
end;

procedure TUniFormFactory.SetViewModel(const AViewModel: IViewModel);
begin
  FViewModel := AViewModel;
end;

procedure TUniFormFactory.DoCloseView(sender: TObject;
  var ACloseAction: TCloseAction);
begin
  if assigned(FOnCloseProc) then
    FOnCloseProc(self);
  if assigned(FOnClose) then
    FOnClose(sender, ACloseAction);
end;

function TUniFormFactory.ShowView(const AProcBeforeShow,
  AProcOnClose: TProc<IView>): IView;
begin
  FOnCloseProc := AProcOnClose;
  inherited OnClose := DoCloseView;
  result := self;
  if assigned(AProcBeforeShow) then
    AProcBeforeShow(self);

  if FShowModal then
    TUniForm(ThisAs).showModal
  else
    TUniForm(ThisAs).Show;
end;

function TUniFormFactory.ShowView(const AProc: TProc<IView>): integer;
begin
  result := -1;
  FShowModal := true;
  ShowView(AProc, nil);
  result := 0;
end;

function TUniFormFactory.ShowView: IView;
begin
  result := self;
  FShowModal := true;
  ShowView(nil, nil);
end;

function TUniFormFactory.This: TObject;
begin
  result := self;
end;

function TUniFormFactory.ThisAs: TUniFormFactory;
begin
  result := self;
end;

function TUniFormFactory.ShowView(const AProcBeforeShow: TProc<IView>;
  AShowModal: boolean): IView;
begin
  result := self;
  FShowModal := AShowModal;
  ShowView(AProcBeforeShow, nil);
end;

procedure TUniFormFactory.UpdateObserver(AJson: TJsonValue);
begin

end;

procedure TUniFormFactory.Update(AJsonValue: TJsonValue; var AHandled: boolean);
begin
  ViewEvent(AJsonValue, AHandled);

end;

procedure TUniFormFactory.UpdateObserver(AName: string; AJson: TJsonValue);
begin

end;

function TUniFormFactory.UpdateView: IView;
begin
  result := self;
end;

function TUniFormFactory.ViewEvent(AMessage: string;
  var AHandled: boolean): IView;
begin

end;

function TUniFormFactory.ViewEvent(AMessage: TJsonValue;
  var AHandled: boolean): IView;
begin
  result := self;
end;

function TUniFormFactory.GetModel<TIModel>: TIModel;
begin
  result := FController.This.GetModel<TIModel>;
end;

end.
