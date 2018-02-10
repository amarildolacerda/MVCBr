import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule,ReactiveFormsModule } from '@angular/forms';

import {AppRoutingModule } from '../router.module';
import { ViewsRoutesModule } from './views.router';
import { UsersComponent } from './users/users.component';
import { MenuModule } from '../menu/menu.module';
import { ServicesModule } from '../services/services.module';
import { LoginComponent } from './login/login.component';
import { PrincipalComponent } from './principal/principal.component';
import { SobreComponent } from './sobre/sobre.component';
import { MaterialModule } from '../material/material.module';
import { InternalModule } from '../internal/internal.module';


@NgModule({
  imports: [
    AppRoutingModule,
    ViewsRoutesModule,
    CommonModule,
    MenuModule,
    ServicesModule,
    MaterialModule,
    InternalModule,
    FormsModule,
    ReactiveFormsModule
  ],
  declarations: [
    UsersComponent,
    LoginComponent,
    PrincipalComponent,
    SobreComponent,
  ],
  exports: [
    UsersComponent]
})
export class ViewsModule { }
