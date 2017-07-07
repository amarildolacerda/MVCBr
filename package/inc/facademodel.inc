facadeSubClass =
'unit %UnitIdent;                                          '+ #13#10 +
'                                                               '+ #13#10 +
'interface                                                      '+ #13#10 +
'                                                               '+ #13#10 +
'uses System.Classes, System.SysUtils, System.RTTI;             '+ #13#10 +
'                                                               '+ #13#10 +
'implementation                                                 '+ #13#10 +
'                                                               '+#13#10+
'uses  %facadeClass.Model;                                       '+ #13#10 +
'                                                               '+#13#10+
'function %FormIdentModelFunc(AParam: TValue): boolean;         '+ #13#10 +
'begin                                                          '+ #13#10 +
'    ///                                                        '+ #13#10 +
'    /// Implements your code here                              '+ #13#10 +
'    ///                                                        '+ #13#10 +
'end;                                                           '+ #13#10 +
'                                                               '+ #13#10 +
'procedure %FormIdentInit;                                      '+ #13#10 +
'begin                                                          '+ #13#10 +
'   %facadeClassModelRegister(''%command'',%FormIdentModelFunc);'+ #13#10 +
'end;                                                           '+ #13#10 +
'                                                               '+ #13#10 +
'initialization                                                 '+ #13#10 +
'/// register                                                   '+ #13#10 +
'   %FormIdentInit;                                         '+ #13#10 +
'                                                               '+ #13#10 +
'end. ';

facadeModelInterf =
'Unit %UnitIdent;              '+#13#10+
  '                                                              ' + #13#10 +
  'interface                                                     ' + #13#10 +
  '                                                              ' + #13#10 +
  '                                                              ' + #13#10 +
  'Uses MVCBr.Interf,MVCBr.Model, System.RTTI;                   ' + #13#10 +
  '                                                              ' + #13#10 +
  'Type                                                          ' + #13#10 +
  '                                                              ' + #13#10 +
  '  I%FormIdentModel = interface(IModel)                        ' + #13#10 +
  '         [''%guid'']                                             ' + #13#10 +
'    function ExecuteCommand(ACommand: TValue; AParam: TValue): boolean;'+#13#10+
  '  end;                                                        ' + #13#10 +
  '                                                              ' + #13#10 +
  'Implementation                                                ' + #13#10 +
  'end.                                                          ' + #13#10 ;

facadeModel =
'Unit %UnitIdent;                                                    '+#13#10+
'                                                                    '+#13#10+
'interface                                                           '+#13#10+
'                                                                    '+#13#10+
'                                                                    '+#13#10+
'uses System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,'+#13#10+
'  %ModelIdent.interf,                                               '+#13#10+
'  System.RTTI,                                                      '+#13#10+
'  MVCBr.Patterns.Facade,                                            '+#13#10+
'  MVCBr.Controller;                                                 '+#13#10+
'                                                                    '+#13#10+
'Type                                                                '+#13#10+
'                                                                    '+#13#10+
'  T%FormIdentModel = class(TModelFactory, I%FormIdentModel)             '+#13#10+
'  protected                                                         '+#13#10+
'    class var FFacade: TMVCBrFacade;                                '+#13#10+
'  public                                                            '+#13#10+
'    Constructor Create; override;                                   '+#13#10+
'    Destructor Destroy; override;                                   '+#13#10+
'                                                                    '+#13#10+
'    class function Facade: TMVCBrFacade;                            '+#13#10+
'    class procedure Release;                                        '+#13#10+
'                                                                    '+#13#10+
'    class function new(): I%FormIdentModel; overload;                    '+#13#10+
'    class function new(const AController: IController): I%FormIdentModel; overload; '+#13#10+
'    function ThisAs: T%FormIdentModel;                                   '+#13#10+
'    // implementaçoes                                               '+#13#10+
'    function ExecuteCommand(ACommand: TValue; AParam: TValue): boolean;'+#13#10+
'  end;                                                              '+#13#10+
'                                                                    '+#13#10+
'procedure %FormIdentModelRegister(ACommand: TValue; AFunc: TMVCBrFacateFunc);'+#13#10+
'                                                                    '+#13#10+
'Implementation                                                      '+#13#10+
'                                                                    '+#13#10+
'/// / livre de acoplamentos                                         '+#13#10+
'                                                                    '+#13#10+
'                                                                    '+#13#10+
'                                                                    '+#13#10+
'procedure %FormIdentModelRegister(ACommand: TValue; AFunc: TMVCBrFacateFunc);'+#13#10+
'begin                                                               '+#13#10+
'  T%FormIdentModel.Facade.add(ACommand, AFunc);                     '+#13#10+
'end;                                                                '+#13#10+
'                                                                    '+#13#10+
'class function T%FormIdentModel.Facade: TMVCBrFacade;               '+#13#10+
'begin                                                               '+#13#10+
'  if not assigned(FFacade) then                                     '+#13#10+
'    FFacade := TMVCBrFacade.new;                                    '+#13#10+
'  result := FFacade;                                                '+#13#10+
'end;                                                                '+#13#10+
'                                                                    '+#13#10+
'constructor T%FormIdentModel.Create;                                '+#13#10+
'begin                                                               '+#13#10+
'  inherited;                                                        '+#13#10+
'  ModelTypes := [mtCommon];                                         '+#13#10+
'end;                                                                '+#13#10+
'                                                                    '+#13#10+
'destructor T%FormIdentModel.Destroy;                                '+#13#10+
'begin                                                               '+#13#10+
'  inherited;                                                        '+#13#10+
'end;                                                                '+#13#10+
'                                                                    '+#13#10+
'function T%FormIdentModel.ExecuteCommand(ACommand, AParam: TValue): boolean;'+#13#10+
'begin                                                               '+#13#10+
'  result := FFacade.Execute(ACommand, AParam);                  '+#13#10+
'end;                                                                '+#13#10+
'                                                                    '+#13#10+
'function T%FormIdentModel.ThisAs: T%FormIdentModel;                 '+#13#10+
'begin                                                               '+#13#10+
'  result := self;                                                   '+#13#10+
'end;                                                                '+#13#10+
'                                                                    '+#13#10+
'class function T%FormIdentModel.new(): I%FormIdentModel;            '+#13#10+
'begin                                                               '+#13#10+
'  result := new(nil);                                               '+#13#10+
'end;                                                                '+#13#10+
'                                                                    '+#13#10+
'class function T%FormIdentModel.new(const AController: IController): I%FormIdentModel;'+#13#10+
'begin                                                               '+#13#10+
'  result := T%FormIdentModel.Create;                                '+#13#10+
'  result.Controller(AController);                                   '+#13#10+
'end;                                                                '+#13#10+
'                                                                    '+#13#10+
'class procedure T%FormIdentModel.Release;                           '+#13#10+
'begin                                                               '+#13#10+
'  if assigned(FFacade) then                                         '+#13#10+
'    FFacade.free;                                                   '+#13#10+
'end;                                                                '+#13#10+
'                                                                    '+#13#10+
'Initialization                                                      '+#13#10+
'                                                                    '+#13#10+
'TMVCRegister.RegisterType<I%FormIdentModel, T%FormIdentModel>(T%FormIdentModel.classname, true); '+#13#10+
'                                                                    '+#13#10+
'finalization                                                        '+#13#10+
'                                                                    '+#13#10+
'T%FormIdentModel.Release;                                           '+#13#10+
'                                                                    '+#13#10+
'end.                                                                '+#13#10;

