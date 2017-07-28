{ *************************************************************************** }
{ }
{ MVCBr é o resultado de esforços de um grupo }
{ }
{ Copyright (C) 2017 MVCBr }
{ }
{ amarildo lacerda }
{ http://www.tireideletra.com.br }
{ }
{ }
{ *************************************************************************** }
{ }
{ Licensed under the Apache License, Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. }
{ You may obtain a copy of the License at }
{ }
{ http://www.apache.org/licenses/LICENSE-2.0 }
{ }
{ Unless required by applicable law or agreed to in writing, software }
{ distributed under the License is distributed on an "AS IS" BASIS, }
{ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{ See the License for the specific language governing permissions and }
{ limitations under the License. }
{ }
{ *************************************************************************** }
unit MVCBr.Patterns.Adapter;

interface

type

  IMVCBrAdapter = interface
    ['{9075BA8D-80EE-4F4F-BE43-3B5F5BAB406F}']
    function This: TObject;
  end;

  TMVCBrAdapter = class(TInterfacedObject, IMVCBrAdapter)
  private
  public
    function This: TObject;
  end;

  TMVCBrAdapter<T> = class(TMVCBrAdapter)
    private
       FAdapter : T;
    public
      constructor Create( AObject:T );
      function Adapter:T;
  end;


implementation

{ TMVCBrAdapter }


function TMVCBrAdapter.This: TObject;
begin
  result := self;
end;

{ TMVCBrAdapter<T> }

function TMVCBrAdapter<T>.Adapter: T;
begin
   result := FAdapter;
end;

constructor TMVCBrAdapter<T>.Create(AObject: T);
begin
    inherited create;
    FAdapter := AObject;
end;

end.
