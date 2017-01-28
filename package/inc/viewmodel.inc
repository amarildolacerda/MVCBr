viewmodecodeInterf = 'Unit %ModelIdent;                    ' + #10#13 +
  '                                                               ' + #10#13 +
  'interface                                                      ' + #10#13 +
  '                                                               ' + #10#13 +
  'uses MVCBr.Interf, MVCBr.ViewModel;                            ' + #10#13 +
  '                                                               ' + #10#13 +
  'Type                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
  '   I%FormIdentViewModel = interface(IViewModel)                ' + #10#13 +
  '         [''%guid'']                                           ' + #10#13 +
  '         // incluir especializações aqui                         ' + #10#13 +
  '   end;                                                        ' + #10#13 +
  '                                                               ' + #10#13 +
  'Implementation                                                 ' + #10#13 +
  '                                                               ' + #10#13 +
  'end.                                                           ' + #10#13 ;

viewmodecode = 'Unit %ModelIdent;                            ' + #10#13 +
  '                                                               ' + #10#13 +
  'interface                                                      ' + #10#13 +
  '                                                               ' + #10#13 +
  'uses MVCBr.Interf, MVCBr.ViewModel, %ModelIdent.Interf;        ' + #10#13 +
  '                                                               ' + #10#13 +
  'Type                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
  '                                                               ' + #10#13 +
  '    T%FormIdentViewModel=class(TViewModelFactory,              ' + #10#13 +
  '      I%FormIdentViewModel, IViewModelAs<I%FormIdentViewModel>)' + #10#13 +
  '                                                               ' + #10#13 +
  '    public                                                     ' + #10#13 +
  '      function ViewModelAs:I%FormIdentViewModel;               ' + #10#13 +
  '      class function new():I%FormIdentViewModel;overload;               ' + #10#13 +
  '      class function new(const AController:IController):I%FormIdentViewModel; overload;' + #10#13 +
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
  'class function T%FormIdentViewModel.new(const AController:IController):I%FormIdentViewModel;' + #10#13 +
  'begin                                                          ' + #10#13 +
  '  result := T%FormIdentViewModel.create;                       ' + #10#13 +
  '  result.controller(AController);                             ' + #10#13 +
  'end;                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
  'end.                                                           ' + #10#13;
