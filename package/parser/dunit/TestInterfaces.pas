unit TestInterfaces;

interface

uses
  Classes,
  SysUtils,
  Windows;

type
  TEnumeratedType = (etOne, etTwo, etThree);

  ITestInterfaceOne = interface
    function GetOne: string;
    procedure SetOne(const Value: string);
    property One: string read GetOne write SetOne;
    function GetTwo(Index: Integer): Boolean;
    procedure SetTwo(Index: Integer; const Value: Boolean);
    property Two[Index: Integer]: Boolean read GetTwo write SetTwo; default;
  end;

  ITestInterfaceTwo = interface(ITestInterfaceOne)
    function GetThree: TEnumeratedType;
    property Three: TEnumeratedType read GetThree;
    procedure SetFour(const Value: TEnumeratedType);
    property Four: TEnumeratedType write SetFour;
  end;

implementation

end.
 