// <summary>
//  ODataBr Provider
//  Auth: amarildo lacerda - tireideletra.com.br
// </summary>
import { Injectable, Inject } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Rx';
import { GlobalsService } from './globals.service';



export interface ODataService {
  resource?: string;
  join?: string;
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
    rt += ((ref.groupBy) ? "&$group=" + ref.groupBy.join(',') : "");
    rt += ((ref.orderBy) ? "&$order=" + ref.orderBy.join(",") : "");
    return rt;
  }
  public static createServicePath(collection: string, rootService: string = '/OData/OData.svc/'): string {
    return rootService + collection;
  }

}

export class ODataResponse {
  static decode(rsp: any): any {
    if (rsp == null) {
      return { count: 0, value: [] };
    } else {
      let ret: any = {};
      for (let it in rsp) {
        switch (it) {
          case '@odata.count': {
            ret.count = rsp[it];
            break;
          }
          case 'keys': {
            ret.keys = rsp[it];
            break;
          }
          case 'properties': {
            ret.properties = rsp[it];
            break;
          }
          case "@odata.top": {
            ret.top = rsp[it];
            break;
          }
          case "StartsAt": {
            ret.startsAt = rsp[it];
            break;
          }
          case "EndsAt": {
            ret.endsAt = rsp[it];
            break;
          }
          case "value": {
            ret.value = rsp[it];
            break;
          }
        }
      }
      return ret;
    }
  }

}


@Injectable()
export class ODataProviderService {
  private observable: Observable<any>;
  public port:number=0;
  public host:string=''
  query_data: ODataService;
  base_url: string = "http://localhost:8886";
  token: string = "";
  jwtToken :string = "";
  headers: HttpHeaders;
  response: any;
  count: number = 0;
  keys: string;
  top: number = 0;
  properties: any = {};
  startsAt: any;
  endsAt: any;

  config:any = {server:{host:'http://localhost',port:8080}};

  constructor(public http: HttpClient, public global:GlobalsService) {
    this.headers = new HttpHeaders();
    this.headers.append('Content-Type', 'application/json; charset=UTF-8');
    this.global.subscribe(r=>{
      this.config = r;
      this.createUrlBase( r.server.host,r.server.port );
    })
  }
 

  public getObservable(): Observable<any> {
    return this.observable;
  }

  public createUrlBase(base: string, port: number) {
    let url = "";
    let _port= port.toFixed(0);
    if (port==0){
      _port = window.location.port;
    }
    if (base != "") {
      url = base+':'+_port;
      this.host = base;
      this.port = parseInt(_port);
    }
    else {
      let loc = window.location;
      this.host = loc.protocol + '//' + loc.hostname;
      this.port = parseInt(_port);
      url = loc.protocol + '//' + loc.hostname + ':' + _port;
    }
    this.base_url = url;
    return url;
  }
  private getOptions() {
    this.count = 0;
    
    this.headers.set('token',this.config.server.token);
    if (this.jwtToken!='')
      this.headers.set('Autorization',this.jwtToken);
    return { headers: this.headers };
  }
  public getLogin(){
    this.http.get(this.base_url +'/OData/login/'+this.config.token,this.getOptions())
    .subscribe(r=>{ console.log(r)  });
  }
  public getUrl(collection: string, aParam: string = "") {
    let p = (aParam != "" ? "&" + aParam : "");
    return this.base_url + ODataFactory.createServicePath(collection) +
      '?token=' + this.token + p;
  }

  public query(qry: ODataService): ODataProviderService {
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

  public getValue(query: ODataService): ODataProviderService {
    try {
      this.observable = this.http.request('GET', this.getUrl(query.resource) +
        ODataFactory.createFinalStr(query), this.getOptions())
        .map(res => { return res; });
      if (this.observable == null) {
        throw new TypeError("Não criou uma conexão com o servidor Query: " + query);
      }
    }
    catch (e) {
      alert(e.message);
    }
    return this;
  }
  public getJson(url: string): Observable<any> {
    return this.http.get(url, this.getOptions())
  }

  public getBase(url: string): Observable<any> {
    return this.http.get(this.base_url + url, this.getOptions());
  }

  public getReponse(query: ODataService): Observable<any> {
    this.observable = this.http.request('GET', this.getUrl(query.resource) +
      ODataFactory.createFinalStr(query), this.getOptions())
      .map(res => { return res });
    return this.observable;
  }

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
