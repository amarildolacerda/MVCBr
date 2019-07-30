/// <summary>
/// MVCBr.FormView - implements base class of FormView
/// Auth: amarildo lacerda
/// Date: jan/2017
/// </summary>

unit MVCBr.FormView;
{ *************************************************************************** }
{ }
{ MVCBr � o resultado de esfor�os de um grupo }
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

uses {$IFDEF LINUX} {$ELSE}
{$IFDEF FMX} FMX.Types, FMX.Forms, System.UiTypes, FMX.Controls,
{$ELSE} VCL.Forms, VCL.Controls, {$ENDIF}{$ENDIF}
  System.Classes, System.SysUtils, System.RTTI, System.JSON,
  MVCBr.ApplicationController, MVCBr.Interf, MVCBr.View;

type

{$IFDEF FMX}
  TFormClass = class of TForm;
  TBaseControl = TControl;
{$ELSE}
{$IFDEF LINUX}
  TBaseControl = TComponent;
{$ELSE}
  TBaseControl = TWinControl;
{$ENDIF}
{$ENDIF}
  TViewFactoryAdapter = class;

  IViewAdpater = interface(IView)
    ['{A5FCFDC8-67F2-4202-AED1-95314077F28F}']
    function Form: {$IFDEF LINUX} TComponent {$ELSE} TForm{$ENDIF};
    function ThisAs: TViewFactoryAdapter;
  end;

  /// <summary>
  /// TViewFactoryAdpater � um conector para receber um FORM,
  /// a ser utilizado para formularios que n�o herdam diretamente de TFormFactory
  /// </summary>
  TViewFactoryAdapter = class(TViewFactory, IViewAdpater)
  private
    FisShowModal: boolean;
    FOnProc: TProc<IView>;
    procedure SetisShowModal(const Value: boolean);
  protected
    FForm: {$IFDEF LINUX} TComponent {$ELSE} TForm{$ENDIF};
{$IFDEF LINUX}
{$ELSE}
    procedure DoClose(Sender: TObject; var Action: TCloseAction);
{$ENDIF}
  public
    class function New(AClass: {$IFDEF LINUX} TComponentClass
{$ELSE} TFormClass{$ENDIF}; const AShowModal: boolean = true): IView; overload;
    class function New(AForm: {$IFDEF LINUX} TComponent
{$ELSE} TForm{$ENDIF}; const AShowModal: boolean = true): IView; overload;
    property isShowModal: boolean read FisShowModal write SetisShowModal;
    function ShowView(const AProc: TProc<IView>): Integer; override;
    function Form: {$IFDEF LINUX} TComponent {$ELSE} TForm{$ENDIF};
    function ThisAs: TViewFactoryAdapter;
    function This: TObject; override;
  end;

  TViewEventJsonNotify = procedure(AMessage: TJsonValue; var AHandled: boolean)
    of object;
  TViewCommandNotify = procedure(ACommand: string; const AArgs: array of TValue)
    of object;

  /// <summary>
  /// TFormFactory � utilizado para heran�a dos TForms para transformar o FORM em VIEW no MVCBr
  /// </summary>
  TCustomFormFactory = class({$IFDEF LINUX} TComponent{$ELSE} TForm{$ENDIF},
    IMVCBrBase, IView, IMVCBrObserver, IMVCBrTest)
  private
    FTimeInit: TDateTime;
    FEventRef: Integer;
    FID: string;
    FOnViewEvent: TViewEventJsonNotify;
    FOnCommandEvent: TViewCommandNotify;
    FOnViewUpdate: TNotifyEvent;
    FOnViewInit: TNotifyEvent;

