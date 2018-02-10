import './polyfills';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import {BrowserModule} from '@angular/platform-browser';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {NgModule} from '@angular/core';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {CdkTableModule} from '@angular/cdk/table';

import 'hammerjs';
import { MaterialModule } from './app/material/material.module';

import { AppModule } from './app/app.module';
import { environment } from './environments/environment';


platformBrowserDynamic().bootstrapModule(AppModule)
  .catch(err => console.log(err));
