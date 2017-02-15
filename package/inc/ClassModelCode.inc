// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassModelInterf = 'Unit %ModelIdent;              ' + #10#13 +
  ' ///                                                ' + #10#13 +
  ' /// <summary>                                      ' + #10#13 +
  ' ///     Interface de acesso ao Model               ' + #10#13 +
  ' ///     O uso de interface permite diminuir o      ' + #10#13 +
  ' ///     acoplamento entre UNITs                    ' + #10#13 +
  ' /// </summary>                                     ' + #10#13 +
  ' ///                                                ' + #10#13 +
  '                                                              ' + #10#13 +
  'interface                                                     ' + #10#13 +
  '                                                              ' + #10#13 +
  '                                                              ' + #10#13 +
  'Uses MVCBr.Interf,MVCBr.Model;                               ' + #10#13 +
  '                                                              ' + #10#13 +
  'Type                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  ' ///                                                          ' + #10#13 +
  ' /// Interface para o Model                                   ' + #10#13 +
  ' ///                                                          ' + #10#13 +
  '  I%FormIdentModel = interface(IModel)                        ' + #10#13 +
  '         [''%guid'']                                             ' + #10#13 +
  '    //InterfImplem                                            ' + #10#13 +
  '  end;                                                        ' + #10#13 +
  '                                                              ' + #10#13 +
  'Implementation                                                ' + #10#13 +
  'end.                                                          ' + #10#13;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassModelHead = 'unit %ModelIdent;                                   ' + #10#13
  + '                                                              ' + #10#13 +
  ' ///                                                ' + #10#13 +
  ' ///  <summary>                                     ' + #10#13 +
  ' ///     Model para implementar regras de negócio   ' + #10#13 +
  ' ///  </summary>                                    ' + #10#13 +
  ' ///                                                ' + #10#13 +
  '//%include                                                    ' + #10#13 +
  'interface                                                     ' + #10#13 +
  '                                                              ' + #10#13 +
  'uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes, MVCBr.Interf, MVCBr.Model,     '
  + #10#13 + '     %ClassUnit,                                              ' +
  #10#13 + '     %ModelIdent.interf, MVCBr.Controller;                    ' +
  #10#13 + '                                                              ' +
  #10#13;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassModelDef = 'type                                                 ' + #10#13
  + '                                                              ' + #10#13 +
  ' ///                                                          ' + #10#13 +
  ' ///  <summary>                                               ' + #10#13 +
  ' ///     Implementado Objeto Factory para o Model T%FormIdentModel' + #10#13
  + ' ///  </summary>                                              ' + #10#13 +
  ' ///                                                          ' + #10#13 +
  '  T%FormIdentModel = class(TModelFactory,I%FormIdentModel,' +
  '    IThisAs<T%FormIdentModel>)    ' + #10#13 +
  '  protected                                                   ' + #10#13 +
  '     F%ClassModel: %ClassConector;                            ' + #10#13 +
  '  public                                                      ' + #10#13 +
  '    Constructor Create; override;                             ' + #10#13 +
  '    Destructor Destroy; override;                             ' + #10#13 +
  '    function Base:%ClassConector;                         ' + #10#13 +
  '    class function new:I%FormIdentModel;overload;             ' + #10#13 +
  '    class function new(' + #10#13 +
  '      const AController:IController):I%FormIdentModel;overload;' + #10#13 +
  '    function ThisAs:T%FormIdentModel;                         ' + #10#13 +
  '    procedure AfterInit;override;                             ' + #10#13 +
  '    //  Codigo para a ClassModel                              ' + #10#13 +
  '    //InterfImplem                                            ' + #10#13 +
  '  end;                                                        ' + #10#13 +
  '                                                              ' + #10#13;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassModelImpl =
  ' ///  Implementações                                          ' + #10#13 +
  'Constructor T%FormIdentModel.Create;                ' + #10#13 +
  'begin                                                         ' + #10#13 +
  '  inherited create;                                           ' + #10#13 +
  '  F%ClassModel:= TMVCBr.InvokeCreate<%ClassConector>([nil]);  ' + #10#13 +
  'end;                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  'function T%FormIdentModel.Base:%ClassConector;              ' + #10#13 +
  'begin                                                         ' + #10#13 +
  '    result := F%ClassModel;                                   ' + #10#13 +
  'end;                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  'Destructor T%FormIdentModel.Destroy;                          ' + #10#13 +
  'begin                                                         ' + #10#13 +
  '  inherited;                                                  ' + #10#13 +
  'end;                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  ' ///  ThisAs Retorna o Object Factory do Model (instância)    ' + #10#13 +
  'function T%FormIdentModel.ThisAs: T%FormIdentModel;           ' + #10#13 +
  'begin                                                         ' + #10#13 +
  '  result := self;                                             ' + #10#13 +
  'end;                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  ' ///  Criar nova instância para o Model                      ' + #10#13 +
  'class function T%FormIdentModel.new:I%FormIdentModel;        ' + #10#13 +
  'begin                                                         ' + #10#13 +
  '   result := new(nil);                                        ' + #10#13 +
  'end;                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  'procedure T%FormIdentModel.AfterInit;                         ' + #10#13 +
  'begin                                                         ' + #10#13 +
  '    // executado apos concluido a carga do controller        ' + #10#13 +
  'end;                                                          ' + #10#13 +
  ' ///  <summary>                                               ' + #10#13 +
  ' ///  New - cria nova instância para o Model                  ' + #10#13 +
  ' ///  </summary>                                              ' + #10#13 +
  ' ///  <param name="AController">                              ' + #10#13 +
  ' ///     É o controller ao qual o Model esta associado        ' + #10#13 +
  ' ///  </param>                                                ' + #10#13 +
  ' ///  <returns>                                               ' + #10#13 +
  ' ///     retorna a interface                                  ' + #10#13 +
  ' ///  </returns>                                              ' + #10#13 +
  'class function T%FormIdentModel.new(const AController:IController):I%FormIdentModel;'
  + #10#13 + 'begin                                                         ' +
  #10#13 + '  result := T%FormIdentModel.create;                          ' +
  #10#13 + '  result.Controller(AController);                             ' +
  #10#13 + 'end;                                                          ' +
  #10#13 + '                                                      ' + #10#13 +
  '    //InterfCode                                              ' +
  #10#13 + #10#13;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassModelCode = ClassModelHead + ClassModelDef +
  '                                                              ' + #10#13 +
  'implementation                                                ' + #10#13 +
  '                                                              ' + #10#13 +
  '                                                              ' + #10#13 +
  ClassModelImpl +
  '                                                              ' + #10#13 +
  'Initialization                                                ' + #10#13 +
  '  TMVCRegister.RegisterType<I%FormIdentModel,T%FormIdentModel>(T%FormIdentModel.classname,true);'
  + #10#13 +
  'end.                                                          ' + #10#13;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassControllerInterf = 'Unit %ModelIdent;              ' + #10#13 +
  ' ///                                                ' + #10#13 +
  ' /// <summary>                                      ' + #10#13 +
  ' ///     Interface de acesso ao Model               ' + #10#13 +
  ' ///     O uso de interface permite diminuir o      ' + #10#13 +
  ' ///     acoplamento entre UNITs                    ' + #10#13 +
  ' /// </summary>                                     ' + #10#13 +
  ' ///                                                ' + #10#13 +
  '                                                              ' + #10#13 +
  'interface                                                     ' + #10#13 +
  '                                                              ' + #10#13 +
  '                                                              ' + #10#13 +
  'Uses MVCBr.Interf, MVCBr.Controller;                          ' + #10#13 +
  '                                                              ' + #10#13 +
  'Type                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  ' ///                                                          ' + #10#13 +
  ' /// Interface para o Controller                                   ' + #10#13
  + ' ///                                                          ' + #10#13 +
  '  I%FormIdentController = interface(IController)                   ' + #10#13
  + '         [''%guid'']                                             ' + #10#13
  + '    //InterfImplem                                            ' + #10#13 +
  '  end;                                                        ' + #10#13 +
  '                                                              ' + #10#13 +
  'Implementation                                                ' + #10#13 +
  'end.                                                          ' + #10#13;

