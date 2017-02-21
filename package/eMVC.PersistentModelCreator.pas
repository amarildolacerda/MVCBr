unit eMVC.PersistentModelCreator;

{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ File Name: ModelCreator.pas }
{ Author: Larry Le }
{ Description:  PersistentModel Creator }
{ }
{ History: }
{ - 1.0, 19 May 2006 }
{ First version }
{ }
{ Email: linfengle@gmail.com }
{ }
{ The contents of this file are subject to the Mozilla Public License }
{ Version 1.1 (the "License"); you may not use this file except in }
{ compliance with the License. You may obtain a copy of the License at }
{ http://www.mozilla.org/MPL/ }
{ }
{ Software distributed under the License is distributed on an "AS IS" }
{ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See }
{ the License for the specific language governing rights and }
{ limitations under the License. }
{ }
{ The Original Code is written in Delphi. }
{ }
{ The Initial Developer of the Original Code is Larry Le. }
{ Copyright (C) eazisoft.com. All Rights Reserved. }
{ }
{ ********************************************************************** }

interface

uses
  Windows, SysUtils,
  eMVC.ViewCreator,
  eMVC.FileCreator,
  ToolsApi,
  eMVC.OTAUtilities,
  eMVC.BaseCreator;

type

  TPersistentModelCreator = class(TBaseCreator)
  private
    FisInterf: boolean;
    FUnitIdent: string;
    procedure SetisInterf(const Value: boolean);
  public
    constructor Create(const APath: string = ''; ABaseName: string = '';
      AUnNamed: boolean = true); override;
    function GetImplFileName: string; override;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string)
      : IOTAFile; override;
    property isInterf: boolean read FisInterf write SetisInterf;
  end;

implementation

{ TPersistentModelCreator }

constructor TPersistentModelCreator.Create(const APath: string = '';
  ABaseName: string = ''; AUnNamed: boolean = true);
begin
  inherited Create(APath, ABaseName, AUnNamed);
  self.SetAncestorName('PersistentModel');
end;

function TPersistentModelCreator.GetImplFileName: string;
begin
  FUnitIdent := getBaseName + '.' + Templates.Values['%modelName'];
  if isInterf then
    result := getBaseName + '.' + Templates.Values['%modelName'] + '.Interf';

  result := self.getpath + FUnitIdent+ '.pas';

  Templates.Values['%UnitIdent'] := FUnitIdent;

    debug('TPersistentModelCreator.GetImplFileName:' + result);

end;

function TPersistentModelCreator.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
var
  fc: TFileCreator;
begin

  if isInterf then
    fc := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent,
      cModelInterf)
  else
    fc := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent,
      cPersistentMODEL);
  fc.isFMX := self.isFMX;

  fc.Templates.Clear;
  fc.Templates.assign(Templates);

  fc.Templates.Add('%modelName=' + Templates.Values['%modelName']);
  fc.Templates.Add('%modelNameInterf=' + Templates.Values['%modelName'] +
    '.ViewModel.Interf');

  result := fc;
end;

procedure TPersistentModelCreator.SetisInterf(const Value: boolean);
begin
  FisInterf := Value;
end;

end.
