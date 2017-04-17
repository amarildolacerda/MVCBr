FormViewCreate = 'Application.CreateForm(T%FormIdentView, view)';
NormalViewCreate = 'view := T%FormIdentView.create(nil)';
NormalViewDestory = 'freeAndNil(view)';

ControllerCodeInterf =
  'unit %UnitIdent;                                                ' + #13#10 +
  ' ///                                                          ' + #13#10 +
  ' /// <summary>                                                ' + #13#10 +
  ' ///  I%FormIdentController                                   ' + #13#10 +
  ' ///     Interaface de acesso ao object factory do controller ' + #13#10 +
  ' /// </summary>                                               ' + #13#10 +
  ' ///                                                          ' + #13#10 +
  'interface                                                        ' + #13#10 +
  'uses                                                             ' + #13#10 +
  'System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}VCL.Forms,{$endif} {$endif}' + #13#10 +
  'System.Classes, MVCBr.Interf;                                   ' + #13#10 +
  'type                                                             ' + #13#10 +
  '  I%FormIdentController = interface(IController)' + #13#10 +
  '         [''%guid'']                                             ' + #13#10 +
  '         // incluir especializações aqui                         ' + #13#10 +
  '  end;                                                           ' + #13#10 +
  'Implementation                                                   ' + #13#10 +
  'end.                                                          ' + #13#10;

