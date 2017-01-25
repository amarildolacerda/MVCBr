FormViewCreate = 'Application.CreateForm(T%FormIdentView, view)';
NormalViewCreate = 'view := T%FormIdentView.create(nil)';
NormalViewDestory = 'freeAndNil(view)';

ControllerCode =
  'unit %ModelIdent;                                                ' + #10#13 +
  '                                                                 ' + #10#13 +
  'interface                                                        ' + #10#13 +
  '                                                                 ' + #10#13 +
  'uses                                                             ' + #10#13 +
  '                                                                 ' + #10#13 +
  'SysUtils, forms, buttons, classes, controls,MVCBr.Interf,        ' + #10#13 +
  'MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,      ' + #10#13 +
  'System.RTTI,                                                     ' + #10#13 +
  '%FormIdent.Model,%FormIdentView;                                 ' + #10#13 +
  '                                                                 ' + #10#13 +
  'type                                                             ' + #10#13 +
  '                                                                 ' + #10#13 +
  '  I%FormIdentController = interface(IController)' + #10#13 +
  '         [''%guid'']                                             ' + #10#13 +
  '         // incluir especializações aqui                         ' + #10#13 +
  '  end;                                                           ' + #10#13 +
  '                                                                 ' + #10#13 +
  '  T%FormIdentController = class(TControllerFactory,              ' + #10#13 +
  '    I%FormIdentController,                                       ' + #10#13 +
  '    IThisAs<T%FormIdentController>, IModelAs<I%FormIdentModel>)  ' + #10#13 +
  '  protected                                                      ' + #10#13 +
  '    Procedure DoCommand(ACommand: string;                      ' + #10#13 +
  '        const AArgs: array of TValue); override;                 ' + #10#13 +
  '  public                                                         ' + #10#13 +
  '    Constructor Create;override;                                 ' + #10#13 +
  '    Destructor Destroy; override;                                ' + #10#13 +
  '    class function New(): IController; overload;                 ' + #10#13 +
  '    class function New(const AView: IView; const AModel: IModel) ' + #10#13 +
  '      : IController; overload;                                   ' + #10#13 +
  '    class function New(const AModel: IModel): IController; overload;' +
  #10#13 + '    function ThisAs: T%FormIdentController;             ' + #10#13 +
  '    function ModelAs: I%FormIdentModel;                          ' + #10#13 +
  '  end;                                                           ' + #10#13 +
  '                                                                 ' + #10#13 +
  'implementation                                                   ' + #10#13 +
  '                                                                 ' + #10#13 +
  'Constructor T%FormIdentController.Create;                        ' + #10#13 +
  'begin                                                            ' + #10#13 +
  ' inherited;                                                     ' + #10#13 +
  ' add(T%FormIdentModel.New(self).ID(''{Controller.%FormIdent}''));' + #10#13 +
  'end;                                                             ' + #10#13 +
  '                                                                 ' + #10#13 +
  'Destructor T%FormIdentController.destroy;                        ' + #10#13 +
  'begin                                                            ' + #10#13 +
  '  inherited;                                                     ' + #10#13 +
  'end;                                                             ' + #10#13 +
  '                                                                 ' + #10#13 +
  'class function T%FormIdentController.New(): IController;         ' + #10#13 +
  'begin                                                            ' + #10#13 +
  ' result := new(nil,nil);                                         ' + #10#13 +
  'end;                                                             ' + #10#13 +
  '                                                                 ' + #10#13 +
  'class function T%FormIdentController.New(const AView: IView; ' + #10#13 +
  '   const AModel: IModel) : IController;                          ' + #10#13 +
  'begin                                                            ' + #10#13 +
  ' result := T%FormIdentController.create as IController;          ' + #10#13 +
  ' result.View(AView).Add(AModel);                                 ' + #10#13 +
  'end;                                                             ' + #10#13 +
  '                                                                 ' + #10#13 +
  'class function T%FormIdentController.New(                        ' + #10#13 +
  '   const AModel: IModel): IController;                           ' + #10#13 +
  'begin                                                            ' + #10#13 +
  '  result := new(nil,AModel);                                     ' + #10#13 +
  'end;                                                             ' + #10#13 +
  '                                                                 ' + #10#13 +
  'function T%FormIdentController.ThisAs: T%FormIdentController;    ' + #10#13 +
  'begin                                                            ' + #10#13 +
  '   result := self;                                               ' + #10#13 +
  'end;                                                             ' + #10#13 +
  '                                                                 ' + #10#13 +
  'function T%FormIdentController.ModelAs: I%FormIdentModel;        ' + #10#13 +
  'begin                                                            ' + #10#13 +
  ' if count>=0 then                                                ' + #10#13 +
  '  supports(GetModel(0), I%FormIdentModel, result);               ' + #10#13 +
  'end;                                                             ' + #10#13 +
  '                                                                 ' + #10#13 +
  'Procedure T%FormIdentController.DoCommand(ACommand: string;      ' + #10#13 +
  '   const AArgs:Array of TValue);                                 ' + #10#13 +
  'begin                                                            ' + #10#13 +
  '    inherited;                                                   ' + #10#13 +
  'end;                                                             ' + #10#13 +
  '                                                                 ' + #10#13 +
  'initialization                                                   ' + #10#13 +
  '//T%FormIdentController.New(T%FormIdentView.New,T%FormIdentModel.New));' +
  #10#13 + '                                                                 ' +
  #10#13 + 'end.                                                             ' +
  #10#13;

ControllerCode2 = ControllerCode;

ControllerCodeWithoutModel = ControllerCode;

ControllerCodeWithoutView = ControllerCode;

ControllerCodeOnly = ControllerCode;
