///
/// acesso ao serviço de admin
/// amarildo lacerda - tireideletra.com.br
///

import { Injectable } from '@angular/core';
import { ODataProviderService } from './odata-provider.service';
import { GlobalsService } from './globals.service';
import { Observable } from 'rxjs/Observable';


@Injectable()
export class ODataBrAdminService {
  observable:ODataProviderService;
  

constructor(private rest:ODataProviderService, private globals:GlobalsService) {

  globals.subscribe(r=>{
    rest.createUrlBase(globals.server.url,globals.server.port ); 
  });

   }
 public init(proc:any){
  this.globals.subscribe(r=>{
    this.rest.createUrlBase(this.globals.server.url,this.globals.server.port ); 
    proc(r);
  });
 }  
 public gerResourceLink(resource){
     return this.rest.getUrl(resource);
 }  
 public subscribe(proc:any){
   this.observable.subscribe(r=>{ proc(r); });
 }  
 public get_token_new():ODataBrAdminService{
   this.observable =  this.rest.getOData('/OData/admin/token/new') ;
   return this;   
  } 
 public addUser(token,nome,secret,group):Observable<any>{
   return this.rest.putData(`/OData/admin/token/${token}/${nome}/${secret}/${group}`);
 }  
 public odata_services():Observable<any>{
   return this.rest.getJson('/OData');
 }
 public odata_metadata():Observable<any>{
   return this.rest.getJson('/OData/$metadata')
 }
 public describe_server():Observable<any>{
   return this.rest.getJson('/system/describeserver.info');
 }
}
