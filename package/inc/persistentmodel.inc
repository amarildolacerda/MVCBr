
ModelCodeBaseInterf = 'Unit  %ModelIdent ;                         ' + #10#13 +
  '                                                               ' + #10#13 +
  '                                                              ' + #10#13 +
  '{ MVCBr                                                       ' + #10#13 +
  '  www.tireideletra.com.br                                     ' + #10#13 +
  '  amarildo lacerda                                            ' + #10#13 +
  '}                                                             ' + #10#13 +
  '                                                              ' + #10#13 +
  'interface                                                     ' + #10#13 +
  '                                                              ' + #10#13 +
  'uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes,'+
  ' MVCBr.Interf, //%uses,  ' + #10#13 +
  '      //%Interf, ' + #10#13 + 'MVCBr.Controller;                 ' + #10#13 +
  '                                                              ' + #10#13 +
  'Type                                                           ' + #10#13 +
  '  // Interface de acesso ao model                               ' + #10#13 +
  '  I%FormIdent%modelName = interface( %interfInherited )    ' + #10#13 +
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
  '//%include                                                    ' + #10#13 +
  'uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes,'+
  ' MVCBr.Interf, //%uses,     ' + #10#13 +
  '   %ModelIdent.Interf, //%Interf,  ' + #10#13 +
  'MVCBr.Controller;                 ' + #10#13 +
  '                                                              ' + #10#13 +
  'Type                                                           ' + #10#13 +
  '                                                              ' + #10#13 +
  '  T%FormIdent%modelName = class(%class,I%FormIdent%modelName,' +
  '    IThisAs<T%FormIdent%modelName>)    ' + #10#13 +
  '  protected                                                   ' + #10#13 +
  '  public                                                      ' + #10#13 +
  '    Constructor Create; override;                             ' + #10#13 +
  '    Destructor Destroy; override;                             ' + #10#13 +
  '    class function new():I%FormIdent%modelName; overload;           ' +
  #10#13 + '    class function new(const AController:IController):I%FormIdent%modelName;  overload;          '
  + #10#13 + '    function ThisAs:T%FormIdent%modelName;                ' +
  #10#13 + '                                                               ' +
  #10#13 + '      // implementaçoes                                        ' +
  #10#13 + '                                                               ' +
  #10#13 + '  end;                                                         ' +
  #10#13 + '                                                               ' +
  #10#13 + '                                                               ' +
  #10#13 + 'Implementation                                                 ' +
  #10#13 + '                                                               ' +
  #10#13 + 'constructor T%FormIdent%modelName.Create;                              '
  + #10#13 + 'begin                                                            '
  + #10#13 + '  inherited;                                                     '
  + #10#13 + '  ModelTypes := [%modelType];                                    '
  + #10#13 + 'end;                                                             '
  + #10#13 + '                                                                 '
  + #10#13 +
  'destructor T%FormIdent%modelName.Destroy;                              ' +
  #10#13 + 'begin                                                            ' +
  #10#13 + '  inherited;                                                     ' +
  #10#13 + 'end;                                                            ' +
  #10#13 + 'function T%FormIdent%modelName.ThisAs: T%FormIdent%modelName;      '
  + #10#13 + 'begin                                                            '
  + #10#13 + '  result := self;                                                '
  + #10#13 + 'end;                                                             '
  + #10#13 + '                                                               ' +
  #10#13 + 'class function T%FormIdent%modelName.new():I%FormIdent%modelName;           '
  + #10#13 + 'begin                                                          ' +
  #10#13 + '     result := new(nil);                                       ' +
  #10#13 + 'end;                                                           ' +
  #10#13 + '                                                               ' +
  #10#13 + 'class function T%FormIdent%modelName.new(const AController:IController):I%FormIdent%modelName;           '
  + #10#13 + 'begin                                               ' + #10#13 +
  '   result :=  T%FormIdent%modelName.create;                          ' +
  #10#13 + '   result.controller(AController);                             ' +
  #10#13 + 'end;                                                           ' +
  #10#13 + '                                                               ' +
  #10#13 + 'end.                                                           ';
