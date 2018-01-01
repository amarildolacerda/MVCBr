import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {AppRoutingModule } from '../router.module';
import { VeiwsRouterRoutingModule } from './views.router';

import { UsersComponent } from './users/users.component';
import { MenuModule } from '../menu/menu.module';
import { ServicesModule } from '../services/services.module';
import { LoginComponent } from './login/login.component';
import { PrincipalComponent } from './principal/principal.component';
import { SobreComponent } from './sobre/sobre.component';
import { MaterialModule } from '../material/material.module';

@NgModule({
  imports: [
    AppRoutingModule,
    VeiwsRouterRoutingModule,
    CommonModule,
    MenuModule,
    ServicesModule,
    MaterialModule
  ],
  declarations: [
    //ODataBrAdminService,
    UsersComponent,
    LoginComponent,
    PrincipalComponent,
    SobreComponent],
  exports: [
    //ODataBrAdminService,
    UsersComponent]
})
export class ViewsModule { }
