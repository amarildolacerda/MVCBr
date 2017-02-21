viewmodecodeInterf =
'/// <summary>                                                      ' + #10#13 +
'///   O ViewModel esta conectado diretamente com a VIEW           ' + #10#13 +
'///   e possui um Controller ao qual esta associado               ' + #10#13 +
'/// </summary>                                                    ' + #10#13 +
'Unit %UnitIdent.ViewModel.Interf;                    ' + #10#13 +
  '                                                               ' + #10#13 +
  'interface                                                      ' + #10#13 +
  '                                                               ' + #10#13 +
  'uses MVCBr.Interf, MVCBr.ViewModel;                            ' + #10#13 +
  '                                                               ' + #10#13 +
  'Type                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
'///  Interaface para o ViewModel                                  ' + #10#13 +
  '   I%FormIdentViewModel = interface(IViewModel)                ' + #10#13 +
  '         [''%guid'']                                           ' + #10#13 +
  '         // incluir especializações aqui                         ' + #10#13 +
  '   end;                                                        ' + #10#13 +
  '                                                               ' + #10#13 +
  'Implementation                                                 ' + #10#13 +
  '                                                               ' + #10#13 +
  'end.                                                           ' + #10#13 ;

viewmodecode = 'Unit %UnitIdent.ViewModel;                            ' + #10#13 +
  '                                                               ' + #10#13 +
  'interface                                                      ' + #10#13 +
  '//%include                                                     ' + #10#13 +
  'uses MVCBr.Interf, MVCBr.ViewModel, %UnitIdent.ViewModel.Interf;' + #10#13 +
  '                                                               ' + #10#13 +
  'Type                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
'///  Object Factory para o ViewModel                              ' + #10#13 +
  '    T%FormIdentViewModel=class(TViewModelFactory,              ' + #10#13 +
  '      I%FormIdentViewModel, IViewModelAs<I%FormIdentViewModel>)' + #10#13 +
  '                                                               ' + #10#13 +
  '    public                                                     ' + #10#13 +
  '      function ViewModelAs:I%FormIdentViewModel;               ' + #10#13 +
  '      class function new():I%FormIdentViewModel;overload;               ' + #10#13 +
  '      class function new(const AController:IController):I%FormIdentViewModel; overload;' + #10#13 +
  '      procedure AfterInit;override;                            ' + #10#13 +
  '    end;                                                       ' + #10#13 +
  '                                                               ' + #10#13 +
  'implementation                                                 ' + #10#13 +
  '                                                               ' + #10#13 +
  'function T%FormIdentViewModel.ViewModelAs:I%FormIdentViewModel;' + #10#13 +
  'begin                                                          ' + #10#13 +
  '  result := self;                                              ' + #10#13 +
  'end;                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
  'class function T%FormIdentViewModel.new():I%FormIdentViewModel;' + #10#13 +
  'begin                                                          ' + #10#13 +
  '  result := new(nil);                                          ' + #10#13 +
  'end;                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
'/// <summary>                                                     ' + #10#13 +
'///   New cria uma nova instância para o ViewModel                ' + #10#13 +
'/// </summary>                                                    ' + #10#13 +
'/// <param name="AController">                                    ' + #10#13 +
'///   AController é o controller ao qual o ViewModel esta         ' + #10#13 +
'///   ligado                                                      ' + #10#13 +
'/// </param>                                                      ' + #10#13 +
  'class function T%FormIdentViewModel.new(const AController:IController):I%FormIdentViewModel;' + #10#13 +
  'begin                                                          ' + #10#13 +
  '  result := T%FormIdentViewModel.create;                       ' + #10#13 +
  '  result.controller(AController);                             ' + #10#13 +
  'end;                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
  'procedure T%FormIdentViewModel.AfterInit;                      ' + #10#13 +
  'begin                                                          ' + #10#13 +
  '    // evento disparado apos a definicao do Controller;        ' + #10#13 +
  '                                                               ' + #10#13 +
  'end;                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
  'end.                                                           ' + #10#13;
