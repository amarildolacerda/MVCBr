webpackJsonp(["main"],{

/***/ "../../../../../src/$$_lazy_route_resource lazy recursive":
/***/ (function(module, exports) {

function webpackEmptyAsyncContext(req) {
	// Here Promise.resolve().then() is used instead of new Promise() to prevent
	// uncatched exception popping up in devtools
	return Promise.resolve().then(function() {
		throw new Error("Cannot find module '" + req + "'.");
	});
}
webpackEmptyAsyncContext.keys = function() { return []; };
webpackEmptyAsyncContext.resolve = webpackEmptyAsyncContext;
module.exports = webpackEmptyAsyncContext;
webpackEmptyAsyncContext.id = "../../../../../src/$$_lazy_route_resource lazy recursive";

/***/ }),

/***/ "../../../../../src/app/app.component.css":
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__("../../../../css-loader/lib/css-base.js")(false);
// imports


// module
exports.push([module.i, "", ""]);

// exports


/*** EXPORTS FROM exports-loader ***/
module.exports = module.exports.toString();

/***/ }),

/***/ "../../../../../src/app/app.component.html":
/***/ (function(module, exports) {

module.exports = "\n<app-header></app-header>\n\n<router-outlet></router-outlet>\n\n<app-footer></app-footer>\n  \n"

/***/ }),

/***/ "../../../../../src/app/app.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return AppComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};

var AppComponent = (function () {
    function AppComponent() {
        this.title = 'app';
    }
    AppComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-root',
            template: __webpack_require__("../../../../../src/app/app.component.html"),
            styles: [__webpack_require__("../../../../../src/app/app.component.css")]
        })
    ], AppComponent);
    return AppComponent;
}());



/***/ }),

/***/ "../../../../../src/app/app.module.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return AppModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_platform_browser__ = __webpack_require__("../../../platform-browser/esm5/platform-browser.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_forms__ = __webpack_require__("../../../forms/esm5/forms.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__services_globals_service__ = __webpack_require__("../../../../../src/app/services/globals.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__angular_platform_browser_animations__ = __webpack_require__("../../../platform-browser/esm5/animations.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__material_material_module__ = __webpack_require__("../../../../../src/app/material/material.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__views_views_module__ = __webpack_require__("../../../../../src/app/views/views.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_7__menu_menu_module__ = __webpack_require__("../../../../../src/app/menu/menu.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_8__services_services_module__ = __webpack_require__("../../../../../src/app/services/services.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_9__router_module__ = __webpack_require__("../../../../../src/app/router.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_10__app_component__ = __webpack_require__("../../../../../src/app/app.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_11__internal_internal_module__ = __webpack_require__("../../../../../src/app/internal/internal.module.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};












var AppModule = (function () {
    function AppModule() {
    }
    AppModule = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_1__angular_core__["K" /* NgModule */])({
            declarations: [
                __WEBPACK_IMPORTED_MODULE_10__app_component__["a" /* AppComponent */],
            ],
            imports: [
                __WEBPACK_IMPORTED_MODULE_9__router_module__["a" /* AppRoutingModule */],
                __WEBPACK_IMPORTED_MODULE_0__angular_platform_browser__["a" /* BrowserModule */],
                __WEBPACK_IMPORTED_MODULE_4__angular_platform_browser_animations__["a" /* NoopAnimationsModule */],
                __WEBPACK_IMPORTED_MODULE_5__material_material_module__["a" /* MaterialModule */],
                __WEBPACK_IMPORTED_MODULE_6__views_views_module__["a" /* ViewsModule */],
                __WEBPACK_IMPORTED_MODULE_7__menu_menu_module__["a" /* MenuModule */],
                __WEBPACK_IMPORTED_MODULE_8__services_services_module__["a" /* ServicesModule */],
                __WEBPACK_IMPORTED_MODULE_11__internal_internal_module__["a" /* InternalModule */],
                __WEBPACK_IMPORTED_MODULE_2__angular_forms__["d" /* FormsModule */],
                __WEBPACK_IMPORTED_MODULE_2__angular_forms__["i" /* ReactiveFormsModule */]
            ],
            providers: [
                __WEBPACK_IMPORTED_MODULE_3__services_globals_service__["a" /* GlobalsService */],
                {
                    provide: __WEBPACK_IMPORTED_MODULE_1__angular_core__["d" /* APP_INITIALIZER */],
                    useFactory: function (ds) { return function () { return ds.load(); }; },
                    deps: [__WEBPACK_IMPORTED_MODULE_3__services_globals_service__["a" /* GlobalsService */]],
                    multi: true
                },
            ],
            exports: [
                __WEBPACK_IMPORTED_MODULE_5__material_material_module__["a" /* MaterialModule */],
                __WEBPACK_IMPORTED_MODULE_8__services_services_module__["a" /* ServicesModule */]
            ],
            bootstrap: [__WEBPACK_IMPORTED_MODULE_10__app_component__["a" /* AppComponent */]]
        })
    ], AppModule);
    return AppModule;
}());



/***/ }),

/***/ "../../../../../src/app/internal/describe/describe.component.css":
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__("../../../../css-loader/lib/css-base.js")(false);
// imports


// module
exports.push([module.i, "", ""]);

// exports


/*** EXPORTS FROM exports-loader ***/
module.exports = module.exports.toString();

/***/ }),

/***/ "../../../../../src/app/internal/describe/describe.component.html":
/***/ (function(module, exports) {

module.exports = "<p>\n  describe works!\n</p>\n"

/***/ }),

/***/ "../../../../../src/app/internal/describe/describe.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return InternalDescribeComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var InternalDescribeComponent = (function () {
    function InternalDescribeComponent() {
    }
    InternalDescribeComponent.prototype.ngOnInit = function () {
    };
    InternalDescribeComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-internal-describe',
            template: __webpack_require__("../../../../../src/app/internal/describe/describe.component.html"),
            styles: [__webpack_require__("../../../../../src/app/internal/describe/describe.component.css")]
        }),
        __metadata("design:paramtypes", [])
    ], InternalDescribeComponent);
    return InternalDescribeComponent;
}());



/***/ }),

