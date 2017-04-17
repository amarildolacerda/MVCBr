viewmodecodeInterf =
'/// <summary>                                                      ' + #13#10 +
'///   O ViewModel esta conectado diretamente com a VIEW           ' + #13#10 +
'///   e possui um Controller ao qual esta associado               ' + #13#10 +
'/// </summary>                                                    ' + #13#10 +
'unit %UnitIdent;                    ' + #13#10 +
  '                                                               ' + #13#10 +
  'interface                                                      ' + #13#10 +
  '                                                               ' + #13#10 +
  'uses MVCBr.Interf, MVCBr.ViewModel;                            ' + #13#10 +
  '                                                               ' + #13#10 +
  'Type                                                           ' + #13#10 +
  '                                                               ' + #13#10 +
'///  Interaface para o ViewModel                                  ' + #13#10 +
  '   I%FormIdentViewModel = interface(IViewModel)                ' + #13#10 +
  '         [''%guid'']                                           ' + #13#10 +
  '         // incluir especializações aqui                         ' + #13#10 +
  '   end;                                                        ' + #13#10 +
  '                                                               ' + #13#10 +
  'Implementation                                                 ' + #13#10 +
  '                                                               ' + #13#10 +
  'end.                                                           ' + #13#10 ;

viewmodecode = 'unit %UnitIdent;                            ' + #13#10 +
  '                                                               ' + #13#10 +
  'interface                                                      ' + #13#10 +
  '//%include                                                     ' + #13#10 +
  'uses MVCBr.Interf, MVCBr.ViewModel, %UnitIdent.Interf;' + #13#10 +
  '                                                               ' + #13#10 +
  'Type                                                           ' + #13#10 +
  '                                                               ' + #13#10 +
'///  Object Factory para o ViewModel                              ' + #13#10 +
  '    T%FormIdentViewModel=class(TViewModelFactory,              ' + #13#10 +
  '      I%FormIdentViewModel, IViewModelAs<I%FormIdentViewModel>)' + #13#10 +
  '                                                               ' + #13#10 +
  '    public                                                     ' + #13#10 +
  '      function ViewModelAs:I%FormIdentViewModel;               ' + #13#10 +
  '      class function new():I%FormIdentViewModel;overload;               ' + #13#10 +
  '      class function new(const AController:IController):I%FormIdentViewModel; overload;' + #13#10 +
  '      procedure AfterInit;override;                            ' + #13#10 +
  '    end;                                                       ' + #13#10 +
  '                                                               ' + #13#10 +
  'implementation                                                 ' + #13#10 +
  '                                                               ' + #13#10 +
  'function T%FormIdentViewModel.ViewModelAs:I%FormIdentViewModel;' + #13#10 +
  'begin                                                          ' + #13#10 +
  '  result := self;                                              ' + #13#10 +
  'end;                                                           ' + #13#10 +
  '                                                               ' + #13#10 +
  'class function T%FormIdentViewModel.new():I%FormIdentViewModel;' + #13#10 +
  'begin                                                          ' + #13#10 +
  '  result := new(nil);                                          ' + #13#10 +
  'end;                                                           ' + #13#10 +
  '                                                               ' + #13#10 +
'/// <summary>                                                     ' + #13#10 +
'///   New cria uma nova instância para o ViewModel                ' + #13#10 +
'/// </summary>                                                    ' + #13#10 +
'/// <param name="AController">                                    ' + #13#10 +
'///   AController é o controller ao qual o ViewModel esta         ' + #13#10 +
'///   ligado                                                      ' + #13#10 +
'/// </param>                                                      ' + #13#10 +
  'class function T%FormIdentViewModel.new(const AController:IController):I%FormIdentViewModel;' + #13#10 +
  'begin                                                          ' + #13#10 +
  '  result := T%FormIdentViewModel.create;                       ' + #13#10 +
  '  result.controller(AController);                             ' + #13#10 +
  'end;                                                           ' + #13#10 +
  '                                                               ' + #13#10 +
  'procedure T%FormIdentViewModel.AfterInit;                      ' + #13#10 +
  'begin                                                          ' + #13#10 +
  '    // evento disparado apos a definicao do Controller;        ' + #13#10 +
  '                                                               ' + #13#10 +
  'end;                                                           ' + #13#10 +
  '                                                               ' + #13#10 +
  'end.                                                           ' + #13#10;
