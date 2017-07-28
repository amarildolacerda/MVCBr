unit PDVSat.GravarStatus;

interface

implementation

uses Dialogs,PDVSat.Model, System.Rtti,   PDVSat.Comandos;


function GravarEstatus( AStatus:TValue ):boolean;
begin

    ShowMessage('chamou a gravação do estatus');
    result := false;

end;



procedure Registrar;
begin

    PDVDSatModelRegistrar( TPDVSatComandos.cmd_GravarEstatus ,  GravarEstatus   );

end;


initialization

    Registrar;

end.
