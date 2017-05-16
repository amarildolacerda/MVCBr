unit MVCBr.FMX.DataModuleDummy;

interface

uses
  FMX.Forms, System.SysUtils, System.Classes;

type
  TDataModuleDummy = class({$IFDEF BPL} TDataModule {$ELSE} TForm{$ENDIF})
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModuleDummy: TDataModuleDummy;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.FMX}

end.
