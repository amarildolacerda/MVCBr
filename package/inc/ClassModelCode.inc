// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassModelInterf = 'Unit %UnitIdent;              ' + #13#10 +
  ' ///                                                ' + #13#10 +
  ' /// <summary>                                      ' + #13#10 +
  ' ///     Interface de acesso ao Model               ' + #13#10 +
  ' ///     O uso de interface permite diminuir o      ' + #13#10 +
  ' ///     acoplamento entre UNITs                    ' + #13#10 +
  ' /// </summary>                                     ' + #13#10 +
  ' ///                                                ' + #13#10 +
  '                                                              ' + #13#10 +
  'interface                                                     ' + #13#10 +
  '                                                              ' + #13#10 +
  '                                                              ' + #13#10 +
  'Uses MVCBr.Interf,MVCBr.Model;                               ' + #13#10 +
  '                                                              ' + #13#10 +
  'Type                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  ' ///                                                          ' + #13#10 +
  ' /// Interface para o Model                                   ' + #13#10 +
  ' ///                                                          ' + #13#10 +
  '  I%FormIdentModel = interface(IModel)                        ' + #13#10 +
  '         [''%guid'']                                             ' + #13#10 +
  '    //InterfImplem                                            ' + #13#10 +
  '  end;                                                        ' + #13#10 +
  '                                                              ' + #13#10 +
  'Implementation                                                ' + #13#10 +
  'end.                                                          ' + #13#10;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassModelHead = 'unit %UnitIdent;                                   ' + #13#10
  + '                                                              ' + #13#10 +
  ' ///                                                ' + #13#10 +
  ' ///  <summary>                                     ' + #13#10 +
  ' ///     Model para implementar regras de negócio   ' + #13#10 +
  ' ///  </summary>                                    ' + #13#10 +
  ' ///                                                ' + #13#10 +
  '//%include                                                    ' + #13#10 +
  'interface                                                     ' + #13#10 +
  '                                                              ' + #13#10 +
  'uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes, MVCBr.Interf, MVCBr.Model,     '
  + #13#10 + '     %ClassUnit,                                              ' +
  #13#10 + '     %ModelIdent.interf, MVCBr.Controller;                    ' +
  #13#10 + '                                                              ' +
  #13#10;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassModelDef = 'type                                                 ' + #13#10
  + '                                                              ' + #13#10 +
  ' ///                                                          ' + #13#10 +
  ' ///  <summary>                                               ' + #13#10 +
  ' ///     Implementado Objeto Factory para o Model T%FormIdentModel' + #13#10
  + ' ///  </summary>                                              ' + #13#10 +
  ' ///                                                          ' + #13#10 +
  '  T%FormIdentModel = class(TModelFactory,I%FormIdentModel,' +
  '    IThisAs<T%FormIdentModel>)    ' + #13#10 +
  '  protected                                                   ' + #13#10 +
  '     F%ClassModel: %ClassConector;                            ' + #13#10 +
  '  public                                                      ' + #13#10 +
  '    Constructor Create; override;                             ' + #13#10 +
  '    Destructor Destroy; override;                             ' + #13#10 +
  '    function Base:%ClassConector;                         ' + #13#10 +
  '    class function new:I%FormIdentModel;overload;             ' + #13#10 +
  '    class function new(' + #13#10 +
  '      const AController:IController):I%FormIdentModel;overload;' + #13#10 +
  '    function ThisAs:T%FormIdentModel;                         ' + #13#10 +
  '    procedure AfterInit;override;                             ' + #13#10 +
  '    //  Codigo para a ClassModel                              ' + #13#10 +
  '    //InterfImplem                                            ' + #13#10 +
  '  end;                                                        ' + #13#10 +
  '                                                              ' + #13#10;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassModelImpl =
  ' ///  Implementações                                          ' + #13#10 +
  'Constructor T%FormIdentModel.Create;                ' + #13#10 +
  'begin                                                         ' + #13#10 +
  '  inherited create;                                           ' + #13#10 +
  '  F%ClassModel:= TMVCBr.InvokeCreate<%ClassConector>([nil]);  ' + #13#10 +
  'end;                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  'function T%FormIdentModel.Base:%ClassConector;              ' + #13#10 +
  'begin                                                         ' + #13#10 +
  '    result := F%ClassModel;                                   ' + #13#10 +
  'end;                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  'Destructor T%FormIdentModel.Destroy;                          ' + #13#10 +
  'begin                                                         ' + #13#10 +
  '  inherited;                                                  ' + #13#10 +
  'end;                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  ' ///  ThisAs Retorna o Object Factory do Model (instância)    ' + #13#10 +
  'function T%FormIdentModel.ThisAs: T%FormIdentModel;           ' + #13#10 +
  'begin                                                         ' + #13#10 +
  '  result := self;                                             ' + #13#10 +
  'end;                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  ' ///  Criar nova instância para o Model                      ' + #13#10 +
  'class function T%FormIdentModel.new:I%FormIdentModel;        ' + #13#10 +
  'begin                                                         ' + #13#10 +
  '   result := new(nil);                                        ' + #13#10 +
  'end;                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  'procedure T%FormIdentModel.AfterInit;                         ' + #13#10 +
  'begin                                                         ' + #13#10 +
  '    // executado apos concluido a carga do controller        ' + #13#10 +
  'end;                                                          ' + #13#10 +
  ' ///  <summary>                                               ' + #13#10 +
  ' ///  New - cria nova instância para o Model                  ' + #13#10 +
  ' ///  </summary>                                              ' + #13#10 +
  ' ///  <param name="AController">                              ' + #13#10 +
  ' ///     É o controller ao qual o Model esta associado        ' + #13#10 +
  ' ///  </param>                                                ' + #13#10 +
  ' ///  <returns>                                               ' + #13#10 +
  ' ///     retorna a interface                                  ' + #13#10 +
  ' ///  </returns>                                              ' + #13#10 +
  'class function T%FormIdentModel.new(const AController:IController):I%FormIdentModel;'
  + #13#10 + 'begin                                                         ' +
  #13#10 + '  result := T%FormIdentModel.create;                          ' +
  #13#10 + '  result.Controller(AController);                             ' +
  #13#10 + 'end;                                                          ' +
  #13#10 + '                                                      ' + #13#10 +
  '    //InterfCode                                              ' +
  #13#10 + #13#10;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassModelCode = ClassModelHead + ClassModelDef +
  '                                                              ' + #13#10 +
  'implementation                                                ' + #13#10 +
  '                                                              ' + #13#10 +
  '                                                              ' + #13#10 +
  ClassModelImpl +
  '                                                              ' + #13#10 +
  'Initialization                                                ' + #13#10 +
  '  TMVCRegister.RegisterType<I%FormIdentModel,T%FormIdentModel>(T%FormIdentModel.classname,true);'
  + #13#10 +
  'end.                                                          ' + #13#10;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassControllerInterf = 'Unit %UnitIdent;              ' + #13#10 +
  ' ///                                                ' + #13#10 +
  ' /// <summary>                                      ' + #13#10 +
  ' ///     Interface de acesso ao Model               ' + #13#10 +
  ' ///     O uso de interface permite diminuir o      ' + #13#10 +
  ' ///     acoplamento entre UNITs                    ' + #13#10 +
  ' /// </summary>                                     ' + #13#10 +
  ' ///                                                ' + #13#10 +
  '                                                              ' + #13#10 +
  'interface                                                     ' + #13#10 +
  '                                                              ' + #13#10 +
  '                                                              ' + #13#10 +
  'Uses MVCBr.Interf, MVCBr.Controller;                          ' + #13#10 +
  '                                                              ' + #13#10 +
  'Type                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  ' ///                                                          ' + #13#10 +
  ' /// Interface para o Controller                                   ' + #13#10
  + ' ///                                                          ' + #13#10 +
  '  I%FormIdentController = interface(IController)                   ' + #13#10
  + '         [''%guid'']                                             ' + #13#10
  + '    //InterfImplem                                            ' + #13#10 +
  '  end;                                                        ' + #13#10 +
  '                                                              ' + #13#10 +
  'Implementation                                                ' + #13#10 +
  'end.                                                          ' + #13#10;

