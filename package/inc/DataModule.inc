
dataModuleAncestorName = 'Datamodule';

dataModuleCodeInterf =
'/// <summary>                                                ' + #10#13 +
'/// Implementação para a interface:  I%FormIdent '+#10#13+
'/// </summary>                                                    '+#10#13+
'Unit %ModelIdent;                                                 '+#10#13+
'                                                                  '+#10#13+
'//%include                                                        '+#10#13+
'interface                                                         '+#10#13+
'                                                                  '+#10#13+
'uses System.SysUtils, System.Classes,'+#10#13+
'     MVCBr.Interf, MVCBr.Model,MVCBr.Controller,MVCBr.ModuleModel;'+#10#13+
'                                                                  '+#10#13+
'Type                                                              '+#10#13+
'                                                                  '+#10#13+
' /// Interaface para o ModuleModel                            ' + #10#13 +
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
'/// <summary>                                                ' + #10#13 +
'///    Implementação para o interface:  I%FormIdent '+#10#13+
'/// </summary>                                                    '+#10#13+
'Unit %ModelIdent;                                                 '+#10#13+
'                                                                  '+#10#13+
'//%include                                                        '+#10#13+
'interface                                                         '+#10#13+
'                                                                  '+#10#13+
'uses System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes,'+#10#13+
'     %ModelIdent.Interf, MVCBr.ModuleModel,                         '+#10#13+
'     MVCBr.Interf, MVCBr.Model, MVCBr.Controller;                 '+#10#13+
'                                                                  '+#10#13+
'Type                                                              '+#10#13+
'    // Class para implementar o I%FormIdent                  '+#10#13+
'    T%FormIdent = class(TModuleFactory ,I%FormIdent, IThisAs<T%FormIdent>)'+#10#13+
'    private                                                       '+#10#13+
'                                                                  '+#10#13+
'    protected                                                     '+#10#13+
'///  ThisAs retorna o Object Factory para a interface        ' + #10#13 +
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
'/// ThisAs retorna o Object Factory para a interface         ' + #10#13 +
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
'/// <summary>                                                     ' + #10#13 +
'///     New cria uma nova instância para o Object Factory         ' + #10#13 +
'/// </summary>                                                    ' + #10#13 +
'/// <param name="AController">                                    ' + #10#13 +
'///    AController é o controller ao qual o módulo esta associado ' + #10#13 +
'/// </param>                                                      ' + #10#13 +
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



