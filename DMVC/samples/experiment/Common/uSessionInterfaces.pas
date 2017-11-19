unit uSessionInterfaces;

interface

type
  ISessionAddKeyValue = interface
  ['{A0DEF29F-1E8A-407F-A017-601C2D3E9B62}']
    function Process(SessionID, Key, Value: string): Boolean;
  end;

  ISessionRemoveKeyValue = interface
  ['{66AEABF8-2CD0-4E1D-B22C-2B87991F3ACF}']
    function Process(SessionID, Key: string): Boolean;
  end;

  ISessionGetKeyValue = interface
  ['{B8804591-4913-45D3-9FBA-66C211F53731}']
    function Process(SessionID, Key: string): string;
  end;

  ISessionUpdateKeyValue = interface
  ['{62F4C85B-8897-4869-A45A-0599047913D9}']
    function Process(SessionID, Key, Value: string): Boolean;
  end;

  ISessionLogout = interface
  ['{EC60BBF3-1C18-4C3B-B556-AB0D75818E97}']
    function Process(SessionID: string): Boolean;
  end;

  ISessionIsExpired = interface
    ['{1571053B-3AE2-4A35-9434-760491347425}']
    function Process(SessionID: string): Boolean;
  end;

implementation

end.
