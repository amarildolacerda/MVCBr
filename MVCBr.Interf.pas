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

uses System.Classes, System.SysUtils, System.RTTI;

type

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
  TModelType = (mtNone, mtViewModel, mtValidate, mtPersistent);
  TModelTypes = set of TModelType;

  IModel = interface;

  IModelBase = interface
    ['{E1622D13-701C-4AD8-8AD4-A1B64B8D251F}']
    function This: TObject;
    function GetID: string;
    function ID(const AID: String): IModel;
    function Update: IModel;
  end;

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
    function Add(AController: IController): Integer;
    procedure Delete(const idx: Integer);
  end;

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
    function This: TObject;
  end;

  IController = interface(IControllerBase)
    ['{A7758E82-3AA1-44CA-8160-2DF77EC8D203}']
    function GetView: IView; overload;
    function View(const AView: IView): IController; overload;
    function UpdateByView(AView: IView): IController;
  end;

  IControllerAs<T> = interface
    ['{F190C15D-91EA-4CD4-AA5D-59ADB6D5AECB}']
    function ControllerAs: T;
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

  IViewModel = interface(IViewModelBase)
    ['{9F943F5D-4367-4537-857F-1399DBF7133F}']
    function Controller(const AController: IController): IViewModel;
  end;

implementation

end.
