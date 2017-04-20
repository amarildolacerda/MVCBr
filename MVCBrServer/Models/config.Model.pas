{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 14/04/2017 23:40:09                                  // }
{ //************************************************************// }
Unit config.Model;

{ MVCBr
  www.tireideletra.com.br
  amarildo lacerda
}
interface

{ .$I ..\inc\mvcbr.inc }
uses System.SysUtils, {$IFDEF LINUX} {$ELSE}{$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms,
{$ENDIF}{$ENDIF} System.Classes, MVCBr.Interf, MVCBr.Model,
  config.Model.Interf, // %Interf,
  MVCBr.Controller;

Type

  TConfigModel = class(TModelFactory, IConfigModel, IThisAs<TConfigModel>)
  private
    FWSPort: integer;
    FUser_Name: String;
    FDriverID: string;
    FDatabase: string;
    FPassword: string;
    FServer: string;
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
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(): IConfigModel; overload;
    class function new(const AController: IController): IConfigModel; overload;
    function ThisAs: TConfigModel;
    // implementaçoes

    property Server: string read GetServer write SetServer;
    property Database: string read GetDatabase write SetDatabase;
    property DriverID: string read GetDriverID write SetDriverID;
    property WSPort: integer read GetWSPort write SetWSPort;
    property User_Name: String read GetUser_Name write SetUser_Name;
    property Password: string read GetPassword write SetPassword;

  end;

Implementation

constructor TConfigModel.Create;
begin
  inherited;
  WSPort := 8080;
  DriverID := 'FB';
  Server := 'localhost';
  Database := 'mvcbr';
  User_Name := 'SYSDBA';
  Password := 'masterkey';
  ModelTypes := [mtCommon];
end;

destructor TConfigModel.Destroy;
begin
  inherited;
end;

function TConfigModel.GetDatabase: string;
begin
   result := FDatabase;
end;

function TConfigModel.GetDriverID: string;
begin
  result := FDriverID;
end;

function TConfigModel.GetPassword: string;
begin
  result := FPassword;
end;

function TConfigModel.GetServer: string;
begin
  result := FServer;
end;

function TConfigModel.GetUser_Name: String;
begin
  result := FUser_Name;
end;

function TConfigModel.GetWSPort: integer;
begin
  result := FWSPort;
end;

function TConfigModel.ThisAs: TConfigModel;
begin
  result := self;
end;

class function TConfigModel.new(): IConfigModel;
begin
  result := new(nil);
end;

class function TConfigModel.new(const AController: IController): IConfigModel;
begin
  result := TConfigModel.Create;
  result.Controller(AController);
end;

procedure TConfigModel.SetDatabase(const Value: string);
begin
  FDatabase := Value;
end;

procedure TConfigModel.SetDriverID(const Value: string);
begin
  FDriverID := Value;
end;

procedure TConfigModel.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TConfigModel.SetServer(const Value: string);
begin
  FServer := Value;
end;

procedure TConfigModel.SetUser_Name(const Value: String);
begin
  FUser_Name := Value;
end;

procedure TConfigModel.SetWSPort(const Value: integer);
begin
  FWSPort := Value;
end;

Initialization

TMVCBr.RegisterType<IConfigModel, TConfigModel>
  (TConfigModel.classname, true);

end.
