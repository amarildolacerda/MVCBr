ClassHeader=
'{//************************************************************//}'+ #13#10 +
'{//                                                            //}'+ #13#10 +
'{//         Código gerado pelo assistente                      //}'+ #13#10 +
'{//                                                            //}'+ #13#10 +
'{//         Projeto MVCBr                                      //}'+ #13#10 +
'{//         tireideletra.com.br  / amarildo lacerda            //}'+ #13#10 +
'{//************************************************************//}'+ #13#10 +
'{// Data: %date                                  //}'+ #13#10 +
'{//************************************************************//}';

ClassCode = 'unit %UnitIdent;                                 ' + #13#10 +
  '                                                    ' + #13#10 +
  ' ///                                                ' + #13#10 +
  ' /// <summary>                                            ' + #13#10 +
  ' ///    O Model recebe as regras de negócios        ' + #13#10 +
  ' ///    do sistema.                                 ' + #13#10 +
  ' /// </ummary>                                            ' + #13#10 +
  ' ///                                                ' + #13#10 +
  'interface                                                 ' + #13#10 +
  'uses                                                      ' + #13#10 +
  '  System.SysUtils,{$ifdef FMX} FMX.Forms,{$else} VCL.Forms,{$endif} System.Classes,' + #13#10 +
  '  MVCBr.Interf, MVCBr.View;    ' + #13#10 +
  '                                                          ' + #13#10 +
  'type                                                      ' + #13#10 +
  '  T%FormIdent = class(T%AncestorIdent       )             ' + #13#10 +
  '  private                                                 ' + #13#10 +
  '    { Private declarations }                              ' + #13#10 +
  '  public                                                  ' + #13#10 +
  '    { Public declarations }                               ' + #13#10 +
  '  end;                                                    ' + #13#10 +
  '                                                          ' + #13#10 +
  '                                                          ' + #13#10 +
  '  TView%FormIdent = class(TViewFactory)                   ' + #13#10 +
  '    protected                                             ' + #13#10 +
  '                                                          ' + #13#10 +
  '    public                                                ' + #13#10 +
  '                                                          ' + #13#10 +
  '  end;                                                    ' + #13#10 +
  '                                                          ' + #13#10 +
  'var                                                       ' + #13#10 +
  '  %FormIdent: T%FormIdent;                                ' + #13#10 +
  '                                                          ' + #13#10 +
  'implementation                                            ' + #13#10 +
  '                                                          ' + #13#10 +
  '{$R *.dfm}                                                ' + #13#10 +
  '                                                          ' + #13#10 +
  'end.                                                      ' + #13#10;