{$IFDEF LINUX}
    FCaption: string;
{$ELSE}
    FOnClose: TCloseEvent;
    procedure SetOnClose(const Value: TCloseEvent);
{$ENDIF}
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
    procedure SetOnViewEvent(const Value: TViewEventJsonNotify);
    procedure SetOnCommandEvent(const Value: TViewCommandNotify);
    procedure SetOnViewUpdate(const Value: TNotifyEvent);
    procedure SetOnViewInit(const Value: TNotifyEvent);
  protected
    FOnCloseProc: TProc<IView>;
    [weak]
    FController: IController;
    FShowModal: boolean;
    // FViewModel:IViewModel;
{$IFDEF LINUX}
{$ELSE}
    procedure DoCloseView(Sender: TObject; var ACloseAction: TCloseAction);
{$ENDIF}
    function RefCount: Integer;
    procedure SetController(const AController: IController);
    function Controller(const AController: IController): IView; virtual;
    procedure SetShowModal(const AShowModal: boolean);
    /// Retorna se a apresenta��o do formul�rio � ShowModal
    function GetShowModal: boolean;
    function GetTitle: string; virtual;
    procedure SetTitle(const Value: string); virtual;
  public
    procedure AfterConstruction; override;
    procedure Init; virtual;
    class function IsClosing: boolean;
    class procedure SetClosing(AValue: boolean);
    function FindControl<T: Class>(AControl: TBaseControl; AName: String): T;
    [weak]
    function ApplicationControllerInternal: IApplicationController;
    function ApplicationController: TApplicationController;
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create; reintroduce; overload;
    destructor Destroy; override;
    procedure Release; virtual;
    function GetGuid(AII: IInterface): TGuid;
    [weak]
    function ViewEvent(AMessage: string; var AHandled: boolean): IView;
      overload; virtual;
    [weak]
    function ViewEvent(AMessage: TJsonValue; var AHandled: boolean): IView;
      overload; virtual;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean);
      overload; virtual;
    procedure Update; overload; virtual;
    [weak]
    function MainViewEvent(AMessage: string; var AHandled: boolean)
      : IView; virtual;
    [weak]
    function ViewEventOther(AMessage: string; var AHandled: boolean): IView;
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); virtual;
    function GetID: string;
    property isShowModal: boolean read GetShowModal write SetShowModal;
    /// Retorna o controller ao qual a VIEW esta conectada
    [weak]
    function GetController: IController; virtual;
    [weak]
    function AttachController(AGuidController: TGuid;
      AOwnedFree: boolean = true): IController; overload; virtual;
    [weak]
    function AttachController<TIController: IInterface>: TIController; overload;
    [weak]
    function AttachModel<TIModel: IModel>(AModelClass
      : TModelFactoryAbstractClass): TIModel;
    /// Retorna o SELF
    function This: TObject; virtual;
    /// Executa um method gen�rico do FORM/VIEW
    [weak]
    function InvokeMethod<T>(AMethod: string; const Args: TArray<TValue>): T;
    [weak]
    function ResolveController(const IID: TGuid): IController;
      overload; virtual;
    procedure RevokeController(IID: TGuid); overload;
    procedure RevokeController(TIController: IController); overload;
    [weak]
    function ResolveController<TIController: IController>
      : TIController; overload;
    [weak]
    function GetModel<TIModel>: TIModel; overload;
    [weak]
    function GetModel(AII: TGuid): IModel; overload;
    /// Obter ou Alterar o valor de uma propriedade do ObjetoClass  (VIEW)
    property PropertyValue[ANome: string]: TValue read GetPropertyValue
      write SetPropertyValue;
    [weak]
    function GetView<TIView: IInterface>: TIView; overload;
    [weak]
    function FindView(AGuid: TGuid): IView;
    /// Apresenta o VIEW para o usuario
    [weak]
    function ShowView(const IIDController: TGuid;
      const AProcBeforeShow: TProc<IView>; const AProcONClose: TProc<IView>)
      : IView; overload; virtual;
    function ShowView(const AProcBeforeShow: TProc<IView>): Integer;
      overload; virtual;
    [weak]
    function ShowView(const AProcBeforeShow: TProc<IView>; AShowModal: boolean)
      : IView; overload; virtual;
    [weak]
    function ShowView(const AProcBeforeShow: TProc<IView>;
      const AProcONClose: TProc<IView>): IView; overload; virtual;
    [weak]
    function ShowView(const IIDController: TGuid;
      const AProcBeforeShow: TProc<IView>): IView; overload; virtual;
    [weak]
    function ShowView(const IIDController: TGuid): IView; overload; virtual;
    [weak]
    function ShowView(): IView; overload;
    procedure SetViewModel(const AViewModel: IViewModel); virtual;
    [weak]
    function GetViewModel: IViewModel; virtual;
    /// Evento para atualizar os dados da VIEW
    [weak]
    function UpdateView: IView; virtual;

    procedure UpdateObserver(AJson: TJsonValue); overload; virtual;
    procedure UpdateObserver(AName: string; AJson: TJsonValue);
      overload; virtual;
    procedure UpdateObserver(AName: string; AMensagem: String);
      overload; virtual;
    [weak]
    function Observable: IMVCBrObservable; virtual;
    procedure RegisterObserver(const AName: String);
    procedure UnRegisterObserver(const AName: String);
    procedure Notify(ACommand: string; AJson: TJsonValue);
    property Text: string read GetTitle write SetTitle;

