{//************************************************************//}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 03/03/2017                                           //}
{//************************************************************//}
unit oData.Client.Builder;

interface

uses  System.Classes, System.SysUtils, oData.Engine, oData.Interf;


Type
     TODataClientBuilder = class;

     IODataClientBuilder = interface
       ['{B173B00D-28A3-4ED8-B08A-8377B59A6C9D}']
       function This:TODataClientBuilder;
     end;


     TODataClientBuilder = class(TInterfacedObject,IODataClientBuilder)
       private
          FOData: IODataDecode;
       public
          constructor create;
          destructor destroy;override;
          function This:TODataClientBuilder;
          function OData:IODataDecode;
          function Resource(AResource:string):IODataClientBuilder;
     end;


implementation

{ TODataClientBuilder }

constructor TODataClientBuilder.create;
begin
   inherited;
   FOData := TODataDecode.create(nil);
end;

destructor TODataClientBuilder.destroy;
begin
  inherited;
end;

function TODataClientBuilder.OData: IODataDecode;
begin
  result := FOData;
end;

function TODataClientBuilder.Resource(AResource: string): IODataClientBuilder;
begin
    result := self;
    FOData.Resource := AResource;
end;

function TODataClientBuilder.This: TODataClientBuilder;
begin
    result := self;
end;

end.
