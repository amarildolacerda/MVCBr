unit uCommonInterface;

interface

uses
  System.JSON,
  SynCommons,
  IPPeerClient,
  uClasses;

type
  IAddCompany = interface
    ['{ED698634-3763-4A9C-9D29-77B7FC28CA0F}']
    function Process(oCompany : TCompany) : string;
  end;

  IGetCompany = interface
    ['{4BA58B50-D1CD-4AF2-A962-794B9AE586EA}']
    function Process() : string;
  end;

  IAddTwitterApplication = interface
    ['{C1BB0727-3694-4AEB-B744-464B972FA0DD}']
    function Process(oTwitterApplication : TTwitterApplication) : string;
  end;

  IGetTwitterApplication = interface
    ['{2ED986F7-9C24-428E-8737-657F5D45DD0B}']
    function Process(CompanyID : Integer) : string;
  end;

  IGetTwitterAccount = interface
    ['{714F2C6A-F998-4853-B07E-7B807A6B5D0E}']
    function Process(AppID : Integer) : string;
  end;

  IAddTwitterAccount = interface
    ['{DD9F1518-F5D7-4A67-84DC-37F3891B6A15}']
    function Process(oTwitterAccount : TTwitterAccount) : string;
  end;

implementation

end.
