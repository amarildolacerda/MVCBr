viewmodecode = 'Unit %ModelIdent;                            ' + #10#13 +
  '                                                               ' + #10#13 +
  'interface                                                      ' + #10#13 +
  '                                                               ' + #10#13 +
  'uses MVCBr.Interf, MVCBr.ViewModel;                            ' + #10#13 +
  '                                                               ' + #10#13 +
  'Type                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
  '   I%FormIdentViewModel = interface(IViewModel)                ' + #10#13 +
  '   end;                                                        ' + #10#13 +
  '                                                               ' + #10#13 +
  '    T%FormIdentViewModel=class(TViewModelFactory,              ' + #10#13 +
  '      I%FormIdentViewModel, IViewModelAs<I%FormIdentViewModel>)' + #10#13 +
  '                                                               ' + #10#13 +
  '    public                                                     ' + #10#13 +
  '      function ViewModelAs:I%FormIdentViewModel;               ' + #10#13 +
  '    end;                                                       ' + #10#13 +
  '                                                               ' + #10#13 +
  'implementation                                                 ' + #10#13 +
  '                                                               ' + #10#13 +
  'function T%FormIdentViewModel.ViewModelAs:I%FormIdentViewModel;' + #10#13 +
  'begin                                                          ' + #10#13 +
  '  result := self;                                              ' + #10#13 +
  'end;                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
  '                                                               ' + #10#13 +
  'end.                                                           ' + #10#13;
