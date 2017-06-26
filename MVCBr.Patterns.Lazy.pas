{
  ORM Brasil é um ORM simples e descomplicado para quem utiliza Delphi

  Copyright (c) 2016, Isaque Pinheiro
  All rights reserved.

  GNU Lesser General Public License
  Versão 3, 29 de junho de 2007

  Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
  A todos é permitido copiar e distribuir cópias deste documento de
  licença, mas mudá-lo não é permitido.

  Esta versão da GNU Lesser General Public License incorpora
  os termos e condições da versão 3 da GNU General Public License
  Licença, complementado pelas permissões adicionais listadas no
  arquivo LICENSE na pasta principal.
}

{ @abstract(ORMBr Framework.)
  @created(20 Jul 2016)
  @author(Isaque Pinheiro <isaquepsp@gmail.com>)
  @author(Skype : ispinheiro)

  ORM Brasil é um ORM simples e descomplicado para quem utiliza Delphi.
}
{
  Alterado para compatibilidade com estrutura do MVCBr.

}

unit MVCBr.Patterns.Lazy;

interface

uses
  SysUtils,
  TypInfo;

const
  ObjCastGUID: TGUID = '{D30C6058-57A5-4CA3-B094-EA0DB7B48B56}';

type

  IMVCBrLazy<T: class> = interface(TFunc<T>)
    ['{17498F3A-F1D7-410D-8D96-B299C26F947B}']
    function IsCreated: Boolean;
    property Default: T read Invoke;
    procedure Release;
  end;

  TMVCBrLazy<T: class> = class(TInterfacedObject, IMVCBrLazy<T>, IInterface)
  private
    FIsCreated: Boolean;
    FDefault: T;
    FFactory: TFunc<T>;
    procedure Initialize;
    function Invoke: T;
  protected
    function QueryInterface(const AIID: TGUID; out Obj): HResult; stdcall;
  public
    constructor Create(AValueFactory: TFunc<T>);
    destructor Destroy; override;
    procedure Release; virtual;

    function IsCreated: Boolean;
    property Default: T read Invoke;
  end;

  MVCBrLazy<T: class> = record
  strict private
    FLazy: IMVCBrLazy<T>;
    function GetDefault: T;
  private
  public
    class constructor Create;
    property Default: T read GetDefault;
    class operator Implicit(const Value: MVCBrLazy<T>): IMVCBrLazy<T>; overload;
    class operator Implicit(const Value: MVCBrLazy<T>): T; overload;
    class operator Implicit(const Value: TFunc<T>): MVCBrLazy<T>; overload;
  end;

implementation

constructor TMVCBrLazy<T>.Create(AValueFactory: TFunc<T>);
begin
  FFactory := AValueFactory;
end;

destructor TMVCBrLazy<T>.Destroy;
begin
  if FIsCreated then
  begin
    if Assigned(FDefault) then
      FDefault.Free;
  end;
  inherited;
end;

procedure TMVCBrLazy<T>.Initialize;
begin
  if not FIsCreated then
  begin
    FDefault := FFactory();
    FIsCreated := True;
  end;
end;

function TMVCBrLazy<T>.Invoke: T;
begin
  Initialize();
  Result := FDefault;
end;

function TMVCBrLazy<T>.IsCreated: Boolean;
begin
  Result := FIsCreated;
end;

function TMVCBrLazy<T>.QueryInterface(const AIID: TGUID; out Obj): HResult;
begin
  if IsEqualGUID(AIID, ObjCastGUID) then
  begin
    Initialize;
  end;
  Result := inherited;
end;

procedure TMVCBrLazy<T>.Release;
begin
end;

{ Lazy<T> }

class constructor MVCBrLazy<T>.Create;
begin
  // TRttiSingleton.GetInstance.GetRttiType(TypeInfo(T));
end;

function MVCBrLazy<T>.GetDefault: T;
begin
  Result := FLazy();
end;

class operator MVCBrLazy<T>.Implicit(const Value: MVCBrLazy<T>): IMVCBrLazy<T>;
begin
  Result := Value.FLazy;
end;

class operator MVCBrLazy<T>.Implicit(const Value: MVCBrLazy<T>): T;
begin
  Result := Value.Default;
end;

class operator MVCBrLazy<T>.Implicit(const Value: TFunc<T>): MVCBrLazy<T>;
begin
  Result.FLazy := TMVCBrLazy<T>.Create(Value);
end;

end.
