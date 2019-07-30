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
  config: any ={loaded:false};
  server: any = [];
  constructor(private http: HttpClient) {
   }
  ngOnInit() {
    //Called after the constructor, initializing input properties, and the first call to ngOnChanges.
    //Add 'implements OnInit' to the class.
  }  
  subscribe(proc:any) {
    if (this.config.loaded == false) {
  
      this.observable = this.http.get('./assets/config.json');
  
      let resp = this.observable.subscribe(r => {
        this.config = r;
        this.config.loaded = true;
        this.server = r.server;
        console.log('Resp: '+JSON.stringify(r));
        proc(this)
      })
    } else {  /// ja executou, nao precisa charmar novamente
      console.log('Reaproveitou config anterior');
      proc(this)
    }
  }

  load() {
    // chamado na carga do app
    if (this.config.loaded == false) {
      this.subscribe(r=>{  console.log('Loaded config')});
    }
  }
}
