import { NgModule } from '@angular/core';
import {Routes, RouterModule} from "@angular/router";
import { AppComponent } from "./app.component";
import { PrincipalComponent } from './views/principal/principal.component';



const routesPrincipal: Routes = [
    { path: '', component: PrincipalComponent },
   ];

  export const AppRoutingModule = RouterModule.forRoot(routesPrincipal);