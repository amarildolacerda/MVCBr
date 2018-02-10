import { Injectable, Inject } from '@angular/core';
import { Jsonp, Http, Response, Headers, RequestOptions, URLSearchParams } from '@angular/http';
import 'rxjs/add/operator/map';
import 'rxjs/add/operator/toPromise';
import 'rxjs/add/operator/first';
import { Observable } from 'rxjs';



export interface IODataService {
  resource: string;
  select?: Array<string>;
  filter?: string;
  groupBy?: Array<string>;
  orderBy?: Array<string>;
  top?: number;
  skip?: number;
  count?: boolean;
}

export class TODataFactory implements IODataService {
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

  public static createFinalStr(ref: IODataService): string {
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
  public static createServicePath(collection: string): string {
    return '/OData/OData.svc/' + collection;
  }

}


@Injectable()
export class ODataProviderService {

  private http: Http
  base_url: string = "http://localhost:8080";
  token: string = "";
  headers: Headers;

  private getOptions() {
    return { headers: this.headers };
  }
  constructor(http: Http) {
    this.http = http;
    this.headers = new Headers();
    this.headers.append('Content-Type', 'application/json; charset=UTF-8');
  }
  private getUrl(collection: string, aParam: string = "") {
    let p = (aParam != "" ? "&" + aParam : "");
    return this.base_url + TODataFactory.createServicePath(collection) +
      '?token=' + this.token + p;
  }

  public getValue(query: IODataService): Observable<Array<any>> {
    return this.http.request(this.getUrl(query.resource) +
      TODataFactory.createFinalStr(query), this.getOptions())
      .map(res => res.json().value);
  }

  public getReponse(query: IODataService): Observable<Array<any>> {
    return this.http.request(this.getUrl(query.resource) +
      TODataFactory.createFinalStr(query), this.getOptions())
      .map(res => res.json());
  }

  public putItem(collection: string, item: any) {
    /// enviar item para o servidor.
    return this.http.put(this.getUrl(collection),
      JSON.stringify(item), this.getOptions())
      .map(res => res.json());
  }

  public postItem(collection: string, item: any) {
    /// enviar item para o servidor.
    return this.http.post(this.getUrl(collection),
      JSON.stringify(item), this.getOptions()).map(res => res.json());
  }
  public patchItem(collection: string, item: any) {
    /// enviar item para o servidor.
    /// o comando put = patch o mvcbr.odata; os browsers mantem restrição para uso do patch.
    return this.http.put(this.getUrl(collection),
      JSON.stringify(item), this.getOptions()).map(res => res.json());
  }
  public deleteItem(collection: string, params: any) {
    /// enviar item para o servidor.
    return this.http.delete(this.getUrl(collection, params),
      this.getOptions()).map(res => res.json());
  }

}