{$IFDEF LINUX}
{$ELSE}
    property OnClose: TCloseEvent read FOnClose write SetOnClose;
{$ENDIF}
    property OnViewInit: TNotifyEvent read FOnViewInit write SetOnViewInit;
    property OnViewEvent: TViewEventJsonNotify read FOnViewEvent
      write SetOnViewEvent;
    property OnViewCommand: TViewCommandNotify read FOnCommandEvent
      write SetOnCommandEvent;
    property OnViewUpdate: TNotifyEvent read FOnViewUpdate
      write SetOnViewUpdate;

    procedure test; virtual;
  end;

  TFormFactory = class(TCustomFormFactory)
  published
{$IFDEF LINUX}
{$ELSE}
    property OnClose;
{$ENDIF}
    property OnViewEvent;
    property OnViewCommand;
    property OnViewUpdate;
    property OnViewInit;
  end;

  TFormFactoryClass = class of TFormFactory;

  TFMXFormFactory = class(TCustomFormFactory)
  published
{$IFDEF LINUX}
{$ELSE}
    property OnClose;
{$ENDIF}
    property OnViewEvent;
    property OnViewCommand;
    property OnViewUpdate;
    property OnViewInit;
  end;

procedure RegisterTestCase(AClass: TComponentClass);
procedure RunTestCase();
procedure checkTest(ACond: boolean; ATexto: string; AException: boolean = false;
  AOutput: string = '');

implementation

uses MVCBr.MiddlewareFactory, MVCBr.Observable;

{ TViewFormFacotry }
procedure TCustomFormFactory.AfterConstruction;
begin
  inherited;
  FShowModal := true;
  TMVCBrMiddlewareFactory.SendBeforeEvent(middView, self);
end;

/// Set Controller to VIEW
function TCustomFormFactory.Controller(const AController: IController): IView;
begin
  result := self;
  SetController(AController);
end;

constructor TCustomFormFactory.Create;
begin
  inherited Create(nil);
end;

var
  LViewsCount: Integer = 0;
  /// counter to instance of VIEW

constructor TCustomFormFactory.Create(AOwner: TComponent);
begin
  inherited;
  FEventRef := 0;
  inc(LViewsCount);
  FID := classname + '_' + intToStr(LViewsCount);
end;

destructor TCustomFormFactory.Destroy;
begin
  TThread.NameThreadForDebugging('ViewDestroying');
  TMVCBrMiddlewareFactory.SendAfterEvent(middView, self);
  if assigned(FController) then
  begin
    FController.SetView(nil);
    FController.This.RevokeInstance(FController);
    // clear controller
    FController.Release;
    // Release;
    FController := nil;
  end;
  inherited;
end;

function TCustomFormFactory.GetController: IController;
begin
  result := FController;
end;

function TCustomFormFactory.GetGuid(AII: IInterface): TGuid;
begin
  result := TMVCBr.GetGuid(AII);
end;

function TCustomFormFactory.GetID: string;
begin
  result := FID;
