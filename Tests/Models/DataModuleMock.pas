unit DataModuleMock;

interface

uses
  System.SysUtils, System.Classes;

type
  TDataModuleMockTester = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    counter: integer;
  end;

var
  DataModuleMockTester: TDataModuleMockTester;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDataModuleMockTester.DataModuleCreate(Sender: TObject);
begin
  // teste
  inc(counter);
end;

procedure TDataModuleMockTester.DataModuleDestroy(Sender: TObject);
begin
  dec(counter);
end;

end.
