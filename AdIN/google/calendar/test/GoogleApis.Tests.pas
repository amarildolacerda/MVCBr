{
  Copyright (C) 2015 by Clever Components

  Author: Sergey Shirokov <admin@clevercomponents.com>

  Website: www.CleverComponents.com

  This file is part of Google API Client Library for Delphi.

  Google API Client Library for Delphi is free software:
  you can redistribute it and/or modify it under the terms of
  the GNU Lesser General Public License version 3
  as published by the Free Software Foundation and appearing in the
  included file COPYING.LESSER.

  Google API Client Library for Delphi is distributed in the hope
  that it will be useful, but WITHOUT ANY WARRANTY; without even the
  implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with Json Serializer. If not, see <http://www.gnu.org/licenses/>.

  The current version of Google API Client Library for Delphi needs for
  the non-free library Clever Internet Suite. This is a drawback,
  and we suggest the task of changing
  the program so that it does the same job without the non-free library.
  Anyone who thinks of doing substantial further work on the program,
  first may free it from dependence on the non-free library.
}

unit GoogleApis.Tests;

interface

uses
  System.Classes, System.SysUtils, TestFramework, GoogleApis, GoogleApis.Persister;

type
  TOAuthCredentialTests = class(TTestCase)
  published
    procedure TestAuthorization;
  end;

  TJsonSerializerTests = class(TTestCase)
  published
    procedure TestGoogleApisException;
  end;

  TUtilsTests = class(TTestCase)
  published
    procedure TestRfc3339Conversion;
  end;

implementation

{ TOAuthCredentialTests }

procedure TOAuthCredentialTests.TestAuthorization;
var
  credential: TGoogleOAuthCredential;
  auth1, auth2: string;
begin
  credential := TGoogleOAuthCredential.Create();
  try
    credential.ClientID := '421475025220-6khpgoldbdsi60fegvjdqk2bk4v19ss2.apps.googleusercontent.com';
    credential.ClientSecret := '_4HJyAVUmH_iVrPB8pOJXjR1';
    credential.Scope := 'https://www.googleapis.com/auth/calendar.readonly';

    auth1 := credential.GetAuthorization();
    CheckNotEquals('', auth1);

    auth2 := credential.GetAuthorization();
    CheckEquals(auth1, auth2);

    Sleep(1000);

    auth2 := credential.RefreshAuthorization();
    CheckNotEquals(auth1, auth2);

    credential.RevokeAuthorization();
    auth1 := credential.GetAuthorization();
    CheckNotEquals(auth1, auth2);
  finally
    credential.Free();
  end;
end;

{ TJsonSerializerTests }

procedure TJsonSerializerTests.TestGoogleApisException;
const
  jsonSource =
'{' +
' "error": {' +
'  "errors": [' +
'   {' +
'    "domain": "global",' +
'    "reason": "authError",' +
'    "message": "Invalid Credentials",' +
'    "locationType": "header",' +
'    "location": "Authorization"' +
'   }' +
'  ],' +
'  "code": 401,' +
'  "message": "Invalid Credentials"' +
' }' +
'}';

  jsonDest = '{"error": {"message": "Invalid Credentials", "code": 401, ' +
'"errors": [{"domain": "global", "reason": "authError", "message": "Invalid Credentials", ' +
'"locationType": "header", "location": "Authorization"}]}}';

var
  serializer: TJsonSerializer;
  obj: EGoogleApisException;
  json: string;
begin
  serializer := nil;
  obj := nil;
  try
    serializer := TGoogleApisJsonSerializer.Create();

    obj := serializer.JsonToException(jsonSource);

    CheckEquals(401, obj.Error.Code);
    CheckEquals('Invalid Credentials', obj.Message);
    CheckEquals('', obj.Error.ExtendedHelp);
    CheckEquals(1, Length(obj.Error.Errors));

    CheckEquals('global', obj.Error.Errors[0].Domain);
    CheckEquals('authError', obj.Error.Errors[0].Reason);
    CheckEquals('Invalid Credentials', obj.Error.Errors[0].Message);
    CheckEquals('header', obj.Error.Errors[0].LocationType);
    CheckEquals('Authorization', obj.Error.Errors[0].Location);
    CheckEquals('', obj.Error.Errors[0].ExtendedHelp);

    json := serializer.ExceptionToJson(obj);

    CheckEquals(jsonDest, json);
  finally
    obj.Free();
    serializer.Free();
  end;
end;

{ TUtilsTests }

procedure TUtilsTests.TestRfc3339Conversion;
const
  etalon1 = '2015-08-11T17:35:36+03:00';
  etalon2 = '2015-08-11T17:35:36+03:15';
  etalon2_local = '2015-08-11T17:20:36+03:00';
  etalon3 = '2015-08-11t17:35:36+03:00';
  etalon4 = '2015-08-11T17:35:36Z';
  etalon4_local = '2015-08-11T20:35:36+03:00';
  etalon5 = '2015-08-11';
  etalon5_local = '2015-08-11T00:00:00+03:00';
  etalon6 = '2015-08-11T14:36:36.000Z';
  etalon6_local = '2015-08-11T17:36:36+03:00';
  etalon7 = '2015-08-11T14:36:36.616Z';
  etalon7_local = '2015-08-11T17:36:36.616+03:00';

var
  s: string;
  d: TDateTime;
begin
  d := TUtils.Rfc3339ToDateTime('');
  CheckEquals(0, d);

  d := TUtils.Rfc3339ToDateTime(etalon1);
  s := TUtils.DateTimeToRfc3339(d);
  CheckEquals(etalon1, s);

  d := TUtils.Rfc3339ToDateTime(etalon2);
  s := TUtils.DateTimeToRfc3339(d);
  CheckEquals(etalon2_local, s);

  d := TUtils.Rfc3339ToDateTime(etalon4);
  s := TUtils.DateTimeToRfc3339(d);
  CheckEquals(etalon4_local, s);

  d := TUtils.Rfc3339ToDateTime(etalon5);
  s := TUtils.DateTimeToRfc3339(d);
  CheckEquals(etalon5_local, s);

  d := TUtils.Rfc3339ToDateTime(etalon6);
  s := TUtils.DateTimeToRfc3339(d);
  CheckEquals(etalon6_local, s);

  d := TUtils.Rfc3339ToDateTime(etalon7);
  s := TUtils.DateTimeToRfc3339(d);
  CheckEquals(etalon7_local, s);
end;

initialization
  TestFramework.RegisterTest(TOAuthCredentialTests.Suite);
  TestFramework.RegisterTest(TJsonSerializerTests.Suite);
  TestFramework.RegisterTest(TUtilsTests.Suite);

end.