/***/ "../../../../../src/app/internal/internal.module.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return InternalModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1_angular_tree_component__ = __webpack_require__("../../../../angular-tree-component/dist/angular-tree-component.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_common__ = __webpack_require__("../../../common/esm5/common.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__metadata_metadata_component__ = __webpack_require__("../../../../../src/app/internal/metadata/metadata.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__describe_describe_component__ = __webpack_require__("../../../../../src/app/internal/describe/describe.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__services_services_module__ = __webpack_require__("../../../../../src/app/services/services.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__internal_router__ = __webpack_require__("../../../../../src/app/internal/internal.router.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_7__material_material_module__ = __webpack_require__("../../../../../src/app/material/material.module.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};



//import { InternalServicesComponent } from './services/services.component';





var InternalModule = (function () {
    function InternalModule() {
    }
    InternalModule = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["K" /* NgModule */])({
            imports: [
                __WEBPACK_IMPORTED_MODULE_2__angular_common__["b" /* CommonModule */],
                __WEBPACK_IMPORTED_MODULE_5__services_services_module__["a" /* ServicesModule */],
                __WEBPACK_IMPORTED_MODULE_6__internal_router__["a" /* InternalRoutesModule */],
                __WEBPACK_IMPORTED_MODULE_7__material_material_module__["a" /* MaterialModule */],
                __WEBPACK_IMPORTED_MODULE_1_angular_tree_component__["a" /* TreeModule */]
            ],
            declarations: [
                __WEBPACK_IMPORTED_MODULE_3__metadata_metadata_component__["a" /* InternalMetadataComponent */],
                __WEBPACK_IMPORTED_MODULE_4__describe_describe_component__["a" /* InternalDescribeComponent */]
            ],
            exports: [
                __WEBPACK_IMPORTED_MODULE_3__metadata_metadata_component__["a" /* InternalMetadataComponent */],
                __WEBPACK_IMPORTED_MODULE_4__describe_describe_component__["a" /* InternalDescribeComponent */]
            ]
        })
    ], InternalModule);
    return InternalModule;
}());



/***/ }),

/***/ "../../../../../src/app/internal/internal.router.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return InternalRoutesModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_router__ = __webpack_require__("../../../router/esm5/router.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__metadata_metadata_component__ = __webpack_require__("../../../../../src/app/internal/metadata/metadata.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__describe_describe_component__ = __webpack_require__("../../../../../src/app/internal/describe/describe.component.ts");


//import { InternalServicesComponent } from './services/services.component';

var internalRoutes = [
    { path: "internal.metadata", component: __WEBPACK_IMPORTED_MODULE_1__metadata_metadata_component__["a" /* InternalMetadataComponent */] },
    // { path: "internal.services", component: InternalServicesComponent },
    { path: "internal.describe", component: __WEBPACK_IMPORTED_MODULE_2__describe_describe_component__["a" /* InternalDescribeComponent */] }
];
var InternalRoutesModule = __WEBPACK_IMPORTED_MODULE_0__angular_router__["a" /* RouterModule */].forChild(internalRoutes);


/***/ }),

/***/ "../../../../../src/app/internal/metadata/metadata.component.css":
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__("../../../../css-loader/lib/css-base.js")(false);
// imports


// module
exports.push([module.i, "", ""]);

// exports


/*** EXPORTS FROM exports-loader ***/
module.exports = module.exports.toString();

/***/ }),

/***/ "../../../../../src/app/internal/metadata/metadata.component.html":
/***/ (function(module, exports) {

module.exports = "<mat-card>\n  <mat-card-header>\n    <div mat-card-avatar><mat-icon>hearing</mat-icon></div>\n    <mat-card-title>ODataBr metadata</mat-card-title>\n    <mat-card-subtitle>{{comment}}</mat-card-subtitle>\n  </mat-card-header>\n  <mat-card-content>\n\n\n<mat-table #table [dataSource]=\"dataSource\">\n  <ng-container cdkColumnDef=\"resource\">\n    <mat-header-cell *cdkHeaderCellDef> Resource </mat-header-cell>\n    <mat-cell *cdkCellDef=\"let row\"> \n    <a href=\"{{getLink(row.resource)}}\" target=\"_blank\">  {{row.resource}} </a>\n    </mat-cell>\n  </ng-container>\n\n  <ng-container cdkColumnDef=\"method\">\n      <mat-header-cell *cdkHeaderCellDef> Method </mat-header-cell>\n      <mat-cell *cdkCellDef=\"let row\"> {{row.method}} </mat-cell>\n    </ng-container>\n  <ng-container cdkColumnDef=\"keyID\">\n    <mat-header-cell *cdkHeaderCellDef> KeyID </mat-header-cell>\n    <mat-cell *cdkCellDef=\"let row\"> {{row.keyID}} </mat-cell>\n  </ng-container>\n\n<ng-container cdkColumnDef=\"fields\">\n  <mat-header-cell *cdkHeaderCellDef> Fields </mat-header-cell>\n  <mat-cell *cdkCellDef=\"let row\"> {{row.fields}} </mat-cell>\n</ng-container>\n  <mat-header-row *matHeaderRowDef=\"displayedColumns\"></mat-header-row>\n  <mat-row *matRowDef=\"let row; columns: displayedColumns;\"></mat-row>\n</mat-table>\n\n</mat-card-content>\n</mat-card>\n"

/***/ }),

/***/ "../../../../../src/app/internal/metadata/metadata.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return InternalMetadataComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__services_odatabr_admin_service__ = __webpack_require__("../../../../../src/app/services/odatabr-admin.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_material__ = __webpack_require__("../../../material/esm5/material.es5.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};



var InternalMetadataComponent = (function () {
    function InternalMetadataComponent(rest) {
        this.rest = rest;
        this.nodes = [];
        this.context = "";
        this.comment = "";
        this.supports = {
            '$filter': 'yes',
            '$format': 'yes',
            '$inlinecount': 'yes',
            '$orderby': 'yes',
            '$select': 'yes',
            '$skip': 'yes',
            '$top': 'yes',
            '$groupby': 'yes',
        };
        this.displayedColumns = ['resource', 'method', 'keyID', 'fields'];
        this.dataSource = new __WEBPACK_IMPORTED_MODULE_2__angular_material__["B" /* MatTableDataSource */]([{ resource: "" }]);
    }
    InternalMetadataComponent.prototype.getLink = function (resource) {
        return this.rest.gerResourceLink(resource) + '&$top=10';
    };
    InternalMetadataComponent.prototype.ngOnInit = function () {
        var _this = this;
        this.rest.init(function (x) {
            _this.rest.odata_metadata().subscribe(function (rsp) {
                for (var it in rsp) {
                    switch (it) {
                        case 'OData.Services': {
                            _this.dataSource = new __WEBPACK_IMPORTED_MODULE_2__angular_material__["B" /* MatTableDataSource */](rsp[it]);
                            break;
                        }
                        case '__comment': {
                            _this.comment = rsp[it];
                        }
                    }
                }
                //this.nodes = rsp;
                console.log(rsp);
                console.log(_this.nodes);
            });
        });
    };
    InternalMetadataComponent.prototype.getItem = function (item) {
        return JSON.stringify(item);
    };
    InternalMetadataComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-internal-metadata',
            template: __webpack_require__("../../../../../src/app/internal/metadata/metadata.component.html"),
            styles: [__webpack_require__("../../../../../src/app/internal/metadata/metadata.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__services_odatabr_admin_service__["a" /* ODataBrAdminService */]])
    ], InternalMetadataComponent);
    return InternalMetadataComponent;
}());



/***/ }),

