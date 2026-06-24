unit TestMVCBrInterf;

interface

uses
  DUnitX.TestFramework, System.Classes, System.RTTI, System.TypInfo,
  System.Generics.Collections, MVCBr.Interf, System.SysUtils;

type
  [TestFixture]
  TestInterfs = class
  public
    [Test]
    procedure TestGUID;
    [Test]
    procedure TestIsSameDiferentes;
    [Test]
    procedure TestIsSameIguais;
    [Test]
    procedure TestIsService;
  end;

implementation

type
  IInterfaceTeste = interface
    ['{35A547B7-E304-4E09-A99F-B7FAC2A60AD7}']
  end;

  IInterfaceTeste2 = interface
    ['{B0E7B1BE-BBC2-49F3-AFE5-F9F26E1BFBD3}']
  end;

  TObjectIntrf = class(TInterfacedObject, IInterfaceTeste)
  end;

  TObjectIntrf2 = class(TInterfacedObject, IInterfaceTeste2)
  end;

procedure TestInterfs.TestGUID;
var
  guid: TGuid;
  AInterface: IInterfaceTeste;
begin
  AInterface := TObjectIntrf.create;
  guid := TMVCBr.GetGuid(AInterface);
  Assert.IsTrue(TMVCBr.GetGuidString(guid) = TMVCBr.GetGuidString
    (TMVCBr.GetGuid<IInterfaceTeste>()), 'Guid n�o confere');

  Assert.IsFalse(TMVCBr.GetGuidString(guid) = TMVCBr.GetGuidString
    (TMVCBr.GetGuid<IInterfaceTeste2>()), 'Falou ao testas se os GUID s�o diferentes');
end;

procedure TestInterfs.TestIsSameDiferentes;
begin
  Assert.IsFalse(TMVCBr.IsSame(IInterfaceTeste, IInterfaceTeste2),
    'As interface falhou ao testar se s�o diferentes');
end;

procedure TestInterfs.TestIsSameIguais;
begin
  Assert.IsTrue(TMVCBr.IsSame(IInterfaceTeste, IInterfaceTeste),
    'As interface falhou ao testar se s�o iguasi');
end;

procedure TestInterfs.TestIsService;
var
  o: TObjectIntrf;
begin
  o := TObjectIntrf.create;
  Assert.IsTrue(TMVCBr.IsService<IInterfaceTeste>(o),
    'Falou ao checar IsService Iguais');
  Assert.IsFalse(TMVCBr.IsService<IInterfaceTeste2>(o),
    'Falou ao checar IsService Diferentes');
end;

end.