ControllerCode =
  ' /// <summary>                                                ' + #13#10 +
  ' /// O controller possui as seguintes características:        ' + #13#10 +
  ' ///   - pode possuir 1 view associado  (GetView)             ' + #13#10 +
  ' ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)      ' + #13#10 +
  ' ///   - se auto registra no application controller           ' + #13#10 +
  ' ///   - pode localizar controller externos e instanciá-los   ' + #13#10 +
  ' ///     (resolveController<I..>)                             ' + #13#10 +
  ' /// </summary>                                               ' + #13#10 +
  'unit %ModelIdent;                                                ' + #13#10 +
  ' /// <summary>                                                ' + #13#10 +
  ' ///    Object Factory para implementar o Controller          ' + #13#10 +
  ' /// </summary>                                               ' + #13#10 +
  'interface                                                        ' + #13#10 +
  '//%include                                                       ' + #13#10 +
  'uses                                                             ' + #13#10 +
  '                                                                 ' + #13#10 +
  'System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}{$endif}' + #13#10
  + 'System.Classes, MVCBr.Interf,                                      ' +
  #13#10 + 'MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,      ' +
  #13#10 + 'System.RTTI, %UnitIdent.interf, %FormIdent.ViewModel, %FormIdent.ViewModel.Interf,'
  + #13#10 + '%FormIdentView;' + #13#10 +
  '                                                                 ' + #13#10 +
  'type                                                             ' + #13#10 +
  '                                                                 ' + #13#10 +
  '  T%FormIdentController = class(TControllerFactory,              ' + #13#10 +
  '    I%FormIdentController,                                       ' + #13#10 +
  '    IThisAs<T%FormIdentController>, IModelAs<I%FormIdentViewModel>)  ' +
  #13#10 + '  protected                                            ' + #13#10 +
  '    Procedure DoCommand(ACommand: string;                      ' + #13#10 +
  '        const AArgs: array of TValue); override;                 ' + #13#10 +
  '  public                                                         ' + #13#10 +
  '    // inicializar os módulos personalizados em CreateModules    ' + #13#10 +
  '    Procedure CreateModules;virtual;                             ' + #13#10 +
  '    Constructor Create;override;                                 ' + #13#10 +
  '    Destructor Destroy; override;                                ' + #13#10 +
  ' /// New Cria nova instância para o Controller                   ' + #13#10 +
  '    class function New(): IController; overload;                 ' + #13#10 +
  '    class function New(const AView: IView; const AModel: IModel) ' + #13#10 +
  '      : IController; overload;                                   ' + #13#10 +
  '    class function New(const AModel: IModel): IController; overload;' +
  #13#10 + '    function ThisAs: T%FormIdentController;             ' + #13#10 +
  ' /// Init após criado a instância é chamado para concluir init    ' + #13#10
  + '    procedure init;override;                                     ' + #13#10
  + ' /// ModeAs retornar a própria interface do controller        ' + #13#10 +
  '    function ModelAs: I%FormIdentViewModel;                          ' +
  #13#10 + '  end;                                                  ' + #13#10 +
  '                                                                 ' + #13#10 +
  'implementation                                                   ' + #13#10 +
  '///  Creator para a classe Controller                           ' + #13#10 +
  'Constructor T%FormIdentController.Create;                        ' + #13#10 +
  'begin                                                            ' + #13#10 +
  ' inherited;                                                     ' + #13#10 +
  '  ///  Inicializar as Views...                                   ' + #13#10 +
  '  //%view View(T%FormIdentView.New(self));' + #13#10 +
  '  add(T%FormIdentViewModel.New(self).ID(''{%FormIdent.ViewModel}''));' +
  '  ///  Inicializar os modulos                                  ' + #13#10 +
  ' CreateModules; //< criar os modulos persolnizados      ' + #13#10 + #13#10 +
  'end;                                                ' + #13#10 +
  '///  Finaliza o controller                                       ' + #13#10 +
  'Destructor T%FormIdentController.destroy;                        ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '  inherited;                                                     ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '///  Classe Function basica para criar o controller              ' + #13#10 +
  'class function T%FormIdentController.New(): IController;         ' + #13#10 +
  'begin                                                            ' + #13#10 +
  ' result := new(nil,nil);                                         ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '///  Classe para criar o controller com View e Model criado      ' + #13#10 +
  'class function T%FormIdentController.New(const AView: IView; ' + #13#10 +
  '   const AModel: IModel) : IController;                          ' + #13#10 +
  'var                                                              ' + #13#10 +
  '  vm: IViewModel;                                                ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '  result := T%FormIdentController.create as IController;         ' + #13#10 +
  '  result.View(AView).Add(AModel);                                ' + #13#10 +
  '  if assigned(AModel) then                                       ' + #13#10 +
  '    if supports(AModel.This, IViewModel, vm) then                ' + #13#10 +
  '      begin                                                      ' + #13#10 +
  '        vm.View(AView).Controller( result );                     ' + #13#10 +
  '      end;                                                       ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '///  Classe para inicializar o Controller com um Modulo inicialz.' + #13#10 +
  'class function T%FormIdentController.New(                        ' + #13#10 +
  '   const AModel: IModel): IController;                           ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '  result := new(nil,AModel);                                     ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '///  Cast para a interface local do controller                   ' + #13#10 +
  'function T%FormIdentController.ThisAs: T%FormIdentController;    ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '   result := self;                                               ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '///  Cast para o ViewModel local do controller                   ' + #13#10 +
  'function T%FormIdentController.ModelAs: I%FormIdentViewModel;' + #13#10 +
  'begin                                                            ' + #13#10 +
  ' if count>=0 then                                                ' + #13#10 +
  '  supports(GetModelByType(mtViewModel), I%FormIdentViewModel, result);' +
  #13#10 + 'end;                                           ' + #13#10 +
  '///  Executar algum comando customizavel                        ' + #13#10 +
  'Procedure T%FormIdentController.DoCommand(ACommand: string;      ' + #13#10 +
  '   const AArgs:Array of TValue);                                 ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '    inherited;                                                   ' + #13#10 +
  'end;                                                      ' + #13#10 +
  '///  Evento INIT chamado apos a inicializacao do controller     ' + #13#10 +
  'procedure T%FormIdentController.init;                            ' + #13#10 +
  'var ref:T%FormIdentView;                                               ' +
  #13#10 + 'begin                                                            ' +
  #13#10 + '  inherited;                                                     ' +
  #13#10 + ' if not assigned(FView) then                            ' + #13#10 +
  ' begin                                                           ' + #13#10 +
  '   Application.CreateForm( T%FormIdentView, ref );               ' + #13#10 +
  '   supports(ref,IView,FView);                            ' + #13#10 +
  '  {$ifdef FMX}                                                   ' + #13#10 +
  '    if Application.MainForm=nil then                             ' + #13#10 +
  '      Application.RealCreateForms;                               ' + #13#10 +
  '  {$endif}                                                       ' + #13#10 +
  ' end;                                                            ' + #13#10 +
  ' CreateModules;                                                  ' + #13#10 +
  ' AfterInit;                                                      ' + #13#10 +
  'end;                                                             ' + #13#10 +

  '/// Adicionar os modulos e MODELs personalizados              ' + #13#10 +
  'Procedure T%FormIdentController.CreateModules;                   ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '   // adicionar os seus MODELs aqui                              ' + #13#10 +
  '   // exemplo: add( MeuModel.new(self) );                        ' + #13#10 +
  'end;                                                             ' + #13#10 +

  '                                                                 ' + #13#10 +
  'initialization                                                   ' + #13#10 +
  '///  Inicialização automatica do Controller ao iniciar o APP     ' + #13#10 +
  '//T%FormIdentController.New(T%FormIdentView.New,T%FormIdentViewModel.New)).init();'
  + #13#10 + '                                                     ' + #13#10 +
  '///  Registrar Interface e ClassFactory para o MVCBr            ' + #13#10 +
  '  RegisterInterfacedClass(T%FormIdentController.ClassName,I%FormIdentController,T%FormIdentController);'
  + #13#10 + '                                                     ' + #13#10 +
  'finalization                                                    ' + #13#10 +
  '///  Remover o Registro da Interface                             ' + #13#10 +
  '  unRegisterInterfacedClass(T%FormIdentController.ClassName);' + #13#10 +
  '                                                                 ' + #13#10 +
  'end.                                                          ' + #13#10;