/***/ "../../../../../src/app/material/material.module.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return MaterialModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_cdk_table__ = __webpack_require__("../../../cdk/esm5/table.es5.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_forms__ = __webpack_require__("../../../forms/esm5/forms.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__angular_material__ = __webpack_require__("../../../material/esm5/material.es5.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};




var MaterialModule = (function () {
    function MaterialModule() {
    }
    MaterialModule = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["K" /* NgModule */])({
            imports: [
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["b" /* MatButtonModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["n" /* MatMenuModule */],
            ],
            exports: [__WEBPACK_IMPORTED_MODULE_1__angular_cdk_table__["m" /* CdkTableModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["a" /* MatAutocompleteModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["b" /* MatButtonModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["c" /* MatButtonToggleModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["d" /* MatCardModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["e" /* MatCheckboxModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["f" /* MatChipsModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["A" /* MatStepperModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["g" /* MatDatepickerModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["h" /* MatDialogModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["i" /* MatExpansionModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["j" /* MatGridListModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["k" /* MatIconModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["l" /* MatInputModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["m" /* MatListModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["n" /* MatMenuModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["o" /* MatNativeDateModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["p" /* MatPaginatorModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["q" /* MatProgressBarModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["r" /* MatProgressSpinnerModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["s" /* MatRadioModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["t" /* MatRippleModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["u" /* MatSelectModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["v" /* MatSidenavModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["x" /* MatSliderModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["w" /* MatSlideToggleModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["y" /* MatSnackBarModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["z" /* MatSortModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["C" /* MatTableModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["D" /* MatTabsModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["E" /* MatToolbarModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_material__["F" /* MatTooltipModule */],
            ],
            providers: [
                __WEBPACK_IMPORTED_MODULE_2__angular_forms__["d" /* FormsModule */],
                __WEBPACK_IMPORTED_MODULE_2__angular_forms__["b" /* FormBuilder */]
            ]
        })
    ], MaterialModule);
    return MaterialModule;
}());



/***/ }),

/***/ "../../../../../src/app/menu/footer/footer.component.css":
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__("../../../../css-loader/lib/css-base.js")(false);
// imports


// module
exports.push([module.i, "", ""]);

// exports


/*** EXPORTS FROM exports-loader ***/
module.exports = module.exports.toString();

/***/ }),

/***/ "../../../../../src/app/menu/footer/footer.component.html":
/***/ (function(module, exports) {

module.exports = "<footer>\n  <mat-toolbar color=\"basic\">\n    <span class=\"block-right\"></span>\n    <span><a mat-button href=\"http://tireideletra.com.br?cat=149\">tirei de letra</a></span>\n  </mat-toolbar>\n  \n</footer>\n"

/***/ }),

/***/ "../../../../../src/app/menu/footer/footer.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return FooterComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var FooterComponent = (function () {
    function FooterComponent() {
    }
    FooterComponent.prototype.ngOnInit = function () {
    };
    FooterComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-footer',
            template: __webpack_require__("../../../../../src/app/menu/footer/footer.component.html"),
            styles: [__webpack_require__("../../../../../src/app/menu/footer/footer.component.css")]
        }),
        __metadata("design:paramtypes", [])
    ], FooterComponent);
    return FooterComponent;
}());



/***/ }),

/***/ "../../../../../src/app/menu/header/header.component.css":
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__("../../../../css-loader/lib/css-base.js")(false);
// imports


// module
exports.push([module.i, "", ""]);

// exports


/*** EXPORTS FROM exports-loader ***/
module.exports = module.exports.toString();

/***/ }),

/***/ "../../../../../src/app/menu/header/header.component.html":
/***/ (function(module, exports) {

module.exports = "<mat-toolbar>\n    <button mat-button routerLink='/'><mat-icon>home</mat-icon> ODataBr - Admin </button>\n    <span class=\"block-right\" ></span>\n    <button mat-button    [routerLink]=\"['/sobre']\" >Sobre</button>\n    <button mat-button > <mat-icon>apps</mat-icon>  </button>\n  </mat-toolbar>"

/***/ }),

/***/ "../../../../../src/app/menu/header/header.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return HeaderComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var HeaderComponent = (function () {
    function HeaderComponent() {
    }
    HeaderComponent.prototype.ngOnInit = function () {
    };
    HeaderComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-header',
            template: __webpack_require__("../../../../../src/app/menu/header/header.component.html"),
            styles: [__webpack_require__("../../../../../src/app/menu/header/header.component.css")]
        }),
        __metadata("design:paramtypes", [])
    ], HeaderComponent);
    return HeaderComponent;
}());



/***/ }),

/***/ "../../../../../src/app/menu/left/left.component.css":
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__("../../../../css-loader/lib/css-base.js")(false);
// imports


// module
exports.push([module.i, "", ""]);

// exports


/*** EXPORTS FROM exports-loader ***/
module.exports = module.exports.toString();

/***/ }),

/***/ "../../../../../src/app/menu/left/left.component.html":
/***/ (function(module, exports) {

module.exports = "<p>\n  left works!\n</p>\n"

/***/ }),

/***/ "../../../../../src/app/menu/left/left.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return LeftComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var LeftComponent = (function () {
    function LeftComponent() {
    }
    LeftComponent.prototype.ngOnInit = function () {
    };
    LeftComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-left',
            template: __webpack_require__("../../../../../src/app/menu/left/left.component.html"),
            styles: [__webpack_require__("../../../../../src/app/menu/left/left.component.css")]
        }),
        __metadata("design:paramtypes", [])
    ], LeftComponent);
    return LeftComponent;
}());



