ModelInterf = 'Unit %UnitIdent;              '+#13#10+
  '                                                              ' + #13#10 +
  'interface                                                     ' + #13#10 +
  '                                                              ' + #13#10 +
  '                                                              ' + #13#10 +
  'Uses MVCBr.Interf,MVCBr.Model;                               ' + #13#10 +
  '                                                              ' + #13#10 +
  'Type                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  '  I%FormIdentModel = interface(IModel)                        ' + #13#10 +
  '         [''%guid'']                                             ' + #13#10 +
  '  end;                                                        ' + #13#10 +
  '                                                              ' + #13#10 +
  'Implementation                                                ' + #13#10 +
  'end.                                                          ' + #13#10 ;

ModelHead = 'unit %UnitIdent;                                   ' + #13#10 +
  '                                                              ' + #13#10 +
  '{ MVCBr                                                       ' + #13#10 +
  '  www.tireideletra.com.br                                     ' + #13#10 +
  '  amarildo lacerda                                            ' + #13#10 +
  '}                                                             ' + #13#10 +
  '//%include                                                    ' + #13#10 +
  'interface                                                     ' + #13#10 +
  '                                                              ' + #13#10 +
  'uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes,'+
  'MVCBr.Interf, MVCBr.Model,     ' + #13#10 +
  '     %ModelIdent.interf, MVCBr.Controller;                    ' + #13#10 +
  '                                                              ' + #13#10;

ModelDef = 'type                                                 ' + #13#10 +
  '                                                              ' + #13#10 +
  '                                                              ' + #13#10 +
  '  T%FormIdentModel = class(TModelFactory,I%FormIdentModel,' +
  '    IThisAs<T%FormIdentModel>)    ' + #13#10 +
  '  protected                                                   ' + #13#10 +
  '  public                                                      ' + #13#10 +
  '    Constructor Create; override;                             ' + #13#10 +
  '    Destructor Destroy; override;                             ' + #13#10 +
  '    class function new:I%FormIdentModel;overload;             ' + #13#10 +
  '    class function new(' + #13#10 +
  '      const AController:IController):I%FormIdentModel;overload;' + #13#10 +
  '    function ThisAs:T%FormIdentModel;                         ' + #13#10 +
  '    procedure AfterInit;override;                             ' + #13#10 +

  '  end;                                                        ' + #13#10 +
  '                                                              ' + #13#10;

ModelImpl = 'Constructor T%FormIdentModel.Create;                ' + #13#10 +
  'begin                                                         ' + #13#10 +
  ' inherited create;                                            ' + #13#10 +
  'end;                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  'Destructor T%FormIdentModel.Destroy;                          ' + #13#10 +
  'begin                                                         ' + #13#10 +
  '  inherited;                                                  ' + #13#10 +
  'end;                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  'function T%FormIdentModel.ThisAs: T%FormIdentModel;           ' + #13#10 +
  'begin                                                         ' + #13#10 +
  '  result := self;                                             ' + #13#10 +
  'end;                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  'class function T%FormIdentModel.new:I%FormIdentModel;        ' + #13#10 +
  'begin                                                         ' + #13#10+
  '   result := new(nil);                                        ' + #13#10+
  'end;                                                          ' + #13#10+
  '                                                              ' + #13#10 +
  'procedure T%FormIdentModel.AfterInit;                         ' + #13#10 +
  'begin                                                         ' + #13#10 +
  '    // executado apos concluido o controller                 ' + #13#10 +
  'end;                                                          ' + #13#10 +
  'class function T%FormIdentModel.new(const AController:IController):I%FormIdentModel;'
  + #13#10 + 'begin                                                         ' +
  #13#10 + '  result := T%FormIdentModel.create;                          ' +
  #13#10 + '  result.Controller(AController);                             ' +
  #13#10 + 'end;                                                          ' +
  #13#10 + '                                                              ' +
  #13#10;

ModelCode = ModelHead + ModelDef +
  '                                                              ' + #13#10 +
  'implementation                                                ' + #13#10 +
  '                                                              ' + #13#10 +
  '                                                              ' + #13#10 +
  ModelImpl + '                                                              ' +
  'Initialization                                                ' + #13#10 +
  'TMVCRegister.RegisterType<I%FormIdentModel,T%FormIdentModel>(T%FormIdentModel.classname,true);' + #13#10 +
  #13#10 + 'end.                                                          ' +
  #13#10;


ModelCodeFMX = ModelCode;
