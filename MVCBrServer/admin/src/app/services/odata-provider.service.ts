// <summary>
//  ODataBr Provider
//  Auth: amarildo lacerda - tireideletra.com.br
// </summary>
import { Injectable, Inject } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Rx';



export interface ODataService {
  resource?: string;
  select?: Array<string>;
  filter?: string;
  groupBy?: Array<string>;
  orderBy?: Array<string>;
  top?: number;
  skip?: number;
  count?: boolean;
}

export class ODataFactory implements ODataService {
  
  resource: string;
  select: Array<string>;
  filter: string;
  groupBy: Array<string>;
  orderBy: Array<string>;
  top: number;
  skip: number;
  count: boolean;

  constructor(resource: string, select: Array<string>,
    filter?: string, groupBy?: Array<string>, orderBy?: Array<string>) {
    this.resource = resource;
    this.select = select;
    this.filter = filter;
    this.groupBy = groupBy;
    this.orderBy = orderBy;
  }

  public static createFinalStr(ref: ODataService): string {
    let rt = "";
    rt += ((ref.select) ? "&$select=" + ref.select.join(",") : "");
    rt += ((ref.count) ? "&count=1" : "");
    rt += ((ref.top) ? "&$top=" + ref.top.toFixed(0) : "");
    rt += ((ref.skip) ? "&$skip=" + ref.skip.toFixed(0) : "");
    rt += ((ref.filter) ? "&$filter=" + ref.filter : "");
    rt += ((ref.groupBy) ? "&groupby=" + ref.groupBy.join(',') : "");
    rt += ((ref.orderBy) ? "&orderby=" + ref.orderBy.join(",") : "");
    return rt;
  }
  /// create URL for ODataBr
  public static createServicePath(collection: string, rootService : string ='/OData/OData.svc/'): string {
    return rootService + collection;
  }

}


@Injectable()
export class ODataProviderService {
  private observable: Observable<any>;
  query_data: ODataService;
  base_url: string;
  root : string = "/OData/OData.svc/"
  token: string = "";
  headers: HttpHeaders;
  response: any;
  count: number = 0;
  keys: string;
  top: number = 0;
  properties: any = {};
  startsAt: any;
  endsAt: any;


  constructor(private http: HttpClient) {
    this.createUrlBase('',0);
    this.headers = new HttpHeaders();
    this.headers.append('Content-Type', 'application/json; charset=UTF-8');
  }

  public getObservable(): Observable<any> {
    return this.observable;
  }

  private createUrlBase(base: string, port: number) {
    if (port==null)
       console.log("não passou a porta do servidor");
    let lport:string = port.toFixed(0);
    if (port==0){
       lport = window.location.port;
    }
    let url = "";
    if (base != "") {
      url = base;
    }
    else {
      let loc = window.location;
      url = loc.protocol + '//' + loc.hostname + ':' + lport;
    }
    this.base_url = url;
    return url;
  }
  private getOptions() {
    this.count = 0;
    return { headers: this.headers };
  }
  private getUrl(collection: string, aParam: string = "") {
    let p = (aParam != "" ? "&" + aParam : "");
    return this.base_url + ODataFactory.createServicePath(collection,this.root) +
      '?token=' + this.token + p;
  }

  private query(qry: ODataService): ODataProviderService {
    this.getValue(qry);
    return this;
  }

  private fillResponse(rsp: any) {
    for (let it in rsp) {
      switch (it) {
        case '@odata.count': {
          this.count = rsp[it];
          break;
        }
        case 'keys': {
          this.keys = rsp[it];
          break;
        }
        case 'properties': {
          this.properties = rsp[it];
          break;
        }
        case "@odata.top": {
          this.top = rsp[it];
          break;
        }
        case "StartsAt": {
          this.startsAt = rsp[it];
          break;
        }
        case "EndsAt": {
          this.endsAt = rsp[it];
          break;
        }
      }
    }
  }

  /// async call
  public subscribe(proc: any, erroProc: any = null) {
    this.observable.subscribe(rsp => {
      this.fillResponse(rsp);
      let r: Array<any> = rsp.value;
      proc(r);
    }, err => {
      if (erroProc != null) {
        erroProc(err.error);
      } else {
        console.log(err);
       // throw new TypeError(err.error.error);
      }
    })
  }

  /// prepare for async call
  public getValue(query: ODataService): ODataProviderService {
    try {
      this.observable = this.http.request('GET', this.getUrl(query.resource) +
        ODataFactory.createFinalStr(query), this.getOptions());
      if (this.observable == null) {
        throw new TypeError("Não criou uma conexão com o servidor Query: "+query);
      }
    }
    catch (e) {
      alert(e.message);
    }
    return this;
  }

  /// get from generic URL... No regular path, but its OData
  public getOData( url:string):ODataProviderService{
    let path = this.base_url+url+'?token=' + this.token;
    this.observable = this.getJson(path);
    return this;
  }

  /// call generic resource on the server - get for all needs
  public getJson(url:string):Observable<any>{
   return this.http.get(url,this.getOptions())
  }

  // regular GET on ODataBr
  public getReponse(query: ODataService): Observable<any> {
    this.observable = this.http.request('GET', this.getUrl(query.resource) +
      ODataFactory.createFinalStr(query), this.getOptions());
    return this.observable;
  }

  // PUT item - send some data to server with PUT method
  public putItem(collection: string, item: any, erroProc: any = null): Observable<any> {
    /// enviar item para o servidor.
    this.observable = this.http.put(this.getUrl(collection),
      JSON.stringify(item), this.getOptions())
      .map(res => { return res });
    if (erroProc != null)
      this.subscribe(rsp => { this.response = rsp; }, err => {
        console.log(err);
        erroProc(err.message);
      });
    return this.observable;
  }

  // POST method
  public postItem(collection: string, item: any, erroProc: any = null): Observable<any> {
    /// enviar item para o servidor.
    this.observable = this.http.post(this.getUrl(collection),
      JSON.stringify(item), this.getOptions()).map(res => res);
    if (erroProc != null)
      this.subscribe(rsp => { this.response = rsp; }, err => {
        console.log(err);
        erroProc(err.message);
      });
    return this.observable;
  }

  // PATCH method
  public patchItem(collection: string, item: any, erroProc: any = null): Observable<any> {
    /// enviar item para o servidor.
    /// o comando put = patch o mvcbr.odata; os browsers mantem restrição para uso do patch.
    let options = this.getOptions();
    //options.headers.append('Access-Control-Allow-Headers','PATCH');
    //console.log(item);
    this.observable = this.http.put(this.getUrl(collection),
      JSON.stringify(item), options).map(res => res);
    if (erroProc != null)
      this.subscribe(rsp => { this.response = rsp; }, err => {
        console.log(err);
        erroProc(err.message);
      });
    return this.observable;
  }
  
  // DELETE method
  public deleteItem(collection: string, params: any, erroProc: any = null): Observable<any> {
    /// enviar item para o servidor.
    this.observable = this.http.delete(this.getUrl(collection, params),
      this.getOptions()).map(res => res);
    if (erroProc != null)
      this.subscribe(rsp => { this.response = rsp; }, err => {
        console.log(err);
        erroProc(err.message);
      });
    return this.observable;
  }

}
