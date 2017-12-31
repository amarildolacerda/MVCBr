///
/// Carrega configuraçoes do arquivo config.json
/// amarildo lacerda - tireideletra.com.br
///
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import * as cfgJson from '../../assets/config.json';


@Injectable()
export class GlobalsService {
  observable: Observable<any>;
  config: any ;
  server: any = [];
  constructor(private http: HttpClient) {
    this.config = cfgJson;
    this.config.loaded = false;
    this.observable = this.http.get('./assets/config.json');
    this.subscribe(r=>{});
   }

  ngOnInit() {
    //Called after the constructor, initializing input properties, and the first call to ngOnChanges.
    //Add 'implements OnInit' to the class.
    
  }  

  subscribe(proc:any) {
    if (this.config.loaded == false) {
     let resp = this.observable.subscribe(r => {
        this.config = r;
        this.config.loaded = true;
        this.server = r.server;
        console.log(r);
        proc(this)
      })
    } else {  /// ja executou, nao precisa charmar novamente
      proc(this)
    }
  }

  load() {
    // chamado na carga do app
    this.subscribe(r=>{});
  }
}
