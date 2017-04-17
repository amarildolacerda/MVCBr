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
  TconfigModel = class(TModelFactory, IconfigModel, IThisAs<TconfigModel>)
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
  protected
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function new(): IconfigModel; overload;
    class function new(const AController: IController): IconfigModel; overload;
    function ThisAs: TconfigModel;
    // implementaçoes

    property Server: string read FServer write SetServer;
    property Database: string read FDatabase write SetDatabase;
    property DriverID: string read FDriverID write SetDriverID;
    property WSPort: integer read FWSPort write SetWSPort;
    property User_Name: String read FUser_Name write SetUser_Name;
    property Password: string read FPassword write SetPassword;

  end;

Implementation

constructor TconfigModel.Create;
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

destructor TconfigModel.Destroy;
begin
  inherited;
end;

function TconfigModel.ThisAs: TconfigModel;
begin
  result := self;
end;

class function TconfigModel.new(): IconfigModel;
begin
  result := new(nil);
end;

class function TconfigModel.new(const AController: IController): IconfigModel;
begin
  result := TconfigModel.Create;
  result.Controller(AController);
end;

procedure TconfigModel.SetDatabase(const Value: string);
begin
  FDatabase := Value;
end;

procedure TconfigModel.SetDriverID(const Value: string);
begin
  FDriverID := Value;
end;

procedure TconfigModel.SetPassword(const Value: string);
begin
  FPassword := Value;
end;

procedure TconfigModel.SetServer(const Value: string);
begin
  FServer := Value;
end;

procedure TconfigModel.SetUser_Name(const Value: String);
begin
  FUser_Name := Value;
end;

procedure TconfigModel.SetWSPort(const Value: integer);
begin
  FWSPort := Value;
end;

Initialization

TMVCBr.RegisterType<IconfigModel, TconfigModel>
  (TconfigModel.classname, true);

end.
