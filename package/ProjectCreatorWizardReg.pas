unit ProjectCreatorWizardReg;

//
//  Registers the TProjectCreatorWizard with the IDE when the package is
// installed.
//

interface

uses
  SysUtils, Windows, Controls, ProjectCreatorWizard, ToolsApi;


//procedure Register;

implementation

procedure Register;
begin
  RegisterPackageWizard(TProjectCreatorWizard.Create);
end;

end.

