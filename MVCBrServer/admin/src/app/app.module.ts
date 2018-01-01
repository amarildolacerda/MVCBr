import { BrowserModule } from '@angular/platform-browser';
import { NgModule,APP_INITIALIZER } from '@angular/core';

import { GlobalsService } from './services/globals.service';

import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { MaterialModule } from './material/material.module';
import { ViewsModule } from './views/views.module';
import { MenuModule } from './menu/menu.module';
import  {ServicesModule} from './services/services.module';
import {AppRoutingModule} from './router.module';


import { AppComponent } from './app.component';
import { InternalModule } from './internal/internal.module';


@NgModule({
  declarations: [
    AppComponent,
  ],
  imports: [
    AppRoutingModule,
    BrowserModule,
    NoopAnimationsModule,
    MaterialModule,
    ViewsModule,
    MenuModule,
    ServicesModule,
    InternalModule
  ],
  providers: [

    GlobalsService,
    {
      provide: APP_INITIALIZER,
      useFactory: (ds: GlobalsService) => function () { return ds.load() },
      deps: [GlobalsService],
      multi: true
    },


  ],
  exports:[
    AppRoutingModule,
    MaterialModule,
    ServicesModule
  ],

  bootstrap: [AppComponent]
})
export class AppModule { }
