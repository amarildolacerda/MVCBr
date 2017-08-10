unit TestMVCBr.Patterns.Mediator;

interface

uses
  TestFramework, System.SysUtils, System.Generics.Collections, System.JSON,
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

  TestTMVCBrMediator = class(TTestCase)
  private
    FMeditor: IMVCBrChatRoom;
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCriarMeditor;
    procedure TestCriarParticipant;
    procedure testAddParticipant;
    procedure testRemoveParticipant;
    procedure TestSendAll;
    procedure TestSendToFirst;
    procedure TestAddMiddleware;
    procedure TestBeforeEventMiddleware;
    procedure TestAfterEventMiddleware;
  end;

implementation

uses MVCBr.MiddlewareFactory;

{ TestTMVCBrMediator }

procedure TestTMVCBrMediator.SetUp;
begin
  inherited;
  FMeditor := TMVCBrChatRoom.New(TChatParticipants);
  FMeditor.Title := 'Developers';

end;

procedure TestTMVCBrMediator.TearDown;
begin
  FMeditor := nil;
  TMVCBrMiddlewareFactory.Default.Clear;
  inherited;
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
  checkTrue(o.ClassName = TChatParticipants.ClassName);
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


  RegisterViewMiddleware(mdd);
  TMVCBrMiddlewareFactory.Add(TMVCBrMiddleware.Create);

  TMVCBrMiddlewareFactory.SendAfterEvent(middView,nil);
  checkTrue(rsp='ok');

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


  RegisterViewMiddleware(mdd);
  TMVCBrMiddlewareFactory.Add(TMVCBrMiddleware.Create);

  TMVCBrMiddlewareFactory.SendBeforeEvent(middView,nil);
  checkTrue(rsp='ok');

end;

procedure TestTMVCBrMediator.TestCriarMeditor;
var
  mdt: IMVCBrMediator<TChatParticipants>;
begin
  mdt := TMVCBrMediator<TChatParticipants>.Create(TChatParticipants);
  checkNotNull(mdt, 'não iniciou o mediator');
end;

procedure TestTMVCBrMediator.testRemoveParticipant;
begin
  FMeditor.Add;
  checkTrue(FMeditor.count = 1);
  FMeditor.Remove(0);
  checkTrue(FMeditor.count = 0);
end;

procedure TestTMVCBrMediator.TestSendAll;
var
  it: TChatParticipants;
begin
  it := FMeditor.Add as TChatParticipants;
  FMeditor.Add;
  FMeditor.SendAll('teste');
  checkTrue(it.FMsg.Equals('teste'));
end;

procedure TestTMVCBrMediator.TestSendToFirst;
var
  it: TChatParticipants;
begin
  it := FMeditor.Add as TChatParticipants;
  FMeditor.Add;
  FMeditor.Send(it.ID, 'teste');

  checkTrue(it.FMsg.Equals('teste'));
  checkTrue((FMeditor.items[1] as TChatParticipants).FMsg.Equals(''));

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

RegisterTest(TestTMVCBrMediator.Suite);

end.