/***/ }),

/***/ "../../../../../src/app/menu/menu.module.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return MenuModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_common__ = __webpack_require__("../../../common/esm5/common.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__material_material_module__ = __webpack_require__("../../../../../src/app/material/material.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__header_header_component__ = __webpack_require__("../../../../../src/app/menu/header/header.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__footer_footer_component__ = __webpack_require__("../../../../../src/app/menu/footer/footer.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__left_left_component__ = __webpack_require__("../../../../../src/app/menu/left/left.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__router_module__ = __webpack_require__("../../../../../src/app/router.module.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};







var MenuModule = (function () {
    function MenuModule() {
    }
    MenuModule = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["K" /* NgModule */])({
            imports: [
                __WEBPACK_IMPORTED_MODULE_1__angular_common__["b" /* CommonModule */],
                __WEBPACK_IMPORTED_MODULE_2__material_material_module__["a" /* MaterialModule */],
                __WEBPACK_IMPORTED_MODULE_6__router_module__["a" /* AppRoutingModule */]
            ],
            declarations: [
                __WEBPACK_IMPORTED_MODULE_3__header_header_component__["a" /* HeaderComponent */],
                __WEBPACK_IMPORTED_MODULE_4__footer_footer_component__["a" /* FooterComponent */],
                __WEBPACK_IMPORTED_MODULE_5__left_left_component__["a" /* LeftComponent */]
            ],
            exports: [
                __WEBPACK_IMPORTED_MODULE_3__header_header_component__["a" /* HeaderComponent */],
                __WEBPACK_IMPORTED_MODULE_4__footer_footer_component__["a" /* FooterComponent */],
                __WEBPACK_IMPORTED_MODULE_5__left_left_component__["a" /* LeftComponent */],
            ]
        })
    ], MenuModule);
    return MenuModule;
}());



/***/ }),

/***/ "../../../../../src/app/router.module.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return AppRoutingModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_router__ = __webpack_require__("../../../router/esm5/router.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__views_principal_principal_component__ = __webpack_require__("../../../../../src/app/views/principal/principal.component.ts");


var routesPrincipal = [
    { path: '', component: __WEBPACK_IMPORTED_MODULE_1__views_principal_principal_component__["a" /* PrincipalComponent */] },
];
var AppRoutingModule = __WEBPACK_IMPORTED_MODULE_0__angular_router__["a" /* RouterModule */].forRoot(routesPrincipal);


/***/ }),

/***/ "../../../../../src/app/services/globals.service.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return GlobalsService; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_common_http__ = __webpack_require__("../../../common/esm5/http.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
///
/// Carrega configuraçoes do arquivo config.json
/// amarildo lacerda - tireideletra.com.br
///


var GlobalsService = (function () {
    function GlobalsService(http) {
        this.http = http;
        this.config = { loaded: false };
        this.server = [];
    }
    GlobalsService.prototype.ngOnInit = function () {
        //Called after the constructor, initializing input properties, and the first call to ngOnChanges.
        //Add 'implements OnInit' to the class.
    };
    GlobalsService.prototype.subscribe = function (proc) {
        var _this = this;
        if (this.config.loaded == false) {
            this.observable = this.http.get('./assets/config.json');
            var resp = this.observable.subscribe(function (r) {
                _this.config = r;
                _this.config.loaded = true;
                _this.server = r.server;
                console.log('Resp: ' + JSON.stringify(r));
                proc(_this);
            });
        }
        else {
            console.log('Reaproveitou config anterior');
            proc(this);
        }
    };
    GlobalsService.prototype.load = function () {
        // chamado na carga do app
        if (this.config.loaded == false) {
            this.subscribe(function (r) { console.log('Loaded config'); });
        }
    };
    GlobalsService = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["C" /* Injectable */])(),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__angular_common_http__["a" /* HttpClient */]])
    ], GlobalsService);
    return GlobalsService;
}());



/***/ }),

