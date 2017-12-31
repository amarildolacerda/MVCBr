import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MaterialModule } from '../material/material.module';

import { HeaderComponent } from './header/header.component';
import { FooterComponent } from './footer/footer.component';
import { LeftComponent } from './left/left.component';
import { ContentComponent } from './content/content.component';

@NgModule({
  imports: [
    CommonModule,
    MaterialModule
  ],
  declarations: [HeaderComponent, FooterComponent, LeftComponent, ContentComponent],
  exports:[
    HeaderComponent, FooterComponent, LeftComponent, ContentComponent
  ]
})
export class MenuModule { }