end;

function TCustomFormFactory.GetModel(AII: TGuid): IModel;
begin
  TControllerAbstract(FController.This).GetModel(AII, result);
end;

function TCustomFormFactory.GetModel<TIModel>: TIModel;
begin
  if assigned(FController) then
    result := FController.This.GetModel<TIModel>;
end;

function TCustomFormFactory.GetView<TIView>: TIView;
var
  AGuid: TGuid;
  AView: IView;
begin
  AGuid := TMVCBr.GetGuid<TIView>;
  AView := FindView(AGuid);
  if assigned(AView) then
    result := TIView(AView);
end;

function TCustomFormFactory.GetPropertyValue(ANome: string): TValue;
begin
  result := TMVCBr.GetProperty(self, ANome);
end;

function TCustomFormFactory.GetShowModal: boolean;
begin
  result := FShowModal;
end;

function TCustomFormFactory.GetTitle: string;
begin
{$IFDEF LINUX}
  result := FCaption;
{$ELSE}
{$IFDEF FMX}
  result := inherited Caption;
{$ELSE}
  result := inherited Caption;
{$ENDIF}
{$ENDIF}
end;

function TCustomFormFactory.GetViewModel: IViewModel;
begin
  result := nil;
  if assigned(FController) then
    result := FController.GetModelByType(mtViewModel) as IViewModel;
end;

procedure TCustomFormFactory.Init;
begin
  FTimeInit := now;
  if assigned(FOnViewInit) then
    FOnViewInit(self);
end;

function TCustomFormFactory.InvokeMethod<T>(AMethod: string;
  const Args: TArray<TValue>): T;
begin
  result := TMVCBr.InvokeMethod<T>(self, AMethod, Args);
end;

class function TCustomFormFactory.IsClosing: boolean;
begin
  result := TApplicationController.IsClosing;
end;

function TCustomFormFactory.AttachController(AGuidController: TGuid;
  AOwnedFree: boolean = true): IController;
begin
  result := FController;
  if not assigned(FController) then
  begin
    FController := ApplicationController.AttachController(AGuidController)
      as IController;
    result := FController;
    if assigned(FController) then
    begin
      FController._AddRef;
      // workaround to keep an instance  when attached by view
      FController.This.ViewOwnedFree := AOwnedFree;
      result.View(self);
      Init;
    end;
  end;
end;

function TCustomFormFactory.AttachController<TIController>: TIController;
var
  AGuid: TGuid;
begin
  AGuid := TMVCBr.GetGuid<TIController>;
  result := AttachController(AGuid);
end;

function TCustomFormFactory.AttachModel<TIModel>(AModelClass
  : TModelFactoryAbstractClass): TIModel;
var
  o: TObject;
  AGuid: TGuid;
begin
  o := AModelClass.Create;
  AGuid := TMVCBr.GetGuid<TIModel>;
  Supports(o, AGuid, result);
  GetController.AttachModel(result);
end;

function TCustomFormFactory.RefCount: Integer;
begin
  result := _AddRef;
  _Release;
end;

procedure TCustomFormFactory.RegisterObserver(const AName: String);
begin
  TMVCBr.RegisterObserver(AName, self);
end;

procedure TCustomFormFactory.Release;
begin
  if assigned(FController) then
  begin
    FController.SetView(nil);
    FController.Release;
    FController := nil;
  end;
end;

function TCustomFormFactory.ResolveController(const IID: TGuid): IController;
begin
  result := ApplicationController.ThisAs.ResolveController(IID);
end;

function TCustomFormFactory.ResolveController<TIController>: TIController;
begin
  result := ApplicationController.ThisAs.ResolveController<TIController>();
end;

procedure TCustomFormFactory.RevokeController(TIController: IController);
var
  IID: TGuid;
begin
  IID := TMVCBr.GetGuid(TIController);
  RevokeController(IID);
end;

procedure TCustomFormFactory.RevokeController(IID: TGuid);
begin
  ApplicationController.RevokeController(IID);
end;

