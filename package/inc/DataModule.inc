
dataModuleAncestorName = 'Datamodule';

dataModuleCodeInterf =
'/// <summary>                                                ' + #13#10 +
'/// Implementação para a interface:  I%FormIdent '+#13#10+
'/// </summary>                                                    '+#13#10+
'Unit %UnitIdent;                                                 '+#13#10+
'                                                                  '+#13#10+
'//%include                                                        '+#13#10+
'interface                                                         '+#13#10+
'                                                                  '+#13#10+
'uses System.SysUtils, System.Classes,'+#13#10+
'     MVCBr.Interf, MVCBr.Model,MVCBr.Controller,MVCBr.ModuleModel;'+#13#10+
'                                                                  '+#13#10+
'Type                                                              '+#13#10+
'                                                                  '+#13#10+
' /// Interaface para o ModuleModel                            ' + #13#10 +
'    I%FormIdent = interface(IModuleModel)              '+#13#10+
'       [''%guid'']                                                '+#13#10+
'       // incluir aqui as especializações                         '+#13#10+
'    end;                                                          '+#13#10+
'                                                                  '+#13#10+
'implementation                                                    '+#13#10+
'                                                                  '+#13#10+
'                                                                  '+#13#10+
'end.                                                              '+#13#10;



dataModuleCode =
'/// <summary>                                                ' + #13#10 +
'///    Implementação para o interface:  I%FormIdent '+#13#10+
'/// </summary>                                                    '+#13#10+
'Unit %ModelIdent;                                                 '+#13#10+
'                                                                  '+#13#10+
'//%include                                                        '+#13#10+
'interface                                                         '+#13#10+
'                                                                  '+#13#10+
'uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes,'+#13#10+
'     %UnitIdent.Interf, MVCBr.ModuleModel,                         '+#13#10+
'     MVCBr.Interf, MVCBr.Model, MVCBr.Controller;                 '+#13#10+
'                                                                  '+#13#10+
'Type                                                              '+#13#10+
'    // Class para implementar o I%FormIdent                  '+#13#10+
'    T%FormIdent = class(TModuleFactory ,I%FormIdent, IThisAs<T%FormIdent>)'+#13#10+
'    private                                                       '+#13#10+
'                                                                  '+#13#10+
'    protected                                                     '+#13#10+
'///  ThisAs retorna o Object Factory para a interface        ' + #13#10 +
'      function ThisAs: T%FormIdent;                               '+#13#10+
'    public                                                        '+#13#10+
'      class Function New():I%FormIdent; overload;                 '+#13#10+
'      class function new(const AController: IController)          '+#13#10+
'          : I%FormIdent; overload;                                '+#13#10+
'     // incluir as especializações da interface  I%FormIdent '+#13#10+
'    end;                                                          '+#13#10+
'                                                                  '+#13#10+
'implementation                                                    '+#13#10+
'                                                                  '+#13#10+
'{$R *.dfm}                                                         '+#13#10+
'                                                                  '+#13#10+
'/// ThisAs retorna o Object Factory para a interface         ' + #13#10 +
'function T%FormIdent.ThisAs: T%FormIdent;                         '+#13#10+
'begin                                                             '+#13#10+
'    result := self;                                               '+#13#10+
'end;                                                              '+#13#10+
'                                                                  '+#13#10+
'class Function T%FormIdent.New():I%FormIdent;                     '+#13#10+
'begin                                                             '+#13#10+
'   result :=  new(nil);                                           '+#13#10+
'end;                                                              '+#13#10+
'                                                                  '+#13#10+
'/// <summary>                                                     ' + #13#10 +
'///     New cria uma nova instância para o Object Factory         ' + #13#10 +
'/// </summary>                                                    ' + #13#10 +
'/// <param name="AController">                                    ' + #13#10 +
'///    AController é o controller ao qual o módulo esta associado ' + #13#10 +
'/// </param>                                                      ' + #13#10 +
'class function T%FormIdent.new(const AController: IController)    '+#13#10+
'          : I%FormIdent;                                          '+#13#10+
'begin                                                             '+#13#10+
'   result :=  T%FormIdent.create(nil);                            '+#13#10+
'   result.Controller(AController);                                '+#13#10+
'end;                                                              '+#13#10+
'Initialization                                                    '+#13#10+
'  TMVCRegister.RegisterType<I%FormIdent,T%FormIdent>(T%FormIdent.classname,true);' + #13#10 +
'end.                                                              '+#13#10;


dataModuleDFM =
'object ModuleFactory: TModuleFactory '+#13#10+
'end';