ControllerCode2 = ControllerCode;

ControllerCodeWithoutViewModel =
  ' /// <summary>                                                ' + #13#10 +
  ' /// O controller possui as seguintes características:        ' + #13#10 +
  ' ///   - pode possuir 1 view associado  (GetView)             ' + #13#10 +
  ' ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)      ' + #13#10 +
  ' ///   - se auto registra no application controller           ' + #13#10 +
  ' ///   - pode localizar controller externos e instanciá-los   ' + #13#10 +
  ' ///     (resolveController<I..>)                             ' + #13#10 +
  ' /// </summary>                                               ' + #13#10 +
  'unit %ModelIdent;                                                ' + #13#10 +
  ' /// <summary>                                                ' + #13#10 +
  ' ///    Object Factory para implementar o Controller          ' + #13#10 +
  ' /// </summary>                                               ' + #13#10 +
  'interface                                                        ' + #13#10 +
  '//%include                                                       ' + #13#10 +
  'uses                                                             ' + #13#10 +
  '                                                                 ' + #13#10 +
  'System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}{$endif}' + #13#10
  + 'System.Classes, MVCBr.Interf,                                      ' +
  #13#10 + 'MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,      ' +
  #13#10 + 'System.RTTI, %UnitIdent.interf, ' + #13#10 + '%FormIdentView;' +
  #13#10 + '                                                         ' + #13#10
  + 'type                                                             ' + #13#10
  + '                                                                 ' + #13#10
  + '  T%FormIdentController = class(TControllerFactory,              ' + #13#10
  + '    I%FormIdentController,                                       ' + #13#10
  + '    IThisAs<T%FormIdentController>)  ' + #13#10 +
  '  protected                                            ' + #13#10 +
  '    Procedure DoCommand(ACommand: string;                      ' + #13#10 +
  '        const AArgs: array of TValue); override;                 ' + #13#10 +
  '  public                                                         ' + #13#10 +
  '    // inicializar os módulos personalizados em CreateModules    ' + #13#10 +
  '    Procedure CreateModules;virtual;                             ' + #13#10 +
  '    Constructor Create;override;                                 ' + #13#10 +
  '    Destructor Destroy; override;                                ' + #13#10 +
  ' /// New Cria nova instância para o Controller                   ' + #13#10 +
  '    class function New(): IController; overload;                 ' + #13#10 +
  '    class function New(const AView: IView; const AModel: IModel) ' + #13#10 +
  '      : IController; overload;                                   ' + #13#10 +
  '    class function New(const AModel: IModel): IController; overload;' +
  #13#10 + '    function ThisAs: T%FormIdentController;  ' + #13#10 +
  ' /// Init após criado a instância é chamado para concluir init    ' + #13#10
  + '    procedure init;override;                                     ' + #13#10
  + '  end;                                      ' + #13#10 +
  '                                                                 ' + #13#10 +
  'implementation                                                   ' + #13#10 +
  '///  Creator para a classe Controller                           ' + #13#10 +
  'Constructor T%FormIdentController.Create;                        ' + #13#10 +
  'begin                                                            ' + #13#10 +
  ' inherited;                                                     ' + #13#10 +
  '  ///  Inicializar as Views...                                   ' + #13#10 +
  '  //%view View(T%FormIdentView.New(self));' + #13#10 +
  '  ///  Inicializar os modulos                                  ' + #13#10 +
  ' CreateModules; //< criar os modulos persolnizados      ' + #13#10 + #13#10 +
  'end;                                                ' + #13#10 +
  '///  Finaliza o controller                                       ' + #13#10 +
  'Destructor T%FormIdentController.destroy;                        ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '  inherited;                                                     ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '///  Classe Function basica para criar o controller              ' + #13#10 +
  'class function T%FormIdentController.New(): IController;         ' + #13#10 +
  'begin                                                            ' + #13#10 +
  ' result := new(nil,nil);                                         ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '///  Classe para criar o controller com View e Model criado      ' + #13#10 +
  'class function T%FormIdentController.New(const AView: IView; ' + #13#10 +
  '   const AModel: IModel) : IController;                          ' + #13#10 +
  'var                                                              ' + #13#10 +
  '  vm: IViewModel;                                                ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '  result := T%FormIdentController.create as IController;         ' + #13#10 +
  '  result.View(AView).Add(AModel);                                ' + #13#10 +
  '  if assigned(AModel) then                                       ' + #13#10 +
  '    if supports(AModel.This, IViewModel, vm) then                ' + #13#10 +
  '      begin                                                      ' + #13#10 +
  '        vm.View(AView).Controller( result );                     ' + #13#10 +
  '      end;                                                       ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '///  Classe para inicializar o Controller com um Modulo inicialz.' + #13#10 +
  'class function T%FormIdentController.New(                        ' + #13#10 +
  '   const AModel: IModel): IController;                           ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '  result := new(nil,AModel);                                     ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '///  Cast para a interface local do controller                   ' + #13#10 +
  'function T%FormIdentController.ThisAs: T%FormIdentController;    ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '   result := self;                                               ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '///  Executar algum comando customizavel                        ' + #13#10 +
  'Procedure T%FormIdentController.DoCommand(ACommand: string;      ' + #13#10 +
  '   const AArgs:Array of TValue);                                 ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '    inherited;                                                   ' + #13#10 +
  'end;                                                      ' + #13#10 +
  '///  Evento INIT chamado apos a inicializacao do controller     ' + #13#10 +
  'procedure T%FormIdentController.init;                            ' + #13#10 +
  'var ref:T%FormIdentView;                                               ' +
  #13#10 + 'begin                                                            ' +
  #13#10 + '  inherited;                                                     ' +
  #13#10 + ' if not assigned(FView) then                            ' + #13#10 +
  ' begin                                                           ' + #13#10 +
  '   Application.CreateForm( T%FormIdentView, ref );               ' + #13#10 +
  '   supports(ref,IView,FView);                            ' + #13#10 +
  '  {$ifdef FMX}                                                   ' + #13#10 +
  '    if Application.MainForm=nil then                             ' + #13#10 +
  '      Application.RealCreateForms;                               ' + #13#10 +
  '  {$endif}                                                       ' + #13#10 +
  ' end;                                                            ' + #13#10 +
  ' AfterInit;                                                        ' + #13#10
  + 'end;                                                             '
  + #13#10 +

  '/// Adicionar os modulos e MODELs personalizados              ' + #13#10 +
  'Procedure T%FormIdentController.CreateModules;                   ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '   // adicionar os seus MODELs aqui                              ' + #13#10 +
  '   // exemplo: add( MeuModel.new(self) );                        ' + #13#10 +
  'end;                                                             ' + #13#10 +

  '                                                                 ' + #13#10 +
  'initialization                                                   ' + #13#10 +
  '///  Inicialização automatica do Controller ao iniciar o APP     ' + #13#10 +
  '//T%FormIdentController.New(T%FormIdentView.New,T%FormIdentViewModel.New)).init();'
  + #13#10 + '                                                     ' + #13#10 +
  '///  Registrar Interface e ClassFactory para o MVCBr            ' + #13#10 +
  '  RegisterInterfacedClass(T%FormIdentController.ClassName,I%FormIdentController,T%FormIdentController);'
  + #13#10 + '                                                     ' + #13#10 +
  'finalization                                                    ' + #13#10 +
  '///  Remover o Registro da Interface                             ' + #13#10 +
  '  unRegisterInterfacedClass(T%FormIdentController.ClassName);' + #13#10 +
  '                                                                 ' + #13#10 +
  'end.                                                          ' + #13#10;

