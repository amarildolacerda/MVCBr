ModelInterf = 'Unit %ModelIdent;              '+#10#13+
  '                                                              ' + #10#13 +
  'interface                                                     ' + #10#13 +
  '                                                              ' + #10#13 +
  '                                                              ' + #10#13 +
  'Uses MVCBr.Interf,MVCBr.Model;                               ' + #10#13 +
  '                                                              ' + #10#13 +
  'Type                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  '  I%FormIdentModel = interface(IModel)                        ' + #10#13 +
  '         [''%guid'']                                             ' + #10#13 +
  '  end;                                                        ' + #10#13 +
  '                                                              ' + #10#13 +
  'Implementation                                                ' + #10#13 +
  'end.                                                          ' + #10#13 ;

ModelHead = 'unit %ModelIdent;                                   ' + #10#13 +
  '                                                              ' + #10#13 +
  '{ MVCBr                                                       ' + #10#13 +
  '  www.tireideletra.com.br                                     ' + #10#13 +
  '  amarildo lacerda                                            ' + #10#13 +
  '}                                                             ' + #10#13 +
  '//%include                                                    ' + #10#13 +
  'interface                                                     ' + #10#13 +
  '                                                              ' + #10#13 +
  'uses Classes, forms, SysUtils, MVCBr.Interf, MVCBr.Model,     ' + #10#13 +
  '     %ModelIdent.interf, MVCBr.Controller;                    ' + #10#13 +
  '                                                              ' + #10#13;

ModelDef = 'type                                                 ' + #10#13 +
  '                                                              ' + #10#13 +
  '                                                              ' + #10#13 +
  '  T%FormIdentModel = class(TModelFactory,I%FormIdentModel,' +
  '    IThisAs<T%FormIdentModel>)    ' + #10#13 +
  '  protected                                                   ' + #10#13 +
  '  public                                                      ' + #10#13 +
  '    Constructor Create; override;                             ' + #10#13 +
  '    Destructor Destroy; override;                             ' + #10#13 +
  '    class function new:I%FormIdentModel;overload;             ' + #10#13 +
  '    class function new(' + #10#13 +
  '      const AController:IController):I%FormIdentModel;overload;' + #10#13 +
  '    function ThisAs:T%FormIdentModel;                         ' + #10#13 +
  '  end;                                                        ' + #10#13 +
  '                                                              ' + #10#13;

ModelImpl = 'Constructor T%FormIdentModel.Create;                ' + #10#13 +
  'begin                                                         ' + #10#13 +
  ' inherited create;                                            ' + #10#13 +
  'end;                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  'Destructor T%FormIdentModel.Destroy;                          ' + #10#13 +
  'begin                                                         ' + #10#13 +
  '  inherited;                                                  ' + #10#13 +
  'end;                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  'function T%FormIdentModel.ThisAs: T%FormIdentModel;           ' + #10#13 +
  'begin                                                         ' + #10#13 +
  '  result := self;                                             ' + #10#13 +
  'end;                                                          ' + #10#13 +
  '                                                              ' + #10#13 +
  'class function T%FormIdentModel.new:I%FormIdentModel;        ' + #10#13 +
  'begin                                                         ' + #10#13+
  '   result := new(nil);                                        ' + #10#13+
  'end;                                                          ' + #10#13+
  '                                                              ' + #10#13 +
  'class function T%FormIdentModel.new(const AController:IController):I%FormIdentModel;'
  + #10#13 + 'begin                                                         ' +
  #10#13 + '  result := T%FormIdentModel.create;                          ' +
  #10#13 + '  result.Controller(AController);                             ' +
  #10#13 + 'end;                                                          ' +
  #10#13 + '                                                              ' +
  #10#13;

ModelCode = ModelHead + ModelDef +
  '                                                              ' + #10#13 +
  'implementation                                                ' + #10#13 +
  '                                                              ' + #10#13 +
  '                                                              ' + #10#13 +
  ModelImpl + '                                                              ' +
  #10#13 + 'end.                                                          ' +
  #10#13;


ModelCodeFMX = ModelCode;
