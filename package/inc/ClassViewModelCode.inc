ClassViewModelInterf = 'Unit %UnitIdent;              ' + #10#13 +
  ' ///   <summary>                                              ' + #10#13 +
  ' ///      Interface para o Model                              ' + #10#13 +
  ' ///   </summary>                                             ' + #10#13 +
  '                                                              ' + #10#13 +
  'interface                                                     ' + #10#13 +
  '                                                              ' + #10#13 +
  '                                                              ' + #10#13 +
  'Uses MVCBr.Interf,MVCBr.ViewModel;                            ' + #10#13 +
  '                                                              ' + #10#13 +
  'Type                                                          ' + #10#13 +
  ' ///                                                          ' + #10#13 +
  ' ///  Interface de acesso ao object factory                   ' + #10#13 +
  ' ///                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  '  I%FormIdentViewModel = interface(IViewModel)                        ' +
  #10#13 + '         [''%guid'']                                             ' +
  #10#13 + '    //InterfImplem                                            ' +
  #10#13 + '  end;                                                        ' +
  #10#13 + '                                                              ' +
  #10#13 + 'Implementation                                                ' +
  #10#13 + 'end.                                                          ' +
  #10#13;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassViewModelHead = 'unit %UnitIdent;                                   ' +
  #10#13 + ' /// <summary>                                                ' +
  #10#13 + ' ///    Object Factory para implementar a interface do Model  ' +
  #10#13 + ' /// </summary>                                               ' +
  #10#13 + '                                                              ' +
  #10#13 + '//%include                                                    ' +
  #10#13 + 'interface                                                     ' +
  #10#13 + '                                                              ' +
  #10#13 + 'uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes,'
  + 'MVCBr.Interf, MVCBr.ViewModel, ' + #10#13 +
  '     %ClassUnit,                                              ' + #10#13 +
  '     %ModelIdent.interf, MVCBr.Controller;                    ' + #10#13 +
  '                                                              ' + #10#13;
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassViewModelDef = 'type                                                 ' +
  #10#13 + '                                                              ' +
  #10#13 + '                                                              ' +
  #10#13 + '  T%FormIdentViewModel = class(TViewModelFactory,I%FormIdentViewModel,'
  + '    IThisAs<T%FormIdentViewModel>)    ' + #10#13 +
  '  protected                                                   ' + #10#13 +
  '  public                                                      ' + #10#13 +
  '    Constructor Create; override;                             ' + #10#13 +
  '    Destructor Destroy; override;                             ' + #10#13 +
  ' ///  New cria um nova instância para o Model                 ' + #10#13 +
  '    class function new:I%FormIdentViewModel;overload;             ' + #10#13
  + '    class function new(' + #10#13 +
  '      const AController:IController):I%FormIdentViewModel;overload;' + #10#13
  + ' ///  ThisAs retorna o próprio Object Factory                 ' + #10#13 +
  '    function ThisAs:T%FormIdentViewModel;                         ' + #10#13
  + ' ///  AfterInit é executado após a completar a carga do controller' +
  #10#13 + '    procedure AfterInit;override;                             ' +
  #10#13 + '    //  Codigo para a ClassModel                              ' +
  #10#13 + '    //InterfImplem                                            ' +
  #10#13 + '  end;                                                        ' +
  #10#13 + '                                                              ' +
  #10#13;
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassViewModelImpl = 'Constructor T%FormIdentViewModel.Create;                '
  + #10#13 + 'begin                                                         ' +
  #10#13 + '  inherited create;                                           ' +
  #10#13 + 'end;                                                          ' +
  #10#13 + '                                                              ' +
  #10#13 + '                                                              ' +
  #10#13 + 'Destructor T%FormIdentViewModel.Destroy;                          '
  + #10#13 + 'begin                                                         ' +
  #10#13 + '  inherited;                                                  ' +
  #10#13 + 'end;                                                          ' +
  #10#13 + '                                                              ' +
  #10#13 + 'function T%FormIdentViewModel.ThisAs: T%FormIdentViewModel;           '
  + #10#13 + 'begin                                                         ' +
  #10#13 + '  result := self;                                             ' +
  #10#13 + 'end;                                                          ' +
  #10#13 + '                                                              ' +
  #10#13 + 'class function T%FormIdentViewModel.new:I%FormIdentViewModel;        '
  + #10#13 + 'begin                                                         ' +
  #10#13 + '   result := new(nil);                                        ' +
  #10#13 + 'end;                                                          ' +
  #10#13 + '                                                              ' +
  #10#13 + 'procedure T%FormIdentViewModel.AfterInit;                         '
  + #10#13 + 'begin                                                         ' +
  #10#13 + '    // executado apos concluido o controller                 ' +
  #10#13 + 'end;                                                          ' +
  #10#13 + ' ///                                                          ' +
  #10#13 + ' /// <summary>                                                ' +
  #10#13 + ' ///    New cria uma nova instância para o Model              ' +
  #10#13 + ' /// </summary>                                               ' +
  #10#13 + ' /// <param name="AController">                               ' +
  #10#13 + ' ///    AController é o controller ao qual o Model esta       ' +
  #10#13 + ' ///    associado                                             ' +
  #10#13 + ' /// </param>                                                 ' +
  #10#13 + ' /// <returns>                                                ' +
  #10#13 + ' ///   Retorna a interface para o Model                       ' +
  #10#13 + ' /// </returns>                                               ' +
  #10#13 + 'class function T%FormIdentViewModel.new(const AController:IController):I%FormIdentViewModel;'
  + #10#13 + 'begin                                                         ' +
  #10#13 + '  result := T%FormIdentViewModel.create;                          '
  + #10#13 + '  result.Controller(AController);                             ' +
  #10#13 + 'end;                                                          ' +
  #10#13 + '                                                      ' + #10#13 +
  '    //InterfCode                                              ' +
  #10#13 + #10#13;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassViewModelCode = ClassViewModelHead + ClassViewModelDef +
  '                                                              ' + #10#13 +
  'implementation                                                ' + #10#13 +
  '                                                              ' + #10#13 +
  '                                                              ' + #10#13 +
  ClassViewModelImpl +
  'Initialization                                                ' + #10#13 +
  'end.                                                          ' + #10#13;

// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
ClassViewModelCodeFMX = ClassViewModelCode;
