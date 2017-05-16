unit MVCBr.VCL.DataModuleDummy;

interface

uses
  System.SysUtils, System.Classes;

type
  TDataModuleDummy = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModuleDummy: TDataModuleDummy;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
