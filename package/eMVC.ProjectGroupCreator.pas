unit eMVC.ProjectGroupCreator;

interface

uses ToolsAPI, eMVC.BaseCreator, eMVC.OTAUtilities;

type

  TBDSProjectGroupCreator = class(TBaseCreator, IOTAProjectGroupCreator)
  private
    FPath: string;
    procedure SetPath(const Value: string);
  public
    function GetFileName: string;
    { Return True to show the source }
    function GetShowSource: Boolean;
    { Deprecated/never called.  Create and return the project group source }
    function NewProjectGroupSource(const ProjectGroupName: string): IOTAFile;
      deprecated;

    property FileName: string read GetFileName;
    property ShowSource: Boolean read GetShowSource;

    function GetCreatorType: string; override;
    function GetExisting: Boolean; override;
    function GetOwner: IOTAModule; override;

    property Path: string read FPath write SetPath;
  end;

implementation

{ TBDSProjectGroupCreator }

function TBDSProjectGroupCreator.GetCreatorType: string;
begin
  Result := sPackage;
  //result := '';
end;

function TBDSProjectGroupCreator.GetExisting: Boolean;
begin
  result := true;
end;

function TBDSProjectGroupCreator.GetFileName: string;
begin
  result := FPath + 'MVCBrProject.bpg';
  debug(Result);
end;

function TBDSProjectGroupCreator.GetOwner: IOTAModule;
begin
  result := nil;
end;

function TBDSProjectGroupCreator.GetShowSource: Boolean;
begin
  result := true;
end;

function TBDSProjectGroupCreator.NewProjectGroupSource(const ProjectGroupName
  : string): IOTAFile;
begin
  result := nil;
  debug('TBDSProjectGroupCreator.NewProjectGroupSource');
end;

procedure TBDSProjectGroupCreator.SetPath(const Value: string);
begin
  FPath := Value;
end;

end.