classControllerCode = ClassModelHead +
  'type                                                 ' + #10#13 +
  '                                                              ' + #10#13 +
  ' ///                                                          ' + #10#13 +
  ' ///  <summary>                                               ' + #10#13 +
  ' ///     Implementado Objeto Factory para o Model T%FormIdentModel' + #10#13
  + ' ///  </summary>                                              ' + #10#13 +
  ' ///                                                          ' + #10#13 +
  '  T%FormIdentController = class(TControllerFactory,I%FormIdentController,' +
  '    IThisAs<T%FormIdentController>)    ' + #10#13 +
  '  protected                                                   ' + #10#13 +
  '    FBase:%ClassConector;                                     ' + #10#13 +
  '  public                                                      ' + #10#13 +
  '    Constructor Create; override;                             ' + #10#13 +
  '    Destructor Destroy; override;                             ' + #10#13 +
  '    class function new:I%FormIdentController;overload;        ' + #10#13 +
  '    function ThisAs:T%FormIdentController;                    ' + #10#13 +
  '    function Base: %ClassConector;                            ' + #10#13 +
  '    //  Codigo para a ClassController                         ' + #10#13 +
  '    //InterfImplem                                            ' + #10#13 +
  '  end;                                                        ' + #10#13 +
  '                                                              ' + #10#13 +
  '                                                              ' + #10#13 +
  'implementation                                                ' + #10#13 +
  '                                                              ' + #10#13 +
  '                                                              ' + #10#13 +
  ' ///  Implementações                                          ' + #10#13 +
  'Constructor T%FormIdentController.Create;                ' + #10#13 +
  'begin                                                         ' + #10#13 +
  '  inherited create;                                           ' + #10#13 +
  '  FBase := T%FormIdent.create(nil);                           ' + #10#13 +
  '  if supports(FBase,IView) then                               ' + #10#13 +
  '    View( FBase );                                            ' + #10#13 +
  'end;                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  'Destructor T%FormIdentController.Destroy;                          ' + #10#13
  + 'begin                                                         ' + #10#13 +
  '  inherited;                                                  ' + #10#13 +
  'end;                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  'function T%FormIdentController.Base:%ClassConector;           ' + #10#13 +
  'begin                                                         ' + #10#13 +
  '  result := FBase;                                            ' + #10#13 +
  'end;                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  ' ///  ThisAs Retorna o Object Factory do Model (instância)    ' + #10#13 +
  'function T%FormIdentController.ThisAs: T%FormIdentController;           ' +
  #10#13 + 'begin                                                         ' +
  #10#13 + '  result := self;                                             ' +
  #10#13 + 'end;                                                          ' +
  #10#13 + '                                                              ' +
  #10#13 + ' ///  Criar nova instância para o Model                      ' +
  #10#13 + 'class function T%FormIdentController.new:I%FormIdentController;        '
  + #10#13 + 'begin                                                         ' +
  #10#13 + '   result := T%FormIdentController.create;                    ' +
  #10#13 + 'end;                                                          ' +
  #10#13 + #10#13 + '                                                      ' +
  #10#13 + '    //InterfCode                                              ' +
  #10#13 + #10#13 +
  '                                                              ' + #10#13 +
  'Initialization                                                ' + #10#13 +
  '  TMVCRegister.RegisterType<I%FormIdentController,T%FormIdentController>(T%FormIdentController.classname,true);'
  + #10#13 +
  'end.                                                          ' + #10#13;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassModelCodeFMX = ClassModelCode;
