unit eMVC.IncludeCreator;

interface

uses
  Windows, SysUtils,
  eMVC.OTAUtilities,
  eMVC.FileCreator,
  ToolsApi,
  eMVC.BaseCreator;

type

  TIncludeCreator = class(TBaseCreator)
  private
    function GetImplFileName: string; override;

  public
    constructor Create(const APath: string = ''; ABaseName: string = '';
      AUnNamed: boolean = true); override;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string)
      : IOTAFile; override;
  end;

implementation

{ TIncludeCreator }

function TIncludeCreator.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
var
  fc: TFileCreator;
begin

  debug('TIncludeCreator.NewImplSource: ');
  fc := TFileCreator.new(ModuleIdent, FormIdent, AncestorIdent,
    function: string
    begin
      result := '// Defines para o MVCBr                          ' + #10#13 +
        '//  %date                                                ' + #10#13 +
        '{$define ';
      if IsFMX then
        result := result+ 'FMX}'
      else
        result := result+ 'VCL}';
      debug(result);
    end);
  result := fc;
end;

function TIncludeCreator.GetImplFileName: string;
begin
  result := self.getpath + 'inc\mvcbr.inc';
  debug('TIncludeCreator.GetImplFileName: ' + result);
  ForceDirectories( ExtractFilePath(Result)  );
end;

constructor TIncludeCreator.Create(const APath: string; ABaseName: string;
AUnNamed: boolean);
begin
  inherited;
  SetAncestorName('include');
end;

end.
