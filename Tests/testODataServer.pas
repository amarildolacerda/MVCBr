unit testODataServer;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TestTODataServer = class
  public
    [Test]
    procedure TestDummy;
  end;

implementation

procedure TestTODataServer.TestDummy;
begin
  Assert.IsTrue(True);
end;

end.
