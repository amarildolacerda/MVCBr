ModelCodeCombo = 'IPersistentModel=TPersistentModelFactory' + #10#13 +
  'INavigatorModel=TNavigatorModelFactory' + #10#13 +
  'IValidateModel=TValidateModelFactory' + #10#13 + 'IModel=TModelFactory';
ModelCodeExt = 'PersistentModel' + #10#13 + 'NavigatorModel' + #10#13 +
  'ValidateModel' + #10#13 + 'Model';
ModelCodeType = 'mtPersistent' + #10#13 + 'mtNavigator' + #10#13 + 'mtValidate'
  + #10#13 + 'mtCommon';

ModelCodeBaseInterf = 'Unit  %ModelIdent;                         ' + #10#13 +
  '                                                               ' + #10#13 +
  '                                                              ' + #10#13 +
  '{ MVCBr                                                       ' + #10#13 +
  '  www.tireideletra.com.br                                     ' + #10#13 +
  '  amarildo lacerda                                            ' + #10#13 +
  '}                                                             ' + #10#13 +
  '                                                              ' + #10#13 +
  'interface                                                     ' + #10#13 +
  '                                                              ' + #10#13 +
  'uses Classes, forms, SysUtils, MVCBr.Interf, //%uses     ' + #10#13 +
  '     MVCBr.Controller;                 ' + #10#13 +
  '                                                              ' + #10#13 +
  'Type                                                           ' + #10#13 +
  '                                                              ' + #10#13 +
  '  I%FormIdent%mdl = interface(%intf)    ' + #10#13 +
  '         [''%guid'']                                          ' + #10#13 +
  '         // incluir aqui as especializações                   ' + #10#13 +
  '  end;                                                        ' + #10#13 +
  '                                                              ' + #10#13 +
  'Implementation                                                ' + #10#13 +
  'end.                                                          ' + #10#13;

ModelCodeBase = 'Unit  %ModelIdent;                         ' + #10#13 +
  '                                                               ' + #10#13 +
  '                                                              ' + #10#13 +
  '{ MVCBr                                                       ' + #10#13 +
  '  www.tireideletra.com.br                                     ' + #10#13 +
  '  amarildo lacerda                                            ' + #10#13 +
  '}                                                             ' + #10#13 +
  '                                                              ' + #10#13 +
  'interface                                                     ' + #10#13 +
  '                                                              ' + #10#13 +
  'uses Classes, forms, SysUtils, MVCBr.Interf, //%uses     ' + #10#13 +
  '   %ModelIdent.Interf,  MVCBr.Controller, MVCBr.%mdl;                 ' + #10#13 +
  '                                                              ' + #10#13 +
  'Type                                                           ' + #10#13 +
  '                                                              ' + #10#13 +
  '  T%FormIdent%mdl = class(%class,I%FormIdent%mdl,' +
  '    IThisAs<T%FormIdent%mdl>)    ' + #10#13 +
  '  protected                                                   ' + #10#13 +
  '  public                                                      ' + #10#13 +
  '    Constructor Create; override;                             ' + #10#13 +
  '    Destructor Destroy; override;                             ' + #10#13 +
  '    class function new():I%FormIdent%mdl; overload;           ' + #10#13 +
  '    class function new(const AController:IController):I%FormIdent%mdl;  overload;          '
  + #10#13 + '    function ThisAs:T%FormIdent%mdl;                ' + #10#13 +
  '  end;                                                         ' + #10#13 +
  '                                                               ' + #10#13 +
  '                                                               ' + #10#13 +
  'Implementation                                                 ' + #10#13 +
  '                                                               ' + #10#13 +
  'constructor T%FormIdent%mdl.Create;                              ' + #10#13 +
  'begin                                                            ' + #10#13 +
  '  inherited;                                                     ' + #10#13 +
  '  ModelTypes := [%modelType];                                    ' + #10#13 +
  'end;                                                             ' + #10#13 +
  '                                                                 ' + #10#13 +
  'destructor T%FormIdent%mdl.Destroy;                              ' + #10#13 +
  'begin                                                            ' + #10#13 +
  '  inherited;                                                     ' + #10#13 +
  'end;                                                            ' + #10#13 +
  'function T%FormIdent%mdl.ThisAs: T%FormIdent%mdl;      ' + #10#13 +
  'begin                                                            ' + #10#13 +
  '  result := self;                                                ' + #10#13 +
  'end;                                                             ' + #10#13 +
  '                                                               ' + #10#13 +
  'class function T%FormIdent%mdl.new():I%FormIdent%mdl;           ' + #10#13 +
  'begin                                                          ' + #10#13 +
  '     result := new(nil);                                       ' + #10#13 +
  'end;                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
  'class function T%FormIdent%mdl.new(const AController:IController):I%FormIdent%mdl;           '
  + #10#13 + 'begin                                               ' + #10#13 +
  '   result :=  T%FormIdent%mdl.create;                          ' + #10#13 +
  '   result.controller(AController);                             ' + #10#13 +
  'end;                                                           ' + #10#13 +
  '                                                               ' + #10#13 +
  'end.                                                           ';
