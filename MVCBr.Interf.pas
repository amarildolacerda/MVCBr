unit MVCBr.Interf;

{
  Como organizar:
  - Um aplicativo só pode ter um ApplicationController
  - Um Controler pode estar ligando a 0 ou 1 view... e pode conter uma lista de Models;
  - Todo Controller deverá se auto registrar no ApplicationController
  - Cada Controller é um Observable
  - Cada Model é um Observer
  - O controller pode enviar Update para os Models e para o View
  - O View pode receber Update do Controller e Enviar UpdateByView para o Controller
  - O Model pode receber Update do Controller e Enviar UpdateByModel para o Controller
  - Toda View conhece seu Controller
  - Todo Model conhece seu Controller
  - Um view pode ter somente um controller

  Agenda:
  - One Aplicattion have only one ApplicationController
  - One Controller contains View and Models (Zero or 1 View)  ( Zero or more Models  )
  - every Controller need self register on ApplicationControler

  - With Controller is an Observable - may dispach events for  any  Models
  - with Model is an Observer - may receive events from Controller (Observable)
  - with Model Know what is his controller (perhaps only one)
  - with Model can send event update for his controller that can send update for controller's view
  - with view have only one controller and can send update for his controller

  - ApplicationController have a list of controllers
}

interface

uses System.Classes, System.SysUtils, System.Generics.Collections,
  System.TypInfo, System.RTTI;

type

  // MVCBr Utils
  TMVCBr = record
    class function InvokeCreate<T: class>(const Args: TArray<TValue>)
      : T; static;
    class function InvokeMethod<T>(AInstance: TObject; AMethod: string;
      const Args: TArray<TValue>): T; static;
    class procedure SetProperty(AInstance: TObject; APropertyNome: string;
      AValue: TValue); static;
    class function GetProperty(AInstance: TObject; APropertyNome: string):TValue; static;
  end;

  IMVCBase = interface
    ['{6027634D-6A9E-4FC2-A1CE-71B2194ACCDF}']
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
    property PropertyValue[ ANome:string]:TValue  read GetPropertyValue write SetPropertyValue;
  end;

  TMVCFactoryAbstract = class(TInterfacedObject, IMVCBase)
  private
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
  public
    function InvokeMethod<T>(AMethod: string; const Args: TArray<TValue>): T;
    property PropertyValue[ ANome:string]:TValue  read GetPropertyValue write SetPropertyValue;
  end;

  // InterfacedList que sera herdado na classes base com controle Threadsafe
  TMVCInterfacedList<T> = class(TInterfaceList)
  public
  end;

  IController = interface;

  // uses IThis in base Classes
  IThis<T> = interface
    ['{D6AB571A-3644-43CF-809A-34E1CFD96A78}']
    function This: T;
  end;

  // uses IThisAs in higher Classes
  IThisAs<T> = interface
    ['{F4D37AD4-3F22-464B-B407-7958F425AD1C}']
    function ThisAs: T;
  end;

  // uses IModel to implement Bussines rules
  TModelType = (mtCommon, mtViewModel, mtValidate, mtPersistent, mtNavigator);
  TModelTypes = set of TModelType;

  // IModel Interfaces
  IModel = interface;

  // Base para implementar IModel
  IModelBase = interface
    ['{E1622D13-701C-4AD8-8AD4-A1B64B8D251F}']
    function This: TInterfacedObject;
    function GetID: string;
    function ID(const AID: String): IModel;
    function Update: IModel;
  end;

  // IModel representa a interface onde implementa as regras de negócio
  IModel = interface(IModelBase)
    ['{FC5669F0-546C-4F0D-B33F-5FB2BA125DBC}']
    function Controller(const AController: IController): IModel;
    function GetModelTypes: TModelTypes;
    procedure SetModelTypes(const AModelType: TModelTypes);
    property ModelTypes: TModelTypes read GetModelTypes write SetModelTypes;
  end;

  IModelAs<T> = interface
    ['{2272BBD1-26B9-4F75-A820-E66AB4A16E86}']
    function ModelAs: T;
  end;

  // IView will be implements in TForm...
  IView = interface;

  IViewBase = interface
    ['{B3302253-353A-4890-B7B1-B45FC41247F6}']
    function This: TObject;
    function ShowView(const AProc: TProc<IView>): Integer;
    function Update: IView;
  end;

  // IView é uma representação para FORM
  IView = interface(IViewBase)
    ['{A1E53BAC-BFCE-4D90-A54F-F8463D597E43}']
    function Controller(const AController: IController): IView;
  end;

  IViewAs<T> = interface
    ['{F6831540-5311-4910-B25C-70AB21F3EF29}']
    function ViewAs: T;
  end;

  // Main Controller for all Application  - Have a list os Controllers
  IApplicationController = interface
    ['{207C0D66-6586-4123-8817-F84AC0AF29F3}']
    procedure Run(AClass: TComponentClass; AController: IController;
      AModel: IModel; AFunc: TFunc < boolean >= nil);
    function Count: Integer;
    function Add(const AController: IController): Integer;
    procedure Delete(const idx: Integer);
    procedure Remove(const AController: IController);
  end;

  TControllerAbstract = class;

  // Controller for an Unit
  IControllerBase = interface
    ['{5891921D-93C8-4B0A-8465-F7F0156AC228}']
    function IndexOfModelType(const AModelType: TModelType): Integer;
    function GetModelByType(const AModelType: TModelType): IModel;
    function UpdateByModel(AModel: IModel): IController;
    function UpdateAll: IController;
    function Add(const AModel: IModel): Integer;
    function IndexOf(const AModel: IModel): Integer;
    procedure Delete(const Index: Integer);
    function Count: Integer;
    function GetModel(const idx: Integer): IModel;
    Procedure DoCommand(ACommand: string; const AArgs: array of TValue);
    function This: TControllerAbstract;
  end;

  IControllerAs<T> = interface
    ['{F190C15D-91EA-4CD4-AA5D-59ADB6D5AECB}']
    function ControllerAs: T;
  end;

  TControllerAbstract = class(TMVCFactoryAbstract)
  protected
    FModels: TMVCInterfacedList<IModel>;
  public
    function GetModel(const IID: TGUID; out intf): IModel; overload; virtual;
    function GetModel<T>(): T; overload;
  end;

  // IController manter associação entre o IView e IModel
  IController = interface(IControllerBase)
    ['{A7758E82-3AA1-44CA-8160-2DF77EC8D203}']
    function GetView: IView; overload;
    function View(const AView: IView): IController; overload;
    function UpdateByView(AView: IView): IController;
  end;

  IViewModelAs<T> = interface
    ['{79D16DA9-EB18-4F17-A748-6A7E29A59992}']
    function ViewModelAs: T;
  end;

  IViewModel = interface;

  IViewModelBase = interface(IModel)
    ['{EB040A36-70EE-4DFB-9750-A0227D45D113}']
    function This: TObject;
    function View(const AView: IView = nil): IViewModel;
    function Model(const AModel: IModel = nil): IViewModel;
    function Update(const AView: IView): IViewModel; overload;
    function Update(const AModel: IModel): IViewModel; overload;
  end;

  // IViewModel associa o FORM com o o seu MODEL
  IViewModel = interface(IViewModelBase)
    ['{9F943F5D-4367-4537-857F-1399DBF7133F}']
    function Controller(const AController: IController): IViewModel;
  end;

  IPersistentModel = interface;

  IPersistentModelBase = interface(IModel)
    ['{0E0C626B-AE54-4050-9EA0-C8079FCA75BC}']
  end;

  IPersistentModel = interface(IPersistentModelBase)
    ['{BF5767E0-FF6E-4A60-9409-9163AE4EDA4D}']
    function Controller(const AController: IController): IPersistentModel;
  end;

  INavigatorModel = interface;

  INavigatorModelBase = interface(IModel)
    ['{0E0C626B-AE54-4050-9EA0-C8079FCA75BC}']
  end;

  INavigatorModel = interface(INavigatorModelBase)
    ['{BF5767E0-FF6E-4A60-9409-9163AE4EDA4D}']
    function Controller(const AController: IController): INavigatorModel;
  end;

  IValidateModel = interface(IModel)
    ['{01A80AFD-8674-4E05-BCC4-00514DE84D88}']
  end;

