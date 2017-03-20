ProjectCode = 'PROGRAM %ModuleIdent;                         ' + #13#10 +
  '                                                          ' + #13#10 +
  '// Código gerado pelo Assistente MVCBr OTA                ' + #13#10 +
  '// www.tireideletra.com.br                                ' + #13#10 +
  '// Amarildo Lacerda & Grupo MVCBr-2017                    ' + #13#10 +
  'uses                                                      ' + #13#10 +
  '  Forms, MVCBr.ApplicationController, MVCBr.Controller;   ' + #13#10 +
  '                                                          ' + #13#10 +
  '{$R *.res}                                                ' + #13#10 +
  'begin                                                     ' + #13#10 +
'/// Inicializa o Controller e Roda o MainForm                     ' + #13#10 +
  '  ApplicationController.Run(T%ModuleIdentController.New,' + #13#10 +
  '    function :boolean                                     ' + #13#10 +
  '    begin                                                 ' + #13#10 +
  '      // retornar True se o applicatio pode ser carregado ' + #13#10 +
  '      //          False se não foi autorizado inicialização' + #13#10 +
  '      result := true;                                     ' + #13#10 +
  '    end);                                                 ' + #13#10 +
  'end.                                                      ' + #13#10;

ProjectCodeFMX = 'PROGRAM %ModuleIdent;                         ' + #13#10 +
  '                                                          ' + #13#10 +
  '// Código gerado pelo Assistente MVCBr OTA                ' + #13#10 +
  '// www.tireideletra.com.br                                ' + #13#10 +
  '// Amarildo Lacerda & Grupo MVCBr-2017                    ' + #13#10 +
  'uses                                                      ' + #13#10 +
  '  System.StartUpCopy,                                     ' + #13#10 +
  '  FMX.Forms, MVCBr.ApplicationController, MVCBr.Controller;' + #13#10 +
  '                                                          ' + #13#10 +
  '{$R *.res}                                                ' + #13#10 +
  'begin                                                     ' + #13#10 +
  '  ApplicationController.Run(T%ModuleIdentController.New,' + #13#10 +
  '    function :boolean                                     ' + #13#10 +
  '    begin                                                 ' + #13#10 +
  '      // retornar True se o applicatio pode ser carregado ' + #13#10 +
  '      //          False se não foi autorizado inicialização' + #13#10 +
  '      result := true;                                     ' + #13#10 +
  '    end);                                                 ' + #13#10 +
  'end.                                                      ' + #13#10;

