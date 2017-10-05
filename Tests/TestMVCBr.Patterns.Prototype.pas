unit TestMVCBr.Patterns.Prototype;

interface

uses
  TestFramework, System.SysUtils, System.Generics.Collections, System.JSON,
  System.RTTI, Forms,
  System.TypInfo, System.Classes,
  MVCBr.Interf, MVCBr.Patterns.Prototype;

type

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
  published
    property DatePProp: TDatetime read FPublishedProperty
      write SetpublishedProperty;
  end;

  TPrototypeComponent = class(TComponent)
  public
    Valor: integer;
  end;

  TestTMVCBrPrototype = class(TTestCase)
  private
    LSource, LTarget: TPrototypeObjectTest;

    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestNew;
    procedure TestCloneObject;
    procedure TestCopyObject;
    procedure TestCloneTComponent;
    procedure TestValorDouble;
    procedure TestValorBoolean;
    procedure TestValorDate;
    procedure TestValorString;
    procedure TestStringProp;
    procedure TestBooleanProp;
    procedure TestDoubleProp;
    procedure TestDateProp;
  end;

implementation

{ TestTMVCBrPrototype }

procedure TestTMVCBrPrototype.SetUp;
begin
  inherited;
  LSource := TPrototypeObjectTest.create;
end;

procedure TestTMVCBrPrototype.TearDown;
begin
  inherited;
  LSource.free;
  if assigned(LTarget) then
    LTarget.free;
end;

procedure TestTMVCBrPrototype.TestBooleanProp;
begin
  LSource.BooleanProp := true;
  LTarget := TMVCBrPrototype.Clone(LSource);
  CheckTrue(LTarget.BooleanProp=true, 'Não Atribuiu Boolean');
end;

procedure TestTMVCBrPrototype.TestCloneObject;
begin
  LSource.ValorInteger := 10;
  LSource.privateValue := 5;
  LTarget := TMVCBrPrototype.clone(LSource);
  checkTrue(LTarget.ValorInteger = 10, 'Não executou o clone');
  checkTrue(LTarget.privateValue = 0, 'atribuiu valor a uma variavel private');
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
    checkTrue(ATarget.Valor=11,'Não copiou o valor');
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
  checkTrue(LTarget.ValorDate = date, 'Não copiou ValorDate');
end;


procedure TestTMVCBrPrototype.TestDateProp;
begin
  LSource.DateProp:= date;
  LTarget := TMVCBrPrototype.clone(LSource);
  CheckEquals(LTarget.DateProp,date,'Nao atribuiu propriedade');
end;

procedure TestTMVCBrPrototype.TestDoubleProp;
begin
  LSource.DoubleProp:= 10;
  LTarget := TMVCBrPrototype.clone(LSource);
  CheckEquals(LTarget.DoubleProp,10,'Nao atribuiu propriedade');

end;

procedure TestTMVCBrPrototype.TestNew;
begin
   LTarget := TMVCBrPrototype.new<TPrototypeObjectTest>;
   LTarget.ValorString := 'X';
   CheckNotNull(LTarget,'Não incializou');
   CheckEqualsString('X',LTarget.ValorString,'não atribuiu a string');
end;

procedure TestTMVCBrPrototype.TestStringProp;
begin
  LSource.StringProp := 'true';
  LTarget := TMVCBrPrototype.Clone(LSource);
  CheckTrue(LTarget.StringProp='true', 'Não Atribuiu Boolean');

end;

procedure TestTMVCBrPrototype.TestValorBoolean;
begin
   LSource.ValorBoolean := true;
   LTarget := TMVCBrPrototype.Clone(LSource);
   checkTrue(LTarget.ValorBoolean=LSource.ValorBoolean,'Não copiou o valor');

end;

procedure TestTMVCBrPrototype.TestValorDate;
begin
   LSource.ValorDate := date;
   LTarget := TMVCBrPrototype.Clone(LSource);
   checkTrue(LTarget.ValorDate=LSource.ValorDate,'Não copiou o valor');

end;

procedure TestTMVCBrPrototype.TestValorDouble;
begin
   LSource.ValorDouble := 12;
   LTarget := TMVCBrPrototype.Clone(LSource);
   checkTrue(LTarget.ValorDouble=LSource.ValorDouble,'Não copiou o valor');
end;

procedure TestTMVCBrPrototype.TestValorString;
begin
   LSource.ValorString := '12';
   LTarget := TMVCBrPrototype.Clone(LSource);
   checkTrue(LTarget.ValorString=LSource.ValorString,'Não copiou o valor');

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

initialization

RegisterTest(TestTMVCBrPrototype.Suite);

end.