classControllerCode = ClassModelHead +
  'type                                                 ' + #13#10 +
  '                                                              ' + #13#10 +
  ' ///                                                          ' + #13#10 +
  ' ///  <summary>                                               ' + #13#10 +
  ' ///     Implementado Objeto Factory para o Model T%FormIdentModel' + #13#10
  + ' ///  </summary>                                              ' + #13#10 +
  ' ///                                                          ' + #13#10 +
  '  T%FormIdentController = class(TControllerFactory,I%FormIdentController,' +
  '    IThisAs<T%FormIdentController>)    ' + #13#10 +
  '  protected                                                   ' + #13#10 +
  '    FBase:%ClassConector;                                     ' + #13#10 +
  '  public                                                      ' + #13#10 +
  '    Constructor Create; override;                             ' + #13#10 +
  '    Destructor Destroy; override;                             ' + #13#10 +
  '    class function new:I%FormIdentController;overload;        ' + #13#10 +
  '    function ThisAs:T%FormIdentController;                    ' + #13#10 +
  '    function Base: %ClassConector;                            ' + #13#10 +
  '    //  Codigo para a ClassController                         ' + #13#10 +
  '    //InterfImplem                                            ' + #13#10 +
  '  end;                                                        ' + #13#10 +
  '                                                              ' + #13#10 +
  '                                                              ' + #13#10 +
  'implementation                                                ' + #13#10 +
  '                                                              ' + #13#10 +
  '                                                              ' + #13#10 +
  ' ///  Implementações                                          ' + #13#10 +
  'Constructor T%FormIdentController.Create;                ' + #13#10 +
  'begin                                                         ' + #13#10 +
  '  inherited create;                                           ' + #13#10 +
  '  FBase := T%FormIdent.create(nil);                           ' + #13#10 +
  '  if supports(FBase,IView) then                               ' + #13#10 +
  '    View( FBase );                                            ' + #13#10 +
  'end;                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  'Destructor T%FormIdentController.Destroy;                          ' + #13#10
  + 'begin                                                         ' + #13#10 +
  '  inherited;                                                  ' + #13#10 +
  'end;                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  'function T%FormIdentController.Base:%ClassConector;           ' + #13#10 +
  'begin                                                         ' + #13#10 +
  '  result := FBase;                                            ' + #13#10 +
  'end;                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  ' ///  ThisAs Retorna o Object Factory do Model (instância)    ' + #13#10 +
  'function T%FormIdentController.ThisAs: T%FormIdentController;           ' +
  #13#10 + 'begin                                                         ' +
  #13#10 + '  result := self;                                             ' +
  #13#10 + 'end;                                                          ' +
  #13#10 + '                                                              ' +
  #13#10 + ' ///  Criar nova instância para o Model                      ' +
  #13#10 + 'class function T%FormIdentController.new:I%FormIdentController;        '
  + #13#10 + 'begin                                                         ' +
  #13#10 + '   result := T%FormIdentController.create;                    ' +
  #13#10 + 'end;                                                          ' +
  #13#10 + #13#10 + '                                                      ' +
  #13#10 + '    //InterfCode                                              ' +
  #13#10 + #13#10 +
  '                                                              ' + #13#10 +
  'Initialization                                                ' + #13#10 +
  '  TMVCRegister.RegisterType<I%FormIdentController,T%FormIdentController>(T%FormIdentController.classname,true);'
  + #13#10 +
  'end.                                                          ' + #13#10;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassModelCodeFMX = ClassModelCode;
