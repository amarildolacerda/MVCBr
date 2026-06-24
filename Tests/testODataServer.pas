unit testODataServer;

interface

uses
  TestFramework;

type
  TestTODataServer = class(TTestCase)
  published
    procedure TestDummy;
  end;

implementation

procedure TestTODataServer.TestDummy;
begin
  CheckTrue(True);
end;

initialization
  RegisterTest(TestTODataServer.Suite);

end.
