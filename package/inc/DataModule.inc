
dataModuleAncestorName = 'Datamodule';

dataModuleCodeInterf =
'// Implementação para o interface:  I%FormIdent '+#10#13+
'// Data: %date                                                    '+#10#13+
'// Criado automático pelo assistente do MVCBr (amarildo lacerda)  '+#10#13+
'//                                                                '+#10#13+
'// ---------------------------------------------------------------'+#10#13+
'Unit %ModelIdent;                                                 '+#10#13+
'                                                                  '+#10#13+
'//%include                                                        '+#10#13+
'interface                                                         '+#10#13+
'                                                                  '+#10#13+
'uses Forms, System.Classes, System.SysUtils, System.RTTI,         '+#10#13+
'     MVCBr.Interf, MVCBr.Model,MVCBr.Controller,MVCBr.ModuleModel;'+#10#13+
'                                                                  '+#10#13+
'Type                                                              '+#10#13+
'                                                                  '+#10#13+
'    I%FormIdent = interface(IModuleModel)              '+#10#13+
'       [''%guid'']                                                '+#10#13+
'       // incluir aqui as especializações                         '+#10#13+
'    end;                                                          '+#10#13+
'                                                                  '+#10#13+
'implementation                                                    '+#10#13+
'                                                                  '+#10#13+
'                                                                  '+#10#13+
'end.                                                              '+#10#13;



dataModuleCode =
'// Implementação para o interface:  I%FormIdent '+#10#13+
'// Data: %date                                                    '+#10#13+
'// Criado automático pelo assistente do MVCBr (amarildo lacerda)  '+#10#13+
'//                                                                '+#10#13+
'// ---------------------------------------------------------------'+#10#13+
'                                                                  '+#10#13+
'Unit %ModelIdent;                                                 '+#10#13+
'                                                                  '+#10#13+
'//%include                                                        '+#10#13+
'interface                                                         '+#10#13+
'                                                                  '+#10#13+
'uses Forms, System.Classes, System.SysUtils, System.RTTI,         '+#10#13+
'     %ModelIdent.Interf, MVCBr.ModuleModel,                         '+#10#13+
'     MVCBr.Interf, MVCBr.Model, MVCBr.Controller;                 '+#10#13+
'                                                                  '+#10#13+
'Type                                                              '+#10#13+
'    // Class para implementar o I%FormIdent                  '+#10#13+
'    T%FormIdent = class(TModuleFactory ,I%FormIdent, IThisAs<T%FormIdent>)'+#10#13+
'    private                                                       '+#10#13+
'                                                                  '+#10#13+
'    protected                                                     '+#10#13+
'      function ThisAs: T%FormIdent;                               '+#10#13+
'    public                                                        '+#10#13+
'      class Function New():I%FormIdent; overload;                 '+#10#13+
'      class function new(const AController: IController)          '+#10#13+
'          : I%FormIdent; overload;                                '+#10#13+
'     // incluir as especializações da interface  I%FormIdent '+#10#13+
'    end;                                                          '+#10#13+
'                                                                  '+#10#13+
'implementation                                                    '+#10#13+
'                                                                  '+#10#13+
'{$R *.dfm}                                                         '+#10#13+
'                                                                  '+#10#13+
'function T%FormIdent.ThisAs: T%FormIdent;                         '+#10#13+
'begin                                                             '+#10#13+
'    result := self;                                               '+#10#13+
'end;                                                              '+#10#13+
'                                                                  '+#10#13+
'class Function T%FormIdent.New():I%FormIdent;                     '+#10#13+
'begin                                                             '+#10#13+
'   result :=  new(nil);                                           '+#10#13+
'end;                                                              '+#10#13+
'                                                                  '+#10#13+
'class function T%FormIdent.new(const AController: IController)    '+#10#13+
'          : I%FormIdent;                                          '+#10#13+
'begin                                                             '+#10#13+
'   result :=  T%FormIdent.create(nil);                            '+#10#13+
'   result.Controller(AController);                                '+#10#13+
'end;                                                              '+#10#13+
'                                                                  '+#10#13+
'end.                                                              '+#10#13;


dataModuleDFM =
'object ModuleFactory: TModuleFactory '+#10#13+
'end';