/***/ "../../../../../src/app/services/odata-provider.service.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* unused harmony export ODataFactory */
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return ODataProviderService; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_common_http__ = __webpack_require__("../../../common/esm5/http.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
// <summary>
//  ODataBr Provider
//  Auth: amarildo lacerda - tireideletra.com.br
// </summary>


var ODataFactory = (function () {
    function ODataFactory(resource, select, filter, groupBy, orderBy) {
        this.resource = resource;
        this.select = select;
        this.filter = filter;
        this.groupBy = groupBy;
        this.orderBy = orderBy;
    }
    ODataFactory.createFinalStr = function (ref) {
        var rt = "";
        rt += ((ref.select) ? "&$select=" + ref.select.join(",") : "");
        rt += ((ref.count) ? "&count=1" : "");
        rt += ((ref.top) ? "&$top=" + ref.top.toFixed(0) : "");
        rt += ((ref.skip) ? "&$skip=" + ref.skip.toFixed(0) : "");
        rt += ((ref.filter) ? "&$filter=" + ref.filter : "");
        rt += ((ref.groupBy) ? "&groupby=" + ref.groupBy.join(',') : "");
        rt += ((ref.orderBy) ? "&orderby=" + ref.orderBy.join(",") : "");
        return rt;
    };
    /// create URL for ODataBr
    ODataFactory.createServicePath = function (collection, rootService) {
        if (rootService === void 0) { rootService = '/OData/OData.svc/'; }
        return rootService + collection;
    };
    return ODataFactory;
}());

var ODataProviderService = (function () {
    function ODataProviderService(http) {
        this.http = http;
        this.root = "/OData/OData.svc/";
        this.token = "";
        this.count = 0;
        this.top = 0;
        this.properties = {};
        this.createUrlBase('', 0);
        this.headers = new __WEBPACK_IMPORTED_MODULE_1__angular_common_http__["d" /* HttpHeaders */]();
        this.headers.append('Content-Type', 'application/json; charset=UTF-8');
    }
    ODataProviderService.prototype.getObservable = function () {
        return this.observable;
    };
    ODataProviderService.prototype.createUrlBase = function (base, port) {
        if (port == null)
            console.log("não passou a porta do servidor");
        var lport = port.toFixed(0);
        if (port == 0) {
            lport = window.location.port;
        }
        var url = "";
        if (base != "") {
            url = base;
        }
        else {
            var loc = window.location;
            url = loc.protocol + '//' + loc.hostname + ':' + lport;
        }
        this.base_url = url;
        console.log('Server base_url: ' + url);
        return url;
    };
    ODataProviderService.prototype.getOptions = function () {
        this.count = 0;
        return { headers: this.headers };
    };
    ODataProviderService.prototype.getUrl = function (collection, aParam) {
        if (aParam === void 0) { aParam = ""; }
        var p = (aParam != "" ? "&" + aParam : "");
        return this.base_url + ODataFactory.createServicePath(collection, this.root) +
            '?token=' + this.token + p;
    };
    ODataProviderService.prototype.getUrlBase = function (url, aParam) {
        if (aParam === void 0) { aParam = ""; }
        var p = (aParam != "" ? "&" + aParam : "");
        return this.base_url + url +
            '?token=' + this.token + p;
    };
    ODataProviderService.prototype.query = function (qry) {
        this.getValue(qry);
        return this;
    };
    ODataProviderService.prototype.fillResponse = function (rsp) {
        for (var it in rsp) {
            switch (it) {
                case '@odata.count': {
                    this.count = rsp[it];
                    break;
                }
                case 'keys': {
                    this.keys = rsp[it];
                    break;
                }
                case 'properties': {
                    this.properties = rsp[it];
                    break;
                }
                case "@odata.top": {
                    this.top = rsp[it];
                    break;
                }
                case "StartsAt": {
                    this.startsAt = rsp[it];
                    break;
                }
                case "EndsAt": {
                    this.endsAt = rsp[it];
                    break;
                }
            }
        }
    };
    /// async call
    ODataProviderService.prototype.subscribe = function (proc, erroProc) {
        var _this = this;
        if (erroProc === void 0) { erroProc = null; }
        this.observable.subscribe(function (rsp) {
            _this.fillResponse(rsp);
            var r = rsp.value;
            proc(r);
        }, function (err) {
            if (erroProc != null) {
                erroProc(err.error);
            }
            else {
                console.log(err);
                // throw new TypeError(err.error.error);
            }
        });
    };
    // prepare for async call
    // ordinary call for ODataBr, expect OData response from server
    ODataProviderService.prototype.getValue = function (query) {
        try {
            this.observable = this.http.request('GET', this.getUrl(query.resource) +
                ODataFactory.createFinalStr(query), this.getOptions());
            if (this.observable == null) {
                throw new TypeError("Não criou uma conexão com o servidor Query: " + query);
            }
        }
        catch (e) {
            alert(e.message);
        }
        return this;
    };
    // get from generic URL... 
    // No regular path, but its OData reponse
    ODataProviderService.prototype.getOData = function (url) {
        var path = url + '?token=' + this.token;
        this.observable = this.getJson(path);
        return this;
    };
    /// call generic resource on the server - 
    //  get for all needs - 
    //  no format url
    //  no OData Response
    ODataProviderService.prototype.getJson = function (url) {
        return this.http.get(this.getUrlBase(url), this.getOptions());
    };
    // generic ordinary GET method
    ODataProviderService.prototype.getReponse = function (query) {
        this.observable = this.http.request('GET', this.getUrl(query.resource) +
            ODataFactory.createFinalStr(query), this.getOptions());
        return this.observable;
    };
    // PUT method
    ODataProviderService.prototype.putItem = function (collection, item, erroProc) {
        var _this = this;
        if (erroProc === void 0) { erroProc = null; }
        /// enviar item para o servidor.
        this.observable = this.http.put(this.getUrl(collection), JSON.stringify(item), this.getOptions())
            .map(function (res) { return res; });
        if (erroProc != null)
            this.subscribe(function (rsp) { _this.response = rsp; }, function (err) {
                console.log(err);
                erroProc(err.message);
            });
        return this.observable;
    };
    ODataProviderService.prototype.putData = function (url, param, body) {
        if (param === void 0) { param = ""; }
        if (body === void 0) { body = null; }
        return this.http.put(this.getUrlBase(url, param), body, this.getOptions());
    };
    // POST method
    ODataProviderService.prototype.postItem = function (collection, item, erroProc) {
        var _this = this;
        if (erroProc === void 0) { erroProc = null; }
        /// enviar item para o servidor.
        this.observable = this.http.post(this.getUrl(collection), JSON.stringify(item), this.getOptions()).map(function (res) { return res; });
        if (erroProc != null)
            this.subscribe(function (rsp) { _this.response = rsp; }, function (err) {
                console.log(err);
                erroProc(err.message);
            });
        return this.observable;
    };
    ODataProviderService.prototype.postData = function (url, param, body) {
        if (param === void 0) { param = ""; }
        if (body === void 0) { body = null; }
        return this.http.post(this.getUrlBase(url, param), body, this.getOptions());
    };
    // PATCH method
    ODataProviderService.prototype.patchItem = function (collection, item, erroProc) {
        var _this = this;
        if (erroProc === void 0) { erroProc = null; }
        /// enviar item para o servidor.
        /// o comando put = patch o mvcbr.odata; os browsers mantem restrição para uso do patch.
        var options = this.getOptions();
        //options.headers.append('Access-Control-Allow-Headers','PATCH');
        //console.log(item);
        this.observable = this.http.put(this.getUrl(collection), JSON.stringify(item), options).map(function (res) { return res; });
        if (erroProc != null)
            this.subscribe(function (rsp) { _this.response = rsp; }, function (err) {
                console.log(err);
                erroProc(err.message);
            });
        return this.observable;
    };
    ODataProviderService.prototype.patchData = function (url, param, item) {
        if (param === void 0) { param = ""; }
        if (item === void 0) { item = null; }
        return this.http.patch(this.getUrlBase(url, param), item, this.getOptions());
    };
    // DELETE method
    ODataProviderService.prototype.deleteItem = function (collection, params, erroProc) {
        var _this = this;
        if (erroProc === void 0) { erroProc = null; }
        /// enviar item para o servidor.
        this.observable = this.http.delete(this.getUrl(collection, params), this.getOptions()).map(function (res) { return res; });
        if (erroProc != null)
            this.subscribe(function (rsp) { _this.response = rsp; }, function (err) {
                console.log(err);
                erroProc(err.message);
            });
        return this.observable;
    };
    ODataProviderService.prototype.deleteData = function (url, param) {
        if (param === void 0) { param = ""; }
        return this.http.delete(this.getUrlBase(url, param), this.getOptions());
    };
    ODataProviderService = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["C" /* Injectable */])(),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__angular_common_http__["a" /* HttpClient */]])
    ], ODataProviderService);
    return ODataProviderService;
}());



/***/ }),

