unit TestMVCBr.Patterns.Prototype;

interface

uses
  DUnitX.TestFramework, System.SysUtils, System.Generics.Collections, System.JSON,
  System.RTTI, Forms,
  System.TypInfo, System.Classes,
  MVCBr.Interf, MVCBr.Patterns.Prototype;

type

  [TestFixture]
  TPrototypeObjectTest = class
  private
    privateValue: integer;
    FPublicProperty: string;
    FPublishedProperty: TDatetime;
    FDateProp: TDatetime;
    FDoubleProp: Double;
    FBooleanProp: Boolean;
    procedure SetpublicProperty(const Value: string);
    procedure SetpublishedProperty(const Value: TDatetime);
    procedure SetbooleanProp(const Value: Boolean);
    procedure SetdateProp(const Value: TDatetime);
    procedure SetdoubleProp(const Value: Double);
  public
    ValorString : string;
    ValorInteger: integer;
    ValorDouble: Double;
    ValorDate: TDatetime;
    ValorBoolean: Boolean;
    property StringProp: string read FPublicProperty write SetpublicProperty;
    property DoubleProp: Double read FDoubleProp write SetdoubleProp;
    property BooleanProp: Boolean read FBooleanProp write SetbooleanProp;
    property DateProp: TDatetime read FDateProp write SetdateProp;
  public
    property DatePProp: TDatetime read FPublishedProperty
      write SetpublishedProperty;
  end;

  TPrototypeComponent = class(TComponent)
  public
    Valor: integer;
  end;

  TestTMVCBrPrototype = class
  private
    LSource, LTarget: TPrototypeObjectTest;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure TestNew;
    [Test]
    procedure TestCloneObject;
    [Test]
    procedure TestCopyObject;
    [Test]
    procedure TestCloneTComponent;
    [Test]
    procedure TestValorDouble;
    [Test]
    procedure TestValorBoolean;
    [Test]
    procedure TestValorDate;
    [Test]
    procedure TestValorString;
    [Test]
    procedure TestStringProp;
    [Test]
    procedure TestBooleanProp;
    [Test]
    procedure TestDoubleProp;
    [Test]
    procedure TestDateProp;
  end;

implementation

{ TestTMVCBrPrototype }

procedure TestTMVCBrPrototype.SetUp;
begin
  LSource := TPrototypeObjectTest.create;
end;

procedure TestTMVCBrPrototype.TearDown;
begin
  LSource.free;
  if assigned(LTarget) then
    LTarget.free;
end;

procedure TestTMVCBrPrototype.TestBooleanProp;
begin
  LSource.BooleanProp := true;
  LTarget := TMVCBrPrototype.Clone(LSource);
  Assert.IsTrue(LTarget.BooleanProp=true, 'N�o Atribuiu Boolean');
end;

procedure TestTMVCBrPrototype.TestCloneObject;
begin
  LSource.ValorInteger := 10;
  LSource.privateValue := 5;
  LTarget := TMVCBrPrototype.clone(LSource);
  Assert.IsTrue(LTarget.ValorInteger = 10, 'N�o executou o clone');
  Assert.IsTrue(LTarget.privateValue = 0, 'atribuiu valor a uma variavel private');
end;

procedure TestTMVCBrPrototype.TestCloneTComponent;
var
  ASource, ATarget: TPrototypeComponent;
begin
  TThread.NameThreadForDebugging('close');
  ASource := TPrototypeComponent.create(nil);
  try
    ASource.Valor := 11;
    ATarget := TMVCBrPrototype.clone(ASource);
    Assert.IsTrue(ATarget.Valor=11,'N�o copiou o valor');
  finally
    ASource.free;
    ATarget.free;
  end;
end;

procedure TestTMVCBrPrototype.TestCopyObject;
begin
  LSource.ValorDate := date;
  LTarget := TPrototypeObjectTest.create;
  TMVCBrPrototype.Copy(LSource, LTarget);
  Assert.IsTrue(LTarget.ValorDate = date, 'N�o copiou ValorDate');
end;


procedure TestTMVCBrPrototype.TestDateProp;
begin
  LSource.DateProp:= date;
  LTarget := TMVCBrPrototype.clone(LSource);
  Assert.IsTrue(LTarget.DateProp = date,'Nao atribuiu propriedade');
end;

procedure TestTMVCBrPrototype.TestDoubleProp;
begin
  LSource.DoubleProp:= 10;
  LTarget := TMVCBrPrototype.clone(LSource);
  Assert.IsTrue(LTarget.DoubleProp = 10,'Nao atribuiu propriedade');

end;

procedure TestTMVCBrPrototype.TestNew;
begin
   LTarget := TMVCBrPrototype.new<TPrototypeObjectTest>;
   LTarget.ValorString := 'X';
   Assert.IsNotNull(LTarget,'N�o incializou');
   Assert.AreEqual('X',LTarget.ValorString,'n�o atribuiu a string');
end;

procedure TestTMVCBrPrototype.TestStringProp;
begin
  LSource.StringProp := 'true';
  LTarget := TMVCBrPrototype.Clone(LSource);
  Assert.IsTrue(LTarget.StringProp='true', 'N�o Atribuiu Boolean');

end;

procedure TestTMVCBrPrototype.TestValorBoolean;
begin
   LSource.ValorBoolean := true;
   LTarget := TMVCBrPrototype.Clone(LSource);
   Assert.IsTrue(LTarget.ValorBoolean=LSource.ValorBoolean,'N�o copiou o valor');

end;

procedure TestTMVCBrPrototype.TestValorDate;
begin
   LSource.ValorDate := date;
   LTarget := TMVCBrPrototype.Clone(LSource);
   Assert.IsTrue(LTarget.ValorDate=LSource.ValorDate,'N�o copiou o valor');

end;

procedure TestTMVCBrPrototype.TestValorDouble;
begin
   LSource.ValorDouble := 12;
   LTarget := TMVCBrPrototype.Clone(LSource);
   Assert.IsTrue(LTarget.ValorDouble=LSource.ValorDouble,'N�o copiou o valor');
end;

procedure TestTMVCBrPrototype.TestValorString;
begin
   LSource.ValorString := '12';
   LTarget := TMVCBrPrototype.Clone(LSource);
   Assert.IsTrue(LTarget.ValorString=LSource.ValorString,'N�o copiou o valor');

end;

{ TPrototypeObjectTest }

procedure TPrototypeObjectTest.SetbooleanProp(const Value: Boolean);
begin
  FBooleanProp := Value;
end;

procedure TPrototypeObjectTest.SetdateProp(const Value: TDatetime);
begin
  FDateProp := Value;
end;

procedure TPrototypeObjectTest.SetdoubleProp(const Value: Double);
begin
  FDoubleProp := Value;
end;

procedure TPrototypeObjectTest.SetpublicProperty(const Value: string);
begin
  FPublicProperty := Value;
end;

procedure TPrototypeObjectTest.SetpublishedProperty(const Value: TDatetime);
begin
  FPublishedProperty := Value;
end;

end.
