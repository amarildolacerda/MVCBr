unit MVCBr.DataModuleDummy;

interface

uses
  {$ifdef FMX}FMX.Forms,{$else}VCL.Forms,{$endif} System.SysUtils, System.Classes;

type
  TDataModuleDummy = class({$ifdef BPL} TDataModule {$else} TForm{$endif})
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModuleDummy: TDataModuleDummy;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
