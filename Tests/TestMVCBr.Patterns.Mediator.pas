unit TestMVCBr.Patterns.Mediator;

interface

uses
  DUnitX.TestFramework, System.SysUtils, System.Generics.Collections, System.JSON,
  System.RTTI, Forms,
  System.TypInfo, System.Classes,
  MVCBr.Patterns.Mediator,
  MVCBr.Interf, MVCBr.Patterns.Prototype;

type

  TChatParticipants = class(TMVCBrParticipant)
  private
    FMsg: string;
  public
    procedure Receive(msg: TValue); Override;
  end;

  IMVCBrChatRoom = interface(IMVCBrMediator<TChatParticipants>)
    ['{BD8F53C7-8E00-4E7F-A999-B0DFB78F1325}']
    procedure SetTitle(const Value: string);
    function GetTitle: string;
    property Title: string read GetTitle write SetTitle;

  end;

  TMVCBrChatRoom = class(TMVCBrMediator<TChatParticipants>, IMVCBrChatRoom)
  private
    FTitle: string;
    procedure SetTitle(const Value: string);
    function GetTitle: string;
  public
    class function New(AClass: TMVCBrParticipantClass): IMVCBrChatRoom;
    property Title: string read GetTitle write SetTitle;
  end;

  TestTMVCBrMediator = class
  private
    FMeditor: IMVCBrChatRoom;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestCriarMeditor;
    [Test]
    procedure TestCriarParticipant;
    procedure testAddParticipant;
    procedure testRemoveParticipant;
    [Test]
    procedure TestSendAll;
    [Test]
    procedure TestSendToFirst;
    [Test]
    procedure TestAddMiddleware;
    [Test]
    procedure TestBeforeEventMiddleware;
    [Test]
    procedure TestAfterEventMiddleware;
  end;

implementation

uses MVCBr.MiddlewareFactory;

{ TestTMVCBrMediator }

procedure TestTMVCBrMediator.SetUp;
begin
  FMeditor := TMVCBrChatRoom.New(TChatParticipants);
  FMeditor.Title := 'Developers';

end;

procedure TestTMVCBrMediator.TearDown;
begin
  FMeditor := nil;
  TMVCBrMiddlewareFactory.Default.Clear;
end;

procedure TestTMVCBrMediator.TestAddMiddleware;
begin
  TMVCBrMiddlewareFactory.Add(TMVCBrMiddleware.Create);
end;

procedure TestTMVCBrMediator.testAddParticipant;
var
  o: TMVCBrParticipant;
begin
  o := FMeditor.Add;
  Assert.IsTrue(o.ClassName = TChatParticipants.ClassName);
end;

procedure TestTMVCBrMediator.TestCriarParticipant;
begin
  FMeditor.Add(TChatParticipants.Create);

end;

procedure TestTMVCBrMediator.TestAfterEventMiddleware;
var
  mdd: TMVCBrMiddleware;
  rsp:String;
begin

  mdd := TMVCBrMiddleware.Create;
  mdd.OnAfterEvent := procedure(sender: TObject)
    begin
       rsp := 'ok';
    end;


  MVCBrRegisterMiddleware(TMVCBrMiddlewareType.middView, mdd);
  TMVCBrMiddlewareFactory.Add(TMVCBrMiddleware.Create);

  TMVCBrMiddlewareFactory.SendAfterEvent(middView,nil);
  Assert.IsTrue(rsp='ok');

end;

procedure TestTMVCBrMediator.TestBeforeEventMiddleware;
var
  mdd: TMVCBrMiddleware;
  rsp:String;
begin

  mdd := TMVCBrMiddleware.Create;
  mdd.OnBeforeEvent := procedure(sender: TObject)
    begin
       rsp := 'ok';
    end;


  MVCBrRegisterMiddleware(TMVCBrMiddlewareType.middView, mdd);
  TMVCBrMiddlewareFactory.Add(TMVCBrMiddleware.Create);

  TMVCBrMiddlewareFactory.SendBeforeEvent(middView,nil);
  Assert.IsTrue(rsp='ok');

end;

procedure TestTMVCBrMediator.TestCriarMeditor;
var
  mdt: IMVCBrMediator<TChatParticipants>;
begin
  mdt := TMVCBrMediator<TChatParticipants>.Create(TChatParticipants);
  Assert.IsNotNull(mdt, 'n�o iniciou o mediator');
end;

procedure TestTMVCBrMediator.testRemoveParticipant;
begin
  FMeditor.Add;
  Assert.IsTrue(FMeditor.count = 1);
  FMeditor.Remove(0);
  Assert.IsTrue(FMeditor.count = 0);
end;

procedure TestTMVCBrMediator.TestSendAll;
var
  it: TChatParticipants;
begin
  it := FMeditor.Add as TChatParticipants;
  FMeditor.Add;
  FMeditor.SendAll('teste');
  Assert.IsTrue(it.FMsg.Equals('teste'));
end;

procedure TestTMVCBrMediator.TestSendToFirst;
var
  it: TChatParticipants;
begin
  it := FMeditor.Add as TChatParticipants;
  FMeditor.Add;
  FMeditor.Send(it.ID, 'teste');

  Assert.IsTrue(it.FMsg.Equals('teste'));
  Assert.IsTrue((FMeditor.items[1] as TChatParticipants).FMsg.Equals(''));

end;

{ TMVCBrChatRoom }

function TMVCBrChatRoom.GetTitle: string;
begin
  result := FTitle;
end;

class function TMVCBrChatRoom.New(AClass: TMVCBrParticipantClass)
  : IMVCBrChatRoom;
begin
  result := inherited Create(AClass);
end;

procedure TMVCBrChatRoom.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

{ TChatParticipants }

procedure TChatParticipants.Receive(msg: TValue);
begin
  FMsg := msg.AsString;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTMVCBrMediator);
end.
