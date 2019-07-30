unit oData.GenScript.Typescript;

interface

uses System.Classes, System.SysUtils;

implementation

uses oData.GenScript, oData.ServiceModel,
  System.Json;

function GerarNg5Script: string;
var
  str: TStringList;
  serv: TJsonArray;
  it: TJsonValue;
  AResource: string;
  AMethod: string;
begin
  str := TStringList.create;
  with str do
    try
      add('/// <summary>                                 ');
      add('/// ODataBr - Generate NG5 Script                           ');
      add('/// Date: ' + DateTimeToStr(now) + '                          ');
      add('/// Auth:  amarildo lacerda - tireideletra.com.br           ');
      add('///        gerado pelo Servidor ODataBr: .../OData/hello/ng   ');
      add('/// </summary>                                 ');
      add('');
      add('import { Injectable, Inject } from ''@angular/core'';');
      add('import { HttpClient, HttpHeaders } from ''@angular/common/http'';');
      add('import { ODataProviderService,ODataFactory,ODataService } from ''./odata-provider.service'';');
      add('import { Observable } from ''rxjs/Rx'';');
      add('import { ODataBrServiceBase } from ''./odatabr.service-base''; ');
      add('');
      add('export interface ODataBrQuery extends ODataService { } ');

      add('@Injectable()');
      add('export class ODataBrProvider extends ODataBrServiceBase {');
      add('');
      add('constructor (public _odata:ODataProviderService){');
      add('  super(_odata);');
      add('}');

      if TODataServices.TryGetODataService(ODataServices.LockJson, serv) then
        try
          for it in serv do
            if it.TryGetValue<string>('resource', AResource) then
              if it.TryGetValue<string>('method', AMethod) then
              begin
                if AMethod.Contains('GET') then
                begin
                  add('   get_' + AResource +
                    '( query:ODataBrQuery ):ODataProviderService { ');
                  add('      this.configOptions(); ');
                  add('      query.resource = "' + AResource +
                    '"+(query.join?query.join:"");');
                  add('      return this._odata.getValue( query ); ');
                  add('   }');
                  add('');
                end;
                if AMethod.Contains('PUT') then
                begin
                  add('   put_' + AResource +
                    '( item: any, erroProc:any=null): Observable<any> { ');
                  add('      this.configOptions(); ');
                  add('      return this._odata.putItem("' + AResource +
                    '", item, erroProc ); ');
                  add('   }');
                  add('');
                end;
                if AMethod.Contains('POST') then
                begin
                  add('   post_' + AResource +
                    '( item: any, erroProc:any=null): Observable<any> { ');
                  add('      this.configOptions(); ');
                  add('      return this._odata.postItem("' + AResource +
                    '", item, erroProc ); ');
                  add('   }');
                  add('');
                end;
                if AMethod.Contains('PATCH') then
                begin
                  add('   patch_' + AResource +
                    '( item: any, erroProc:any=null): Observable<any> { ');
                  add('      this.configOptions(); ');
                  add('      return this._odata.patchItem("' + AResource +
                    '", item, erroProc ); ');
                  add('   }');
                  add('');
                end;
                if AMethod.Contains('DELETE') then
                begin
                  add('   delete_' + AResource +
                    '( item: any, erroProc:any=null): Observable<any> { ');
                  add('      this.configOptions(); ');
                  add('      return this._odata.deleteItem("' + AResource +
                    '", item, erroProc ); ');
                  add('   }');
                  add('');
                end;
              end;
        finally
          ODataServices.UnlockJson;
        end;

      add('}');
      result := str.text;
    finally
      str.free;
     // serv.free;   ? precisava testar se é necessário.
    end;
end;

initialization

TODataGenScript.register('ng', GerarNg5Script);

end.
