Unit MVCBr.FireDACModel.Interf;

interface

Uses MVCBr.Interf, MVCBr.Model, MVCBr.DatabaseModel.Interf;

Type

  IFireDACModel = interface(IDatabaseModel)
    ['{662656CB-4670-4AC1-B247-DB3C095B07D4}']
    function DriverID(const ADriverID:string):IFireDACModel;
    function ConnectionName(const AConn:string):IFireDACModel;
    function UserName(const AUser:string):IFireDACModel;
    function Password(const APass:string):IFireDACModel;
  end;

Implementation

end.
