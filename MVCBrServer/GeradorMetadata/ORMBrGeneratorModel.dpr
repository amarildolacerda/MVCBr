program ORMBrGeneratorModel;



uses
  Forms,
  Frm_Principal in 'Frm_Principal.pas' {FrmPrincipal},
  Frm_Connection in 'Frm_Connection.pas' {FrmConnection};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
