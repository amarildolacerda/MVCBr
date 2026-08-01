unit TestMVCBr.DatabaseModel;

interface

uses
  DUnitX.TestFramework, System.SysUtils, System.Classes, Data.DB,
  MVCBr.Interf, MVCBr.DatabaseModel, MVCBr.DatabaseModel.Interf;

type
  [TestFixture]
  TestTQueryModelFactory = class
  private
    FSut: IQueryModel<TDataSet>;
    FObj: TQueryModelFactory<TDataSet>;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Create_Default_ColumnsIsStar;
    [Test]
    procedure Table_SetsTableName;
    [Test]
    procedure Where_SetsClause;
    [Test]
    procedure OrderBy_SetsClause;
    [Test]
    procedure Join_SetsClause;
    [Test]
    procedure GroupBy_SetsClause;
    [Test]
    procedure Columns_SetsColumnList;
    [Test]
    procedure Sql_TableOnly_ReturnsBasicSelect;
    [Test]
    procedure Sql_WithWhere_IncludesWhere;
    [Test]
    procedure Sql_WithOrderBy_IncludesOrder;
    [Test]
    procedure Sql_WithJoin_IncludesJoin;
    [Test]
    procedure Sql_WithAllClauses_ReturnsFullQuery;
    [Test]
    procedure Query_ReturnsDataset;
  end;

implementation

{ TestTQueryModelFactory }

procedure TestTQueryModelFactory.SetUp;
begin
  FObj := TQueryModelFactory<TDataSet>.New(nil, nil);
  FSut := FObj;
end;

procedure TestTQueryModelFactory.TearDown;
begin
  FSut := nil;
  FObj := nil;
end;

procedure TestTQueryModelFactory.Create_Default_ColumnsIsStar;
begin
  Assert.IsTrue(Pos('*', FObj.sql) > 0,
    'Default sql should contain *');
end;

procedure TestTQueryModelFactory.Table_SetsTableName;
begin
  FSut.Table('customers');
  Assert.IsTrue(Pos('customers', FObj.sql) > 0,
    'sql should contain table name');
end;

procedure TestTQueryModelFactory.Where_SetsClause;
begin
  FSut.Table('t').Where('where id = 1');
  Assert.IsTrue(Pos('where id = 1', FObj.sql) > 0,
    'sql should contain where clause');
end;

procedure TestTQueryModelFactory.OrderBy_SetsClause;
begin
  FSut.Table('t').OrderBy('order by name');
  Assert.IsTrue(Pos('order by name', FObj.sql) > 0,
    'sql should contain order by');
end;

procedure TestTQueryModelFactory.Join_SetsClause;
begin
  FSut.Table('t').Join('inner join t2 on t.id = t2.id');
  Assert.IsTrue(Pos('inner join', FObj.sql) > 0,
    'sql should contain join');
end;

procedure TestTQueryModelFactory.GroupBy_SetsClause;
begin
  FSut.Table('t').GroupBy('group by cat');
  Assert.IsTrue(Pos('group by cat', FObj.sql) > 0,
    'sql should contain group by');
end;

procedure TestTQueryModelFactory.Columns_SetsColumnList;
begin
  FSut.Columns('id, name').Table('t');
  Assert.IsTrue(Pos('id, name', FObj.sql) > 0,
    'sql should contain custom columns');
end;

procedure TestTQueryModelFactory.Sql_TableOnly_ReturnsBasicSelect;
begin
  FSut.Table('products');
  Assert.IsTrue(FObj.sql = 'select * from products',
    'Basic sql should be "select * from products"');
end;

procedure TestTQueryModelFactory.Sql_WithWhere_IncludesWhere;
begin
  FSut.Table('orders').Where('where status = ''active''');
  Assert.IsTrue(Pos('where status', FObj.sql) > 0,
    'sql should include where clause');
  Assert.IsTrue(Pos('from orders', FObj.sql) > 0,
    'sql should include from');
end;

procedure TestTQueryModelFactory.Sql_WithOrderBy_IncludesOrder;
begin
  FSut.Table('items').OrderBy('order by date desc');
  Assert.IsTrue(Pos('order by date desc', FObj.sql) > 0,
    'sql should include order by');
end;

procedure TestTQueryModelFactory.Sql_WithJoin_IncludesJoin;
begin
  FSut.Table('a').Join('left join b on a.id = b.a_id');
  Assert.IsTrue(Pos('left join', FObj.sql) > 0,
    'sql should include join');
end;

procedure TestTQueryModelFactory.Sql_WithAllClauses_ReturnsFullQuery;
begin
  FSut.Columns('a.id, a.name, b.total')
    .Table('orders a')
    .Join('left join payments b on a.id = b.order_id')
    .Where('where a.status = ''paid''')
    .GroupBy('group by a.id, a.name, b.total')
    .OrderBy('order by a.name');
  Assert.IsTrue(Pos('select a.id, a.name, b.total', FObj.sql) > 0,
    'full sql should start with select columns');
  Assert.IsTrue(Pos('from orders a', FObj.sql) > 0,
    'full sql should include from');
  Assert.IsTrue(Pos('left join payments', FObj.sql) > 0,
    'full sql should include join');
  Assert.IsTrue(Pos('where a.status', FObj.sql) > 0,
    'full sql should include where');
  Assert.IsTrue(Pos('group by', FObj.sql) > 0,
    'full sql should include group by');
  Assert.IsTrue(Pos('order by a.name', FObj.sql) > 0,
    'full sql should include order by');
end;

procedure TestTQueryModelFactory.Query_ReturnsDataset;
begin
  Assert.IsNotNull(FSut.Query, 'Query should return a TDataSet');
  Assert.IsTrue(FSut.Query is TDataSet, 'Query should be TDataSet');
end;

initialization
  TDUnitX.RegisterTestFixture(TestTQueryModelFactory);
end.
