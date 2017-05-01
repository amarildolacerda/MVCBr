unit eMVC.DatasetModel;

interface

uses
  ToolsAPI, eMVC.FileCreator, eMVC.OTAUtilities, eMVC.ModelCreator;

type
  TDatasetModel = class(TModelCreator)
  private
    function GetImplFileName: string; override;
  public

    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string)
      : IOTAFile; override;

  end;

implementation

{ TDatasetModel }
const
   CR = #13;
{$I .\inc\DatasetModel.Inc}

function TDatasetModel.GetImplFileName: string;
begin
  result := self.getpath + getBaseName + '.DatasetModel.pas';
  if isInterf then
    result := self.getpath + getBaseName + '.DatasetModel.Interf.pas';
  debug('TDatasetModel.GetImplFileName: ' + result);

end;

function TDatasetModel.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
var
  fc: TFileCreator;
begin

  debug('TDatasetModel.NewImplSource: ');
  if isInterf then
    fc := TFileCreator.New(ModuleIdent, FormIdent, AncestorIdent,
      function: string
      begin
        result := DatasetModelIntef ;
      end)
  else
    fc := TFileCreator.New(ModuleIdent, FormIdent, AncestorIdent,
      function: string
      begin
        result := DatasetModel;
      end);

  fc.Templates.assign(Templates);
  fc.Templates.Values['%MdlInterf'] := getBaseName + '.DatasetModel.Interf';

  result := fc;
end;

end.