ControllerCodeWithoutView = ControllerCode;

ControllerCodeOnly =
  'unit %UnitIdent;                                                ' + #13#10 +
  '                                                                 ' + #13#10 +
  'interface                                                        ' + #13#10 +
  '//%include                                                       ' + #13#10 +
  'uses                                                             ' + #13#10 +
  '                                                                 ' + #13#10 +
  'System.SysUtils,{$ifdef LINUX} {$else}{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif}{$endif} System.Classes,'
  + 'MVCBr.Interf,        ' + #13#10 +
  'MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,      ' + #13#10 +
  '%UnitIdent.interf,                                              ' + #13#10 +
  'System.RTTI;                                                     ' + #13#10 +
  '                                                                 ' + #13#10 +
  'type                                                             ' + #13#10 +
  '                                                                 ' + #13#10 +
  '  T%FormIdentController = class(TControllerFactory,              ' + #13#10 +
  '    I%FormIdentController,                                       ' + #13#10 +
  '    IThisAs<T%FormIdentController>{, IModelAs<I%FormIdentViewModel>})  ' +
  #13#10 + '  protected                                            ' + #13#10 +
  '    Procedure DoCommand(ACommand: string;                      ' + #13#10 +
  '        const AArgs: array of TValue); override;                 ' + #13#10 +
  '  public                                                         ' + #13#10 +
  '    // inicializar os módulos personalizados em CreateModules    ' + #13#10 +
  '    Procedure CreateModules;virtual;                             ' + #13#10 +
  '    Constructor Create;override;                                 ' + #13#10 +
  '    Destructor Destroy; override;                                ' + #13#10 +
  '    class function New(): IController; overload;                 ' + #13#10 +
  '    class function New(const AView: IView; const AModel: IModel) ' + #13#10 +
  '      : IController; overload;                                   ' + #13#10 +
  '    class function New(const AModel: IModel): IController; overload;' +
  #13#10 + '    function ThisAs: T%FormIdentController;             ' + #13#10 +
  '    procedure init;override;                                     ' + #13#10 +
  '    //function ModelAs: I%FormIdentViewModel;                          ' +
  #13#10 + '  end;                                                  ' + #13#10 +
  '                                                                 ' + #13#10 +
  'implementation                                                   ' + #13#10 +
  '                                                                 ' + #13#10 +
  'Constructor T%FormIdentController.Create;                        ' + #13#10 +
  'begin                                                            ' + #13#10 +
  ' inherited;                                                     ' + #13#10 +
  '// add(T%FormIdentViewModel.New(self).ID(''{%FormIdent.ViewModel}''));' +
  ' CreateModules; //< criar os modulos persolnizados              ' + #13#10 +
  #13#10 + 'end;                                                ' + #13#10 +
  '                                                                 ' + #13#10 +
  'Destructor T%FormIdentController.destroy;                        ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '  inherited;                                                     ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '                                                                 ' + #13#10 +
  'class function T%FormIdentController.New(): IController;         ' + #13#10 +
  'begin                                                            ' + #13#10 +
  ' result := new(nil,nil);                                         ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '                                                                 ' + #13#10 +
  'class function T%FormIdentController.New(const AView: IView; ' + #13#10 +
  '   const AModel: IModel) : IController;                          ' + #13#10 +
  'var                                                              ' + #13#10 +
  '  vm: IViewModel;                                                ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '  result := T%FormIdentController.create as IController;         ' + #13#10 +
  '  result.View(AView).Add(AModel);                                ' + #13#10 +
  '  if assigned(AModel) then                                       ' + #13#10 +
  '    if supports(AModel.This, IViewModel, vm) then                ' + #13#10 +
  '      begin                                                      ' + #13#10 +
  '        vm.View(AView).Controller( result );                     ' + #13#10 +
  '      end;                                                       ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '                                                                 ' + #13#10 +
  'class function T%FormIdentController.New(                        ' + #13#10 +
  '   const AModel: IModel): IController;                           ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '  result := new(nil,AModel);                                     ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '                                                                 ' + #13#10 +
  'function T%FormIdentController.ThisAs: T%FormIdentController;    ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '   result := self;                                               ' + #13#10 +
  'end;                                                             ' + #13#10 +
  '                                                                 ' + #13#10 +
  '{function T%FormIdentController.ModelAs: I%FormIdentViewModel;' + #13#10 +
  'begin                                                            ' + #13#10 +
  ' if count>=0 then                                                ' + #13#10 +
  '  supports(GetModelByType(mtViewModel), I%FormIdentViewModel, result);' +
  #13#10 + 'end;}                                           ' + #13#10 +
  '                                                                 ' + #13#10 +
  'Procedure T%FormIdentController.DoCommand(ACommand: string;      ' + #13#10 +
  '   const AArgs:Array of TValue);                                 ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '    inherited;                                                   ' + #13#10 +
  'end;                                                      ' + #13#10 +
  '                                                                 ' + #13#10 +
  'procedure T%FormIdentController.init;                            ' + #13#10 +
  '//var ref:T%FormIdentView;                                               ' +
  #13#10 + 'begin                                                            ' +
  #13#10 + '  inherited;                                                     ' +
  #13#10 + '{ if not assigned(FView) then                            ' + #13#10
  + ' begin                                                           ' + #13#10
  + '   Application.CreateForm( T%FormIdentView, ref );                 ' +
  #13#10 + '   supports(ref,IView,FView);                            ' + #13#10
  + ' end;}                                                            ' +
  #13#10 + ' AfterInit;                                                        '
  + #13#10 + 'end;                                                             '
  + #13#10 +

  ' // Adicionar os modulos e MODELs personalizados              ' + #13#10 +
  'Procedure T%FormIdentController.CreateModules;                   ' + #13#10 +
  'begin                                                            ' + #13#10 +
  '   // adicionar os mudulos aqui                                  ' + #13#10 +
  '   // exemplo: add( MeuModel.new(self) );                        ' + #13#10 +
  'end;                                                             ' + #13#10 +

  '                                                                 ' + #13#10 +
  'initialization                                                   ' + #13#10 +
  '//T%FormIdentController.New(T%FormIdentView.New,T%FormIdentViewModel.New)).init();'
  + #13#10 + '                                                     ' + #13#10 +
  '  RegisterInterfacedClass(T%FormIdentController.ClassName,I%FormIdentController,T%FormIdentController);'
  + #13#10 + '                                                     ' + #13#10 +
  'finalization                                                    ' + #13#10 +
  '                                                                 ' + #13#10 +
  '  unRegisterInterfacedClass(T%FormIdentController.ClassName);' + #13#10 +
  '                                                                 ' + #13#10 +
  'end.                                                          ' + #13#10;