/***/ "../../../../../src/app/services/odatabr-admin.service.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return ODataBrAdminService; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__odata_provider_service__ = __webpack_require__("../../../../../src/app/services/odata-provider.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__globals_service__ = __webpack_require__("../../../../../src/app/services/globals.service.ts");
///
/// acesso ao serviço de admin
/// amarildo lacerda - tireideletra.com.br
///
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};



var ODataBrAdminService = (function () {
    function ODataBrAdminService(rest, globals) {
        this.rest = rest;
        this.globals = globals;
        globals.subscribe(function (r) {
            rest.createUrlBase(globals.server.url, globals.server.port);
        });
    }
    ODataBrAdminService.prototype.init = function (proc) {
        var _this = this;
        this.globals.subscribe(function (r) {
            _this.rest.createUrlBase(_this.globals.server.url, _this.globals.server.port);
            proc(r);
        });
    };
    ODataBrAdminService.prototype.gerResourceLink = function (resource) {
        return this.rest.getUrl(resource);
    };
    ODataBrAdminService.prototype.subscribe = function (proc) {
        this.observable.subscribe(function (r) { proc(r); });
    };
    ODataBrAdminService.prototype.get_token_new = function () {
        this.observable = this.rest.getOData('/OData/admin/token/new');
        return this;
    };
    ODataBrAdminService.prototype.addUser = function (token, nome, secret, group) {
        return this.rest.putData("/OData/admin/token/" + token + "/" + nome + "/" + secret + "/" + group);
    };
    ODataBrAdminService.prototype.odata_services = function () {
        return this.rest.getJson('/OData');
    };
    ODataBrAdminService.prototype.odata_metadata = function () {
        return this.rest.getJson('/OData/$metadata');
    };
    ODataBrAdminService.prototype.describe_server = function () {
        return this.rest.getJson('/system/describeserver.info');
    };
    ODataBrAdminService = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["C" /* Injectable */])(),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__odata_provider_service__["a" /* ODataProviderService */], __WEBPACK_IMPORTED_MODULE_2__globals_service__["a" /* GlobalsService */]])
    ], ODataBrAdminService);
    return ODataBrAdminService;
}());



/***/ }),

/***/ "../../../../../src/app/services/services.module.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return ServicesModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_common__ = __webpack_require__("../../../common/esm5/common.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_common_http__ = __webpack_require__("../../../common/esm5/http.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__odata_provider_service__ = __webpack_require__("../../../../../src/app/services/odata-provider.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__odatabr_admin_service__ = __webpack_require__("../../../../../src/app/services/odatabr-admin.service.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
///
/// modulos de serviços
/// amarildo lacerda - tireideletra.com.br
///





var ServicesModule = (function () {
    function ServicesModule() {
    }
    ServicesModule = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["K" /* NgModule */])({
            imports: [
                __WEBPACK_IMPORTED_MODULE_1__angular_common__["b" /* CommonModule */],
                __WEBPACK_IMPORTED_MODULE_2__angular_common_http__["c" /* HttpClientModule */], __WEBPACK_IMPORTED_MODULE_2__angular_common_http__["b" /* HttpClientJsonpModule */]
            ],
            declarations: [],
            providers: [
                __WEBPACK_IMPORTED_MODULE_3__odata_provider_service__["a" /* ODataProviderService */],
                __WEBPACK_IMPORTED_MODULE_4__odatabr_admin_service__["a" /* ODataBrAdminService */],
            ],
            exports: []
        })
    ], ServicesModule);
    return ServicesModule;
}());



/***/ }),

/***/ "../../../../../src/app/views/login/login.component.css":
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__("../../../../css-loader/lib/css-base.js")(false);
// imports


// module
exports.push([module.i, "", ""]);

// exports


/*** EXPORTS FROM exports-loader ***/
module.exports = module.exports.toString();

/***/ }),

/***/ "../../../../../src/app/views/login/login.component.html":
/***/ (function(module, exports) {

module.exports = "<form>\n  <input matInput placeholder=\"label\" value=\"value\">\n</form>"

/***/ }),

/***/ "../../../../../src/app/views/login/login.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return LoginComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var LoginComponent = (function () {
    function LoginComponent() {
    }
    LoginComponent.prototype.ngOnInit = function () {
    };
    LoginComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-login',
            template: __webpack_require__("../../../../../src/app/views/login/login.component.html"),
            styles: [__webpack_require__("../../../../../src/app/views/login/login.component.css")]
        }),
        __metadata("design:paramtypes", [])
    ], LoginComponent);
    return LoginComponent;
}());



/***/ }),

/***/ "../../../../../src/app/views/principal/principal.component.css":
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__("../../../../css-loader/lib/css-base.js")(false);
// imports


// module
exports.push([module.i, "", ""]);

// exports


/*** EXPORTS FROM exports-loader ***/
module.exports = module.exports.toString();

/***/ }),

/***/ "../../../../../src/app/views/principal/principal.component.html":
/***/ (function(module, exports) {

module.exports = "\n<mat-vertical-stepper>\n \n  <mat-step label=\"Server\">\n  </mat-step>\n\n  <mat-step label=\"Users\">\n     <app-users></app-users>\n  </mat-step>\n\n  <mat-step label=\"Services\">\n     <app-internal-metadata></app-internal-metadata>\n  </mat-step>\n  \n</mat-vertical-stepper>\n\n"

/***/ }),

/***/ "../../../../../src/app/views/principal/principal.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return PrincipalComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var PrincipalComponent = (function () {
    function PrincipalComponent() {
    }
    PrincipalComponent.prototype.ngOnInit = function () {
    };
    PrincipalComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-principal',
            template: __webpack_require__("../../../../../src/app/views/principal/principal.component.html"),
            styles: [__webpack_require__("../../../../../src/app/views/principal/principal.component.css")]
        }),
        __metadata("design:paramtypes", [])
    ], PrincipalComponent);
    return PrincipalComponent;
}());



/***/ }),

/***/ "../../../../../src/app/views/sobre/sobre.component.css":
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__("../../../../css-loader/lib/css-base.js")(false);
// imports


// module
exports.push([module.i, "", ""]);

// exports


/*** EXPORTS FROM exports-loader ***/
module.exports = module.exports.toString();

/***/ }),

