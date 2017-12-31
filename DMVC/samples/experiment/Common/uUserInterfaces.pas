unit uUserInterfaces;

interface

uses
System.JSON,SynCommons;

type
  IUserLogin = interface
    ['{9ECACF79-B88A-400A-B295-3D204F4B15A3}']
    function Process(Username, Password: string): string;
  end;

implementation

end.
