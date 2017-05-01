unit eMVC.ProjectCreator;
// This is done to Warnings that I can't control, as Embarcadero has
// deprecated the functions, but due to design you are still required to
// to implement.
{$WARN SYMBOL_DEPRECATED OFF}

interface

uses
  PlatformAPI,
  eMVC.FileCreator,
  ToolsAPI;

type
  TNewProject = class abstract(TNotifierObject, IOTACreator, IOTAProjectCreator,
    IOTAProjectCreator80)
  protected
    // IOTACreator
    function GetCreatorType: string; virtual;
    function GetExisting: Boolean;
    function GetFileSystem: string;
    function GetOwner: IOTAModule;
    function GetUnnamed: Boolean;
    // IOTAProjectCreator
    function GetFileName: string;
    function GetOptionFileName: string; deprecated;
    function GetShowSource: Boolean;
    procedure NewDefaultModule; deprecated;
    function NewOptionSource(const ProjectName: string): IOTAFile; deprecated;
    procedure NewProjectResource(const Project: IOTAProject);
    function NewProjectSource(const ProjectName: string): IOTAFile; virtual;
      abstract; // MUST OVERRIDE!
    // IOTAProjectCreator80
    function GetProjectPersonality: string; virtual;
    procedure NewDefaultProjectModule(const Project: IOTAProject);
  private
    procedure SetFileName(const Value: String);
  protected
    FFileName: String;
  public
    property FileName: String read GetFileName write SetFileName;
  end;

  TNewProjectEx = class(TNewProject, IOTAProjectCreator160)
  private
    FPersonality: string;
    FBaseProjectType: TBaseProjectType;

    procedure SetBaseProjectType(const Value: TBaseProjectType);
  protected
    function GetProjectPersonality: string; override;

    // IOTAProjectCreator160
    function GetPlatforms: TArray<string>;
    function GetFrameworkType: string; virtual;
    function GetPreferredPlatform: string;
    procedure SetInitialOptions(const NewProject: IOTAProject);
  public
    property Personality: string read FPersonality write FPersonality;
    property BaseProjectType: TBaseProjectType read FBaseProjectType
      write SetBaseProjectType;
  end;

  TProjectCreator = class(TNewProjectEx)
  private
  protected
    function NewProjectSource(const ProjectName: string): IOTAFile; override;
    function GetFrameworkType: string; override;
  public
    constructor Create; overload;
    constructor Create(const APersonality: string); overload;
  end;

implementation

uses
  eMVC.ProjectFileCreator, System.SysUtils;

{ TNewProject }

function TNewProject.GetCreatorType: string;
begin
  Result := sApplication;
  // May want to change this in the future, at least making method virtual
end;

function TNewProject.GetExisting: Boolean;
begin
  Result := False;
end;

function TNewProject.GetFileName: string;
begin
  Result := FFileName;
end;

function TNewProject.GetFileSystem: string;
begin
  Result := '';
end;

function TNewProject.GetOptionFileName: string;
begin
  Result := '';
end;

function TNewProject.GetOwner: IOTAModule;
begin
  Result := (BorlandIDEServices as IOTAModuleServices).MainProjectGroup;
end;

function TNewProject.GetProjectPersonality: string;
begin
  Result := sDelphiPersonality;
end;

function TNewProject.GetShowSource: Boolean;
begin
  Result := False;
end;

function TNewProject.GetUnnamed: Boolean;
begin
  Result := True;
end;

procedure TNewProject.NewDefaultModule;
begin
end;

procedure TNewProject.NewDefaultProjectModule(const Project: IOTAProject);
begin
end;

function TNewProject.NewOptionSource(const ProjectName: string): IOTAFile;
begin
  Result := nil;
end;

procedure TNewProject.NewProjectResource(const Project: IOTAProject);
begin
end;

procedure TNewProject.SetFileName(const Value: String);
begin
  FFileName := Value;
end;

function TNewProjectEx.GetFrameworkType: string;
begin
  case BaseProjectType of
    bptVCL:
      Result := sFrameworkTypeVCL;
    bptFMX:
      Result := sFrameworkTypeFMX;
    bptPrompt:
      Result := sFrameworkTypeVCL;
  end;
end;

function TNewProjectEx.GetPlatforms: TArray<string>;
begin
  Result := TArray<string>.Create(cWin32Platform, cWin64Platform,
    cAndroidPlatform, cOSX32Platform, cWinIoT32Platform, cLinux64Platform,
    ciOSDevicePlatform, cWinARMPlatform);
end;

function TNewProjectEx.GetPreferredPlatform: string;
begin
  Result := cWin32Platform;
end;

function TNewProjectEx.GetProjectPersonality: string;
begin
  Result := sDelphiPersonality
end;

procedure TNewProjectEx.SetBaseProjectType(const Value: TBaseProjectType);
begin
  FBaseProjectType := Value;
end;

procedure TNewProjectEx.SetInitialOptions(const NewProject: IOTAProject);
var
  LBuildConf: IOTAProjectOptionsConfigurations;
begin
  if Supports(NewProject.ProjectOptions, IOTAProjectOptionsConfigurations,
    LBuildConf) then
  begin
    LBuildConf.BaseConfiguration.AsBoolean['UsingDelphiRTL'] := True;
  end;

end;


constructor TProjectCreator.Create;
begin
  // TODO: Figure out how to make this be DMVCProjectX where X is the next available.
  // Return Blank and the project will be 'ProjectX.dpr' where X is the next available number
  FFileName := '';
  FPersonality := sDelphiPersonality;
end;

constructor TProjectCreator.Create(const APersonality: string);
begin
  Create;
  Personality := APersonality;
end;

function TProjectCreator.GetFrameworkType: string;
begin
  Result := 'VCL';
  if BaseProjectType=bptFMX then
    Result := 'FMX';
end;

function TProjectCreator.NewProjectSource(const ProjectName: string): IOTAFile;
var
  fc: TProjectFileCreator;
begin
  fc := TProjectFileCreator.Create(ProjectName);
  fc.BaseProjectType := self.BaseProjectType;
  Result := fc;
end;

end.
