{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 14/04/2017 23:40:09                                  // }
{ //************************************************************// }
Unit config.Model.Interf;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

uses System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  // %Interf,
  MVCBr.Controller;

type
  // Interface de acesso ao model
  IConfigModel = interface(IModel)
    ['{2A60505C-2057-4DF4-8364-67040A0B03B3}']
    // incluir aqui as especializações

    procedure SetDatabase(const Value: string);
    procedure SetDriverID(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetServer(const Value: string);
    procedure SetUser_Name(const Value: String);
    procedure SetWSPort(const Value: integer);
    function GetDatabase: string;
    function GetDriverID: string;
    function GetPassword: string;
    function GetServer: string;
    function GetUser_Name: String;
    function GetWSPort: integer;

    property Server: string read GetServer write SetServer;
    property Database: string read GetDatabase write SetDatabase;
    property DriverID: string read GetDriverID write SetDriverID;
    property WSPort: integer read GetWSPort write SetWSPort;
    property User_Name: String read GetUser_Name write SetUser_Name;
    property Password: string read GetPassword write SetPassword;

  end;

Implementation

end.
