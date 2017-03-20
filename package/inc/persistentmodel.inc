
ModelCodeBaseInterf = 'Unit %UnitIdent;                         ' + #13#10 +
  '                                                               ' + #13#10 +
  '                                                              ' + #13#10 +
  '{ MVCBr                                                       ' + #13#10 +
  '  www.tireideletra.com.br                                     ' + #13#10 +
  '  amarildo lacerda                                            ' + #13#10 +
  '}                                                             ' + #13#10 +
  '                                                              ' + #13#10 +
  'interface                                                     ' + #13#10 +
  '                                                              ' + #13#10 +
  'uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes,'
  + ' MVCBr.Interf, //%uses,  ' + #13#10 + '      //%Interf, ' + #13#10 +
  'MVCBr.Controller;                 ' + #13#10 +
  '                                                              ' + #13#10 +
  'Type                                                           ' + #13#10 +
  '  // Interface de acesso ao model                               ' + #13#10 +
  '  I%FormIdent%modelName = interface( %interfInherited )    ' + #13#10 +
  '         [''%guid'']                                          ' + #13#10 +
  '         // incluir aqui as especializações                   ' + #13#10 +
  '  end;                                                        ' + #13#10 +
  '                                                              ' + #13#10 +
  'Implementation                                                ' + #13#10 +
  'end.                                                          ' + #13#10;

ModelCodeBase = 'Unit  %UnitIdent;                         ' + #13#10 +
  '                                                               ' + #13#10 +
  '                                                              ' + #13#10 +
  '{ MVCBr                                                       ' + #13#10 +
  '  www.tireideletra.com.br                                     ' + #13#10 +
  '  amarildo lacerda                                            ' + #13#10 +
  '}                                                             ' + #13#10 +
  '                                                              ' + #13#10 +
  'interface                                                     ' + #13#10 +
  '//%include                                                    ' + #13#10 +
  'uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes,'
  + ' MVCBr.Interf, //%uses,     ' + #13#10 +
  '   %UnitIdent.Interf, //%Interf,  ' + #13#10 +
  'MVCBr.Controller;                 ' + #13#10 +
  '                                                              ' + #13#10 +
  'Type                                                           ' + #13#10 +
  '                                                              ' + #13#10 +
  '  T%FormIdent%modelName = class(%class,I%FormIdent%modelName,' +
  '    IThisAs<T%FormIdent%modelName>)    ' + #13#10 +
  '  protected                                                   ' + #13#10 +
  '  public                                                      ' + #13#10 +
  '    Constructor Create; override;                             ' + #13#10 +
  '    Destructor Destroy; override;                             ' + #13#10 +
  '    class function new():I%FormIdent%modelName; overload;           ' +
  #13#10 + '    class function new(const AController:IController):I%FormIdent%modelName;  overload;          '
  + #13#10 + '    function ThisAs:T%FormIdent%modelName;                ' +
  #13#10 + '                                                               ' +
  #13#10 + '      // implementaçoes                                        ' +
  #13#10 + '                                                               ' +
  #13#10 + '  end;                                                         ' +
  #13#10 + '                                                               ' +
  #13#10 + '                                                               ' +
  #13#10 + 'Implementation                                                 ' +
  #13#10 + '                                                               ' +
  #13#10 + 'constructor T%FormIdent%modelName.Create;                              '
  + #13#10 + 'begin                                                            '
  + #13#10 + '  inherited;                                                     '
  + #13#10 + '  ModelTypes := [%modelType];                                    '
  + #13#10 + 'end;                                                             '
  + #13#10 + '                                                                 '
  + #13#10 +
  'destructor T%FormIdent%modelName.Destroy;                              ' +
  #13#10 + 'begin                                                            ' +
  #13#10 + '  inherited;                                                     ' +
  #13#10 + 'end;                                                            ' +
  #13#10 + 'function T%FormIdent%modelName.ThisAs: T%FormIdent%modelName;      '
  + #13#10 + 'begin                                                            '
  + #13#10 + '  result := self;                                                '
  + #13#10 + 'end;                                                             '
  + #13#10 + '                                                               ' +
  #13#10 + 'class function T%FormIdent%modelName.new():I%FormIdent%modelName;           '
  + #13#10 + 'begin                                                          ' +
  #13#10 + '     result := new(nil);                                       ' +
  #13#10 + 'end;                                                           ' +
  #13#10 + '                                                               ' +
  #13#10 + 'class function T%FormIdent%modelName.new(const AController:IController):I%FormIdent%modelName;           '
  + #13#10 + 'begin                                               ' + #13#10 +
  '   result :=  T%FormIdent%modelName.create;                          ' +
  #13#10 + '   result.controller(AController);                             ' +
  #13#10 + 'end;                                                           ' +
  #13#10 + '                                                               ' +
  #13#10 + 'Initialization                                                 ' +
  #13#10 + 'TMVCRegister.RegisterType<I%FormIdent%modelName,T%FormIdent%modelName>(T%FormIdent%modelName.classname,true);'
  + #13#10 + 'end.                                                           ';