class procedure TCustomFormFactory.SetClosing(AValue: boolean);
begin
  TApplicationController.SetClosing(AValue);
end;

procedure TCustomFormFactory.SetController(const AController: IController);
begin
  FController := AController;
end;

procedure TCustomFormFactory.SetOnCommandEvent(const Value: TViewCommandNotify);
begin
  FOnCommandEvent := Value;
end;

procedure TCustomFormFactory.SetOnViewEvent(const Value: TViewEventJsonNotify);
begin
  FOnViewEvent := Value;
end;

procedure TCustomFormFactory.SetOnViewInit(const Value: TNotifyEvent);
begin
  FOnViewInit := Value;
end;

procedure TCustomFormFactory.SetOnViewUpdate(const Value: TNotifyEvent);
begin
  FOnViewUpdate := Value;
end;

{$IFDEF LINUX}
{$ELSE}

procedure TCustomFormFactory.SetOnClose(const Value: TCloseEvent);
begin
  FOnClose := Value;
end;

procedure TCustomFormFactory.DoCloseView(Sender: TObject;
  var ACloseAction: TCloseAction);
begin
  if assigned(FOnCloseProc) then
    FOnCloseProc(self);
  if assigned(FOnClose) then
    FOnClose(Sender, ACloseAction);
  TMVCBrMiddlewareFactory.SendAfterEvent(middView, self);
end;
{$ENDIF}

function TCustomFormFactory.ApplicationController: TApplicationController;
begin
  result := TApplicationController
    (MVCBr.ApplicationController.ApplicationController.This);
end;

function TCustomFormFactory.ApplicationControllerInternal
  : IApplicationController;
begin
  result := MVCBr.ApplicationController.ApplicationController;
end;

procedure TCustomFormFactory.DoCommand(ACommand: string;
  const AArgs: array of TValue);
begin
  if assigned(FOnCommandEvent) then
    FOnCommandEvent(ACommand, AArgs);
end;

function TCustomFormFactory.FindView(AGuid: TGuid): IView;
begin
  result := ApplicationController.FindView(AGuid);
end;

function TCustomFormFactory.ViewEvent(AMessage: TJsonValue;
  var AHandled: boolean): IView;
begin
  result := self;
  if assigned(FOnViewEvent) then
    FOnViewEvent(AMessage, AHandled);
end;

function TCustomFormFactory.ViewEventOther(AMessage: string;
  var AHandled: boolean): IView;
begin
  result := self;
  if FEventRef = 0 then
  begin
    /// check NO LOOP
    /// takecare with this lines... dont put your code in LOOP
    /// sometimes you will need some override to broken LOOPs
    /// if other view call this event, it will drop at second calls
    /// a better implementation its call ViewEvent to 1 VIEW only by her TGUID (IInterface)
    inc(FEventRef);
    try
      ApplicationController.ViewEventOther(GetController, AMessage, AHandled);
    finally
      dec(FEventRef);
    end;
  end;
end;

function TCustomFormFactory.ViewEvent(AMessage: string;
  var AHandled: boolean): IView;
var
  j: TJsonObject;
begin
  /// use inherited this method on child
  /// takecare put code here and start a loop whithout end
  result := self;
  if assigned(FOnViewEvent) then
  begin
    j := TJsonObject.Create();
    try
      j.addPair('message', AMessage);
      FOnViewEvent(j, AHandled);
    finally
      j.free;
    end;
  end;
end;

function TCustomFormFactory.MainViewEvent(AMessage: string;
  var AHandled: boolean): IView;
var
  AView: IView;
begin
  if Supports(ApplicationController.MainView, IView, AView) then
    AView.ViewEvent(AMessage, AHandled);
end;

procedure TCustomFormFactory.Notify(ACommand: string; AJson: TJsonValue);
begin
  TMVCBrObservable.Notify(ACommand, AJson);
end;

function TCustomFormFactory.Observable: IMVCBrObservable;
begin
  result := TMVCBr.Observable;
end;

procedure TCustomFormFactory.SetPropertyValue(ANome: string;
  const Value: TValue);