/***/ "../../../../../src/app/views/sobre/sobre.component.html":
/***/ (function(module, exports) {

module.exports = "<mat-card >\n  <mat-card-header>\n    <mat-card-title>ODataBr Server</mat-card-title>\n    <mat-card-subtitle>Restful</mat-card-subtitle>\n  </mat-card-header>\n  <mat-card-content>\n      <a mat-button href=\"http://www.tireideletra.com.br/?cat=149\" target=\"_blank\" >Home: tireideletra.com.br</a><br>\n      <a mat-button href=\"https://github.com/amarildolacerda/ODataBr\" target=\"_blank\">Binaies</a> <br>\n      <a mat-button href=\"https://github.com/amarildolacerda/MVCBr\" target=\"_blank\">Sources</a>\n    </mat-card-content>\n  <mat-card-actions>\n    <a mat-button [routerLink]=\"['/home']\"><mat-icon>home</mat-icon></a>\n\n    \n  </mat-card-actions>\n</mat-card>"

/***/ }),

/***/ "../../../../../src/app/views/sobre/sobre.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return SobreComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var SobreComponent = (function () {
    function SobreComponent() {
    }
    SobreComponent.prototype.ngOnInit = function () {
    };
    SobreComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-sobre',
            template: __webpack_require__("../../../../../src/app/views/sobre/sobre.component.html"),
            styles: [__webpack_require__("../../../../../src/app/views/sobre/sobre.component.css")]
        }),
        __metadata("design:paramtypes", [])
    ], SobreComponent);
    return SobreComponent;
}());



/***/ }),

/***/ "../../../../../src/app/views/users/users.component.css":
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__("../../../../css-loader/lib/css-base.js")(false);
// imports


// module
exports.push([module.i, "", ""]);

// exports


/*** EXPORTS FROM exports-loader ***/
module.exports = module.exports.toString();

/***/ }),

/***/ "../../../../../src/app/views/users/users.component.html":
/***/ (function(module, exports) {

module.exports = "\r\n\r\n<div>Token: <button *ngIf=\"token==''\" mat-button  (click)=\"get_token_new()\" > ainda não tenho um token</button>  \r\n    {{token}}</div>\r\n\r\n    \r\n\r\n<form [formGroup]=\"formUsers\" (ngSubmit)=\"addUser(formUsers.value)\">\r\n   <mat-form-field>\r\n       <input matInput placeholder=\"User name\" formControlName=\"userName\" >\r\n   </mat-form-field>\r\n   <mat-form-field>\r\n       <input matInput placeholder=\"Secret\" formControlName=\"secret\">\r\n   </mat-form-field>\r\n   <mat-form-field>\r\n    <input matInput placeholder=\"Group\" formControlName=\"group\">\r\n   </mat-form-field>\r\n   <button mat-button type=\"submit\"\r\n    [disabled]=\"!formUsers.valid\" >Send</button>\r\n</form>\r\n"

/***/ }),

/***/ "../../../../../src/app/views/users/users.component.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return UsersComponent; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__services_odatabr_admin_service__ = __webpack_require__("../../../../../src/app/services/odatabr-admin.service.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_forms__ = __webpack_require__("../../../forms/esm5/forms.js");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};



var UsersComponent = (function () {
    function UsersComponent(admin, fb) {
        this.admin = admin;
        this.fb = fb;
        this.token = '';
        this.userName = '';
        this.secret = '';
        this.group = '';
    }
    UsersComponent.prototype.ngOnInit = function () {
        this.formUsers = this.fb.group({
            userName: [null, __WEBPACK_IMPORTED_MODULE_2__angular_forms__["j" /* Validators */].compose([__WEBPACK_IMPORTED_MODULE_2__angular_forms__["j" /* Validators */].required,
                    __WEBPACK_IMPORTED_MODULE_2__angular_forms__["j" /* Validators */].minLength(5),
                    __WEBPACK_IMPORTED_MODULE_2__angular_forms__["j" /* Validators */].maxLength(20)
                ])],
            group: [null, __WEBPACK_IMPORTED_MODULE_2__angular_forms__["j" /* Validators */].compose([__WEBPACK_IMPORTED_MODULE_2__angular_forms__["j" /* Validators */].required,
                    __WEBPACK_IMPORTED_MODULE_2__angular_forms__["j" /* Validators */].minLength(3)])],
            secret: [null, __WEBPACK_IMPORTED_MODULE_2__angular_forms__["j" /* Validators */].required],
        });
    };
    UsersComponent.prototype.get_token_new = function () {
        var _this = this;
        this.admin.get_token_new().subscribe(function (r) {
            _this.token = r[0].token;
            return _this.token;
        });
    };
    UsersComponent.prototype.addUser = function (post) {
        this.admin.addUser(this.token, post.userName, post.secret, post.group)
            .subscribe(function (r) {
            console.log(r);
        });
    };
    UsersComponent = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["n" /* Component */])({
            selector: 'app-users',
            template: __webpack_require__("../../../../../src/app/views/users/users.component.html"),
            styles: [__webpack_require__("../../../../../src/app/views/users/users.component.css")]
        }),
        __metadata("design:paramtypes", [__WEBPACK_IMPORTED_MODULE_1__services_odatabr_admin_service__["a" /* ODataBrAdminService */], __WEBPACK_IMPORTED_MODULE_2__angular_forms__["b" /* FormBuilder */]])
    ], UsersComponent);
    return UsersComponent;
}());



/***/ }),

