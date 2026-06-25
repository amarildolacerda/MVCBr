unit TestMVCBr.InterfaceHelper;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  MVCBr.Interf, MVCBr.InterfaceHelper,
  MVCBr.Model;

type
  [TestFixture]
  TestTInterfaceHelper = class
  private
    FModel: IModel;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure GetType_WithIModel_ReturnsInterfaceType;
    [Test]
    procedure GetTypeName_WithIModel_ReturnsName;
    [Test]
    procedure GetQualifiedName_WithIModel_ReturnsQualifiedName;
    [Test]
    procedure GetTypeByGuid_WithIModelGuid_ReturnsInterfaceType;
    [Test]
    procedure GetTypeNameByGuid_WithIModelGuid_ReturnsName;
    [Test]
    procedure GetQualifiedNameByGuid_WithIModelGuid_ReturnsQualifiedName;
    [Test]
    procedure GetTypeByGuid_WithIModelGuid_ReturnsInterfaceType_Again;
  end;

implementation

{ TestTInterfaceHelper }

procedure TestTInterfaceHelper.SetUp;
begin
  FModel := TModelFactory.Create;
end;

procedure TestTInterfaceHelper.TearDown;
begin
  FModel := nil;
end;

procedure TestTInterfaceHelper.GetType_WithIModel_ReturnsInterfaceType;
begin
  Assert.IsNotNull(TInterfaceHelper.GetType(FModel),
    'GetType(IModel) should not return nil');
end;

procedure TestTInterfaceHelper.GetTypeName_WithIModel_ReturnsName;
begin
  Assert.IsNotEmpty(TInterfaceHelper.GetTypeName(FModel),
    'GetTypeName should not be empty');
end;

procedure TestTInterfaceHelper.GetQualifiedName_WithIModel_ReturnsQualifiedName;
begin
  Assert.IsNotEmpty(TInterfaceHelper.GetQualifiedName(FModel),
    'GetQualifiedName should not be empty');
end;

procedure TestTInterfaceHelper.GetTypeByGuid_WithIModelGuid_ReturnsInterfaceType;
begin
  Assert.IsNotNull(TInterfaceHelper.GetType(IModel),
    'GetType(IModel GUID) should not return nil');
end;

procedure TestTInterfaceHelper.GetTypeNameByGuid_WithIModelGuid_ReturnsName;
begin
  Assert.IsNotEmpty(TInterfaceHelper.GetTypeName(IModel),
    'GetTypeName(IModel GUID) should not be empty');
end;

procedure TestTInterfaceHelper.GetQualifiedNameByGuid_WithIModelGuid_ReturnsQualifiedName;
begin
  Assert.IsNotEmpty(TInterfaceHelper.GetQualifiedName(IModel),
    'GetQualifiedName(IModel GUID) should not be empty');
end;

procedure TestTInterfaceHelper.GetTypeByGuid_WithIModelGuid_ReturnsInterfaceType_Again;
begin
  Assert.IsNotNull(TInterfaceHelper.GetType(IModel),
    'GetType(IModel GUID) should not return nil');
end;

initialization
  TDUnitX.RegisterTestFixture(TestTInterfaceHelper);
end.