begin
  TMVCBr.SetProperty(self, ANome, Value);
end;

procedure TCustomFormFactory.SetShowModal(const AShowModal: boolean);
begin
  FShowModal := AShowModal;
end;

procedure TCustomFormFactory.SetTitle(const Value: string);
begin
{$IFDEF LINUX}
  FCaption := Value;
{$ELSE}
{$IFDEF FMX}
  Inherited Caption := Value;
{$ELSE}
  Inherited Caption := Value;
{$ENDIF}
{$ENDIF}
end;

procedure TCustomFormFactory.SetViewModel(const AViewModel: IViewModel);
begin
  // fazer heran�a
  if assigned(AViewModel) then
    AViewModel.View(self);

end;

function TCustomFormFactory.ShowView(const AProcBeforeShow,
  AProcONClose: TProc<IView>): IView;
begin
  FOnCloseProc := AProcONClose;
{$IFDEF LINUX}
{$ELSE}
  inherited OnClose := DoCloseView;
{$ENDIF}
  result := self;
  ShowView(AProcBeforeShow);
end;

function TCustomFormFactory.ShowView(const IIDController: TGuid): IView;
begin
  result := ShowView(IIDController,
    procedure(Sender: IView)
    begin
      // stub to nothing..
    end);
end;

function TCustomFormFactory.ShowView(const IIDController: TGuid;
const AProcBeforeShow: TProc<IView>): IView;
var
  LController: IController;
begin
  result := nil;
  LController := ResolveController(IIDController);
  if assigned(LController) then
  begin
    result := LController.GetView;
    result.ShowView(AProcBeforeShow);
  end;
end;

function TCustomFormFactory.ShowView(const AProcBeforeShow
  : TProc<IView>): Integer;
begin
  result := 0;
  if assigned(AProcBeforeShow) then
    AProcBeforeShow(self);
{$IFDEF LINUX}
{$ELSE}
{$IFDEF MSWINDOWS}
{$IFDEF FMX}
  Show;
  result := 0;
{$ELSE}
  if FShowModal then
    result := ord(ShowModal)
  else
    Show;
{$ENDIF}
{$ELSE}
  Show;
{$ENDIF}
{$ENDIF}
end;

function TCustomFormFactory.ShowView(const IIDController: TGuid;
const AProcBeforeShow: TProc<IView>; const AProcONClose: TProc<IView>): IView;
var
  ctrl: IController;
begin
  result := nil;
  ctrl := ResolveController(IIDController);
  if assigned(ctrl) then
  begin
    result := ctrl.GetView;
    if assigned(result) then
      result.ShowView(AProcBeforeShow, AProcONClose);
  end;
end;

function TCustomFormFactory.This: TObject;
begin
  result := self;
end;

procedure TCustomFormFactory.UnRegisterObserver(const AName: String);
begin
  TMVCBr.UnRegisterObserver(AName, self);
end;

function TCustomFormFactory.FindControl<T>(AControl: TBaseControl;
AName: String): T;
var
  i: Integer;
  X: TObject;
begin
  result := nil;
{$IFDEF FMX}
  { TODO }
{$ELSE}
{$IFDEF LINUX}
  for i := 0 to AControl.ComponentCount - 1 do
  begin
    if not AControl.Components[i].InheritsFrom(TBaseControl) then
      continue;
    X := AControl.Components[i];
    if X.InheritsFrom(T) then
      if sameText(TBaseControl(X).Name, AName) then
      begin
        result := T(X);
        exit;
      end;
  end;
{$ELSE}
  for i := 0 to AControl.ControlCount - 1 do
  begin
    if not AControl.Controls[i].InheritsFrom(TBaseControl) then
      continue;
    X := AControl.Controls[i];
    if X.InheritsFrom(T) then
      if sameText(TBaseControl(X).Name, AName) then
      begin
        result := T(X);
        exit;
      end;
  end;
{$ENDIF}
{$ENDIF}
end;

