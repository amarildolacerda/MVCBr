import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { MaterialModule } from './material/material.module';
import { ViewsModule } from './views/views.module';
import { MenuModule } from './menu/menu.module';
import  {ServicesModule} from './services/services.module';

import { AppComponent } from './app.component';


@NgModule({
  declarations: [
    AppComponent,
  ],
  imports: [
    BrowserModule,
    NoopAnimationsModule,
    MaterialModule,
    ViewsModule,
    MenuModule,
    ServicesModule
  ],
  providers: [],
  exports:[
    MaterialModule,
    ServicesModule
  ],

  bootstrap: [AppComponent]
})
export class AppModule { }
