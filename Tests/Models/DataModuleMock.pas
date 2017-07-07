unit DataModuleMock;

interface

uses
  System.SysUtils, System.Classes;

type
  TDataModuleMock = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModuleMock;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
