///
/// modulos de serviços
/// amarildo lacerda - tireideletra.com.br
///
import { NgModule,APP_INITIALIZER } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule, HttpClientJsonpModule } from '@angular/common/http';

import { ODataProviderService }  from './odata-provider.service';
import { GlobalsService } from './globals.service';

@NgModule({
  imports: [
    CommonModule,
    HttpClientModule, HttpClientJsonpModule
  ],
  declarations: [],
  providers:[
    ODataProviderService,
    GlobalsService,
    {
      provide: APP_INITIALIZER,
      useFactory: (ds: GlobalsService) => function () { return ds.load() },
      deps: [GlobalsService],
      multi: true
    },
    
  ],
  exports:[
    
  ]
})
export class ServicesModule { }
