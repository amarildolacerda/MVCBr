unit uConnectionsInterfaces;

interface

uses
  Data.SqlExpr;

type
  IGetConnection = interface
    ['{167879D9-B4CD-43A0-A909-73D6935A5616}']
    function Process(S: string): TSQLConnection;
  end;


implementation

end.
