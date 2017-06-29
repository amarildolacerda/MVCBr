unit TestMVCBr.Facade;

interface

uses
  TestFramework, System.SysUtils, System.Generics.Collections, System.JSON,
  System.RTTI,
  System.TypInfo, System.Classes, MVCBr.Interf,
  MVCBr.Patterns.Facade;

type
  TestTMVCBrFacade = class(TTestCase)
  strict private
    FCont: integer;
    FMVCBrFacade: IMVCBrFacade;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    function GetItems: TMVCBrFacateFunc;
    procedure Add();
    procedure Remove;
    procedure Contains;
    function Count: integer;
    procedure Execute;
    procedure ForEach;
    procedure GetItem;

  end;

implementation

{ TestTMVCBrStates }

procedure TestTMVCBrFacade.Add();
var
  AProc: TMVCBrFacateFunc;
begin
  FMVCBrFacade.Add('TESTE',
    function(sender: TValue): boolean
    begin
      result := true
    end);
  checkTrue(FMVCBrFacade.Count > 0, 'Não adicionou o comando');
end;

procedure TestTMVCBrFacade.Contains;
var
  AProc: TMVCBrFacateFunc;
begin
  FMVCBrFacade.Add('TESTE',
    function(sender: TValue): boolean
    begin
      result := true
    end);
  checkTrue(FMVCBrFacade.Contains('TESTE'), 'Não encontrou o commando');
end;

function TestTMVCBrFacade.Count: integer;
begin

  FMVCBrFacade.Add('TESTE',
    function(sender: TValue): boolean
    begin
      result := true
    end);
  checkTrue(FMVCBrFacade.Count > 0, 'count não retornou o registro');

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

  checkTrue(FMVCBrFacade.Count = 3, 'count não retornou correto');

  FMVCBrFacade.Execute('TESTE1', nil);
  checkTrue(FCont = 2, 'não executou o comando(2)');

  FMVCBrFacade.Execute('TESTE2', nil);
  checkTrue(FCont = 5, 'não executou o comando (5)');

  FMVCBrFacade.Execute('TESTE2', 0);
  checkTrue(FCont > 1000, 'não executou o comando (>1000)');

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

  checkTrue(FMVCBrFacade.Count = 3, 'count não retornou correto');

  FMVCBrFacade.ForEach(0, nil);

  checkTrue(FCont = 1006, 'não executou o comando(1006)');

  FCont := 0;

  FMVCBrFacade.ForEach(0,
    function(cmd: string): boolean
    begin
       result := true;
    end);

  checkTrue(FCont = 1006, 'não executou o comando com function(1006)');
  FCont := 0;


  FMVCBrFacade.ForEach(0,
    function(cmd: string): boolean
    begin
       result := cmd.equals('TESTE1');
    end);

  checkTrue(FCont = 2, 'não executou o comando com function(2)');
  FCont := 0;


end;

procedure TestTMVCBrFacade.GetItem;
var
  AProc: TMVCBrFacateFunc;
begin
  checkTrue(FMVCBrFacade.GetItem('TESTE') = nil, 'não retornou nil');
  FMVCBrFacade.Add('TESTE2',
    function(sender: TValue): boolean
    begin
      result := true
    end);
  AProc := FMVCBrFacade.Items[0];
  checkTrue(assigned(AProc), 'Não retornou a function com Items[0]');
  AProc := FMVCBrFacade.GetItem('TESTE2');
  checkTrue(assigned(AProc), 'Não retornou a function com GetItem');
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
  checkTrue(assigned(AProc), 'Não retornou a function');
end;

procedure TestTMVCBrFacade.Remove;
begin
  FMVCBrFacade.Add('TESTE',
    function(sender: TValue): boolean
    begin
      result := true
    end);
  checkTrue(FMVCBrFacade.Count > 0, 'não adicionou item');
  FMVCBrFacade.Remove('TESTE');
  checkTrue(FMVCBrFacade.Count = 0, 'não removeu item');
end;

procedure TestTMVCBrFacade.SetUp;
begin
  inherited;
  FMVCBrFacade := TMVCBrFacade.new;
end;

procedure TestTMVCBrFacade.TearDown;
begin
  inherited;
  FMVCBrFacade := nil;
end;

initialization

RegisterTest(TestTMVCBrFacade.Suite);

end.
