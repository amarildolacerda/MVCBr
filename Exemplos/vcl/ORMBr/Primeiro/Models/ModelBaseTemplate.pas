unit ModelBaseTemplate;
/// <summary>
///   Abstract Model Factory Creator Templete
/// </summary>
///  <auth> amarildo lacerda, MVCBr </auth>
interface

uses System.Classes, System.SysUtils,
  System.JSON, System.RTTI,
  MVCBr.Interf, MVCBr.Model;

type
  /// <summary>
  ///   Interface abstract
  /// </summary>
  TClientesFactory = class;

  IClientesFactory = interface(IModel)
    function This: TClientesFactory;
  end;

  /// <summary>
  ///   Implementation for Abstract Model
  /// </summary>
  TClientesFactory = class(TModelFactory, IClientesFactory)
  public
    function This: TClientesFactory;
  end;

implementation

{ TBaseModelFactory }

function TClientesFactory.This: TClientesFactory;
begin
    result := self;
end;

end.


