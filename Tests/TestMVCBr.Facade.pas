unit TestMVCBr.Facade;

interface

uses
  DUnitX.TestFramework, System.SysUtils, System.Generics.Collections, System.JSON,
  System.RTTI,
  System.TypInfo, System.Classes, MVCBr.Interf,
  MVCBr.Patterns.Facade;

type
  [TestFixture]
  TestTMVCBrFacade = class
  private
    FCont: integer;
    FMVCBrFacade: IMVCBrFacade;
  public
    [Setup]
    procedure SetUp;

    [TearDown]
    procedure TearDown;

    [Test]
    function GetItems: TMVCBrFacateFunc;

    [Test]
    procedure Add();

    [Test]
    procedure Remove;

    [Test]
    procedure Contains;

    [Test]
    function Count: integer;

    [Test]
    procedure Execute;

    [Test]
    procedure ForEach;

    [Test]
    procedure GetItem;
  end;

implementation

{ TestTMVCBrFacade }

procedure TestTMVCBrFacade.Add();
begin
  FMVCBrFacade.Add('TESTE',
    function(sender: TValue): boolean
    begin
      result := true
    end);
  Assert.IsTrue(FMVCBrFacade.Count > 0, 'Não adicionou o comando');
end;

procedure TestTMVCBrFacade.Contains;
begin
  FMVCBrFacade.Add('TESTE',
    function(sender: TValue): boolean
    begin
      result := true
    end);
  Assert.IsTrue(FMVCBrFacade.Contains('TESTE'), 'Não encontrou o commando');
end;

function TestTMVCBrFacade.Count: integer;
begin
  FMVCBrFacade.Add('TESTE',
    function(sender: TValue): boolean
    begin
      result := true
    end);
  Assert.IsTrue(FMVCBrFacade.Count > 0, 'count não retornou o registro');
end;

procedure TestTMVCBrFacade.Execute;
begin
  FCont := 0;
  FMVCBrFacade.Add('TESTE',
    function(sender: TValue): boolean
    begin
      inc(FCont);
    end);
  FMVCBrFacade.Add('TESTE1',
    function(sender: TValue): boolean
    begin
      inc(FCont);
      inc(FCont);
    end);
  FMVCBrFacade.Add('TESTE2',
    function(sender: TValue): boolean
    begin
      inc(FCont);
      inc(FCont);
      inc(FCont);
      if not sender.IsEmpty then
        FCont := FCont + 1000;
    end);

  Assert.IsTrue(FMVCBrFacade.Count = 3, 'count não retornou correto');

  FMVCBrFacade.Execute('TESTE1', nil);
  Assert.IsTrue(FCont = 2, 'não executou o comando(2)');

  FMVCBrFacade.Execute('TESTE2', nil);
  Assert.IsTrue(FCont = 5, 'não executou o comando (5)');

  FMVCBrFacade.Execute('TESTE2', 0);
  Assert.IsTrue(FCont > 1000, 'não executou o comando (>1000)');
end;

procedure TestTMVCBrFacade.ForEach;
begin
  FCont := 0;
  FMVCBrFacade.Add('TESTE',
    function(sender: TValue): boolean
    begin
      inc(FCont);
      result := false;
    end);
  FMVCBrFacade.Add('TESTE1',
    function(sender: TValue): boolean
    begin
      inc(FCont);
      inc(FCont);
      result := false;
    end);
  FMVCBrFacade.Add('TESTE2',
    function(sender: TValue): boolean
    begin
      inc(FCont);
      inc(FCont);
      inc(FCont);
      if not sender.IsEmpty then
        FCont := FCont + 1000;
      result := false;
    end);

  Assert.IsTrue(FMVCBrFacade.Count = 3, 'count não retornou correto');

  FMVCBrFacade.ForEach(0, nil);

  Assert.IsTrue(FCont = 1006, 'não executou o comando(1006)');

  FCont := 0;

  FMVCBrFacade.ForEach(0,
    function(cmd: TValue): boolean
    begin
       result := true;
    end);

  Assert.IsTrue(FCont = 1006, 'não executou o comando com function(1006)');
  FCont := 0;

  FMVCBrFacade.ForEach(0,
    function(cmd: TValue): boolean
    begin
       result := cmd.AsString.equals('TESTE1');
    end);

  Assert.IsTrue(FCont = 2, 'não executou o comando com function(2)');
  FCont := 0;
end;

procedure TestTMVCBrFacade.GetItem;
var
  AProc: TMVCBrFacateFunc;
begin
  Assert.IsTrue(FMVCBrFacade.GetItem('TESTE') = nil, 'não retornou nil');
  FMVCBrFacade.Add('TESTE2',
    function(sender: TValue): boolean
    begin
      result := true
    end);
  AProc := FMVCBrFacade.Items[0];
  Assert.IsTrue(assigned(AProc), 'Não retornou a function com Items[0]');
  AProc := FMVCBrFacade.GetItem('TESTE2');
  Assert.IsTrue(assigned(AProc), 'Não retornou a function com GetItem');
end;

function TestTMVCBrFacade.GetItems: TMVCBrFacateFunc;
var
  AProc: TMVCBrFacateFunc;
begin
  FMVCBrFacade.Add('TESTE',
    function(sender: TValue): boolean
    begin
      result := true
    end);
  AProc := FMVCBrFacade.Items[0];
  Assert.IsTrue(assigned(AProc), 'Não retornou a function');
end;

procedure TestTMVCBrFacade.Remove;
begin
  FMVCBrFacade.Add('TESTE',
    function(sender: TValue): boolean
    begin
      result := true
    end);
  Assert.IsTrue(FMVCBrFacade.Count > 0, 'não adicionou item');
  FMVCBrFacade.Remove('TESTE');
  Assert.IsTrue(FMVCBrFacade.Count = 0, 'não removeu item');
end;

procedure TestTMVCBrFacade.SetUp;
begin
  FMVCBrFacade := TMVCBrFacade.new;
end;

procedure TestTMVCBrFacade.TearDown;
begin
  FMVCBrFacade := nil;
end;

end.