procedure TCustomFormFactory.Update(AJsonValue: TJsonValue;
var AHandled: boolean);
begin
  ViewEvent(AJsonValue, AHandled);
end;

procedure TCustomFormFactory.Update;
begin
end;

procedure TCustomFormFactory.UpdateObserver(AName, AMensagem: String);
var
  j: TJsonObject;
begin
  j := TJsonObject.Create;
  try
    j.addPair('message', AMensagem);
    UpdateObserver(AName, j);
  finally
    j.free;
  end;
end;

procedure TCustomFormFactory.UpdateObserver(AName: string; AJson: TJsonValue);
begin
  TMVCBr.UpdateObserver(AName, AJson);
end;

procedure TCustomFormFactory.UpdateObserver(AJson: TJsonValue);
begin
  TMVCBr.UpdateObserver(AJson);
end;

function TCustomFormFactory.UpdateView: IView;
begin
  result := self;
  if assigned(FOnViewUpdate) then
    FOnViewUpdate(self);

end;

{ TViewFactoryAdapter }
{$IFDEF LINUX}
{$ELSE}

procedure TViewFactoryAdapter.DoClose(Sender: TObject;
var Action: TCloseAction);
begin
  if assigned(FOnProc) then
    FOnProc(self);
  if assigned(FForm) and assigned(FForm.OnClose) then
    FForm.OnClose(Sender, Action);
end;
{$ENDIF}

function TViewFactoryAdapter.Form:
{$IFDEF LINUX} TComponent{$ELSE} TForm{$ENDIF};
begin
  result := FForm;
end;

class function TViewFactoryAdapter.New(AForm:
{$IFDEF LINUX} TComponent{$ELSE} TForm{$ENDIF};
const AShowModal: boolean): IView;
var
  obj: TViewFactoryAdapter;
begin
  obj := TViewFactoryAdapter.Create;
  obj.FForm := AForm;
  obj.isShowModal := AShowModal;
  result := obj;
end;

class function TViewFactoryAdapter.New(AClass:
{$IFDEF LINUX} TComponentClass{$ELSE} TFormClass{$ENDIF};
const AShowModal: boolean): IView;
var
  obj: TViewFactoryAdapter;
begin
  obj := TViewFactoryAdapter.Create;
  obj.FForm := AClass.Create(nil);
  obj.isShowModal := AShowModal;
  result := obj;
end;

procedure TViewFactoryAdapter.SetisShowModal(const Value: boolean);
begin
  FisShowModal := Value;
end;

function TViewFactoryAdapter.ShowView(const AProc: TProc<IView>): Integer;
begin
  result := 0;
  FOnProc := AProc;
{$IFDEF LINUX}
{$ELSE}
  if isShowModal then
  begin
    result := ord(FForm.ShowModal);
    if assigned(AProc) then
      AProc(self);
  end
  else
  begin
    FForm.OnClose := DoClose;
    FForm.Show;
  end;
{$ENDIF}
end;

function TViewFactoryAdapter.This: TObject;
begin
  result := self; // nao alterar... � esperado retornuar um view como retorno
end;

function TViewFactoryAdapter.ThisAs: TViewFactoryAdapter;
begin
  result := self;
end;

function TCustomFormFactory.ShowView: IView;
begin
  result := self;
  ShowView(nil);
end;

procedure TCustomFormFactory.test;
begin
  // fazer override no formulario para carregar test locais;
end;

function TCustomFormFactory.ShowView(const AProcBeforeShow: TProc<IView>;
AShowModal: boolean): IView;
begin
  FShowModal := AShowModal;
  result := self;
  ShowView(AProcBeforeShow);
end;

procedure RegisterTestCase(AClass: TComponentClass);
begin
  MVCBr.Interf.RegisterTestCase(AClass);
end;

procedure RunTestCase();
begin
  MVCBr.Interf.RunTestCase();
end;

procedure checkTest(ACond: boolean; ATexto: string; AException: boolean = false;
AOutput: string = '');
begin
  MVCBr.Interf.checkTest(ACond, ATexto, AException, AOutput);
end;

end.