/***/ "../../../../../src/app/views/views.module.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return ViewsModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__("../../../core/esm5/core.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_common__ = __webpack_require__("../../../common/esm5/common.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_forms__ = __webpack_require__("../../../forms/esm5/forms.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__router_module__ = __webpack_require__("../../../../../src/app/router.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__views_router__ = __webpack_require__("../../../../../src/app/views/views.router.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__users_users_component__ = __webpack_require__("../../../../../src/app/views/users/users.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__menu_menu_module__ = __webpack_require__("../../../../../src/app/menu/menu.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_7__services_services_module__ = __webpack_require__("../../../../../src/app/services/services.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_8__login_login_component__ = __webpack_require__("../../../../../src/app/views/login/login.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_9__principal_principal_component__ = __webpack_require__("../../../../../src/app/views/principal/principal.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_10__sobre_sobre_component__ = __webpack_require__("../../../../../src/app/views/sobre/sobre.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_11__material_material_module__ = __webpack_require__("../../../../../src/app/material/material.module.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_12__internal_internal_module__ = __webpack_require__("../../../../../src/app/internal/internal.module.ts");
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};













var ViewsModule = (function () {
    function ViewsModule() {
    }
    ViewsModule = __decorate([
        Object(__WEBPACK_IMPORTED_MODULE_0__angular_core__["K" /* NgModule */])({
            imports: [
                __WEBPACK_IMPORTED_MODULE_3__router_module__["a" /* AppRoutingModule */],
                __WEBPACK_IMPORTED_MODULE_4__views_router__["a" /* ViewsRoutesModule */],
                __WEBPACK_IMPORTED_MODULE_1__angular_common__["b" /* CommonModule */],
                __WEBPACK_IMPORTED_MODULE_6__menu_menu_module__["a" /* MenuModule */],
                __WEBPACK_IMPORTED_MODULE_7__services_services_module__["a" /* ServicesModule */],
                __WEBPACK_IMPORTED_MODULE_11__material_material_module__["a" /* MaterialModule */],
                __WEBPACK_IMPORTED_MODULE_12__internal_internal_module__["a" /* InternalModule */],
                __WEBPACK_IMPORTED_MODULE_2__angular_forms__["d" /* FormsModule */], __WEBPACK_IMPORTED_MODULE_2__angular_forms__["i" /* ReactiveFormsModule */]
            ],
            declarations: [
                __WEBPACK_IMPORTED_MODULE_5__users_users_component__["a" /* UsersComponent */],
                __WEBPACK_IMPORTED_MODULE_8__login_login_component__["a" /* LoginComponent */],
                __WEBPACK_IMPORTED_MODULE_9__principal_principal_component__["a" /* PrincipalComponent */],
                __WEBPACK_IMPORTED_MODULE_10__sobre_sobre_component__["a" /* SobreComponent */],
            ],
            exports: [
                __WEBPACK_IMPORTED_MODULE_5__users_users_component__["a" /* UsersComponent */]
            ]
        })
    ], ViewsModule);
    return ViewsModule;
}());



/***/ }),

/***/ "../../../../../src/app/views/views.router.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "a", function() { return ViewsRoutesModule; });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_router__ = __webpack_require__("../../../router/esm5/router.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__sobre_sobre_component__ = __webpack_require__("../../../../../src/app/views/sobre/sobre.component.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__users_users_component__ = __webpack_require__("../../../../../src/app/views/users/users.component.ts");



var viewsRoutes = [
    { path: 'sobre', component: __WEBPACK_IMPORTED_MODULE_1__sobre_sobre_component__["a" /* SobreComponent */] },
    { path: 'users', component: __WEBPACK_IMPORTED_MODULE_2__users_users_component__["a" /* UsersComponent */] }
];
var ViewsRoutesModule = __WEBPACK_IMPORTED_MODULE_0__angular_router__["a" /* RouterModule */].forChild(viewsRoutes);


/***/ }),

/***/ "../../../../../src/main.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__polyfills__ = __webpack_require__("../../../../../src/polyfills.ts");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_platform_browser_dynamic__ = __webpack_require__("../../../platform-browser-dynamic/esm5/platform-browser-dynamic.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_hammerjs__ = __webpack_require__("../../../../hammerjs/hammer.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_hammerjs___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2_hammerjs__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__app_app_module__ = __webpack_require__("../../../../../src/app/app.module.ts");




Object(__WEBPACK_IMPORTED_MODULE_1__angular_platform_browser_dynamic__["a" /* platformBrowserDynamic */])().bootstrapModule(__WEBPACK_IMPORTED_MODULE_3__app_app_module__["a" /* AppModule */])
    .catch(function (err) { return console.log(err); });


/***/ }),

/***/ "../../../../../src/polyfills.ts":
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
Object.defineProperty(__webpack_exports__, "__esModule", { value: true });
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_core_js_es7_reflect__ = __webpack_require__("../../../../core-js/es7/reflect.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_core_js_es7_reflect___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0_core_js_es7_reflect__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1_zone_js_dist_zone__ = __webpack_require__("../../../../zone.js/dist/zone.js");
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1_zone_js_dist_zone___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1_zone_js_dist_zone__);
/**
 * This file includes polyfills needed by Angular and is loaded before the app.
 * You can add your own extra polyfills to this file.
 *
 * This file is divided into 2 sections:
 *   1. Browser polyfills. These are applied before loading ZoneJS and are sorted by browsers.
 *   2. Application imports. Files imported after ZoneJS that should be loaded before your main
 *      file.
 *
 * The current setup is for so-called "evergreen" browsers; the last versions of browsers that
 * automatically update themselves. This includes Safari >= 10, Chrome >= 55 (including Opera),
 * Edge >= 13 on the desktop, and iOS 10 and Chrome on mobile.
 *
 * Learn more in https://angular.io/docs/ts/latest/guide/browser-support.html
 */
/***************************************************************************************************
 * BROWSER POLYFILLS
 */
/** IE9, IE10 and IE11 requires all of the following polyfills. **/
// import 'core-js/es6/symbol';
// import 'core-js/es6/object';
// import 'core-js/es6/function';
// import 'core-js/es6/parse-int';
// import 'core-js/es6/parse-float';
// import 'core-js/es6/number';
// import 'core-js/es6/math';
// import 'core-js/es6/string';
// import 'core-js/es6/date';
// import 'core-js/es6/array';
// import 'core-js/es6/regexp';
// import 'core-js/es6/map';
// import 'core-js/es6/weak-map';
// import 'core-js/es6/set';
/** IE10 and IE11 requires the following for NgClass support on SVG elements */
// import 'classlist.js';  // Run `npm install --save classlist.js`.
/** IE10 and IE11 requires the following for the Reflect API. */
// import 'core-js/es6/reflect';
/** Evergreen browsers require these. **/
// Used for reflect-metadata in JIT. If you use AOT (and only Angular decorators), you can remove.

/**
 * Required to support Web Animations `@angular/platform-browser/animations`.
 * Needed for: All but Chrome, Firefox and Opera. http://caniuse.com/#feat=web-animation
 **/
// import 'web-animations-js';  // Run `npm install --save web-animations-js`.
/***************************************************************************************************
 * Zone JS is required by Angular itself.
 */
 // Included with Angular CLI.
/***************************************************************************************************
 * APPLICATION IMPORTS
 */
/**
 * Date, currency, decimal and percent pipes.
 * Needed for: All but Chrome, Firefox, Edge, IE11 and Safari 10
 */
// import 'intl';  // Run `npm install --save intl`.
/**
 * Need to import at least one locale-data with intl.
 */
// import 'intl/locale-data/jsonp/en';


/***/ }),

/***/ 0:
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__("../../../../../src/main.ts");


/***/ })

},[0]);
//# sourceMappingURL=main.bundle.js.map