implementation

{ TControllerAbstract }

function TControllerAbstract.GetModel(const IID: TGUID; out intf): IModel;
var
  I: Integer;
begin
  for I := 0 to FModels.Count - 1 do
    if supports((FModels.Items[I] as IModel).This, IID, intf) then
    begin
      result := FModels.Items[I] as IModel;
      supports(result.This, IID, intf);
      exit;
    end;
end;

function TControllerAbstract.GetModel<T>(): T;
var
  I: Integer;
  pInfo: PTypeInfo;
  IID: TGUID;
begin
  pInfo := TypeInfo(T);
  IID := GetTypeData(pInfo).Guid;
  for I := 0 to FModels.Count - 1 do
    if supports((FModels.Items[I] as IModel).This, IID, result) then
    begin
      exit;
    end;
end;

{ TMVCBr }

class function TMVCBr.GetProperty(AInstance: TObject;
  APropertyNome: string): TValue;
var
  ctx: TRttiContext;
  prp: TRttiProperty;
begin
  ctx := TRttiContext.Create;
  try
    prp := ctx.GetType(AInstance.ClassType).GetProperty(APropertyNome);
    if Assigned(prp) then
      result := prp.GetValue(AInstance);
  finally
    ctx.Free();
  end;
end;

class function TMVCBr.InvokeCreate<T>(const Args: TArray<TValue>): T;
var
  ctx: TRttiContext;
begin
  ctx := TRttiContext.Create;
  try
    result := ctx.GetType(TClass(T)).GetMethod('create').Invoke(TClass(T), Args)
      .AsType<T>;
  finally
    ctx.Free();
  end;
end;

class function TMVCBr.InvokeMethod<T>(AInstance: TObject; AMethod: string;
  const Args: TArray<TValue>): T;
var
  ctx: TRttiContext;
begin
  ctx := TRttiContext.Create;
  try
    result := ctx.GetType(AInstance.ClassInfo).GetMethod(AMethod)
      .Invoke(AInstance, Args).AsType<T>;
  finally
    ctx.Free();
  end;
end;

class procedure TMVCBr.SetProperty(AInstance: TObject; APropertyNome: string;
  AValue: TValue);
var
  ctx: TRttiContext;
  prp: TRttiProperty;
begin
  ctx := TRttiContext.Create;
  try
    prp := ctx.GetType(AInstance.ClassType).GetProperty(APropertyNome);
    if Assigned(prp) then
      prp.SetValue(AInstance, AValue);
  finally
    ctx.Free();
  end;
end;

{ TMVCFactoryAbstract }

function TMVCFactoryAbstract.GetPropertyValue(ANome: string): TValue;
begin

end;

function TMVCFactoryAbstract.InvokeMethod<T>(AMethod: string;
  const Args: TArray<TValue>): T;
begin
  result := TMVCBr.InvokeMethod<T>(Self, AMethod, Args);
end;

procedure TMVCFactoryAbstract.SetPropertyValue(ANome: string;
  const Value: TValue);
begin

end;

end.
