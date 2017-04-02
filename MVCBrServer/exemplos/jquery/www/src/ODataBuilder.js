class ODataBuilder{

    constructor(AResource) {
        this.BaseURL = "http://localhost:8080",
        this.Service = "/OData.svc",
        this.ServicePrefix = "/OData",
        this.ResourceParams = "",
        this.Top = 0,
        this.Skip = 0,
        this.Select = "",
        this.OrderBy = "",
        this.Filter = "",
        this.Params = "";
        this.Resource = "/" + AResource;
    }
    
    formatParams() {
        var rt = "";
        if (this.ResourceParams == "") {
            return rt;
        }
        rt = rt + "(" + this.ResourceParams + ")";
    }


   BaseURI() {
        return this.BaseURL + this.ServicePrefix + this.Service;
    }

    ResourceParams(AParams) {
        this.ResourceParams = AParams;
    }

    addParams(prm) {
        if (this.Params != "") { this.Params += "&" };
        this.Params += prm;
    };

    URI() {
        var rt = this.Resource + this.formatParams();
        this.Params = "";
        if (this.Top > 0) this.addParams("$top=" + this.Top.ToString());
        if (this.Skip > 0) this.addParams("$skip=" + this.Skip.ToString());
        if (this.Select != "") this.addParams("$select=" + this.Select);
        if (this.Filter != "") this.addParams("$select=" + this.Filter);
        return rt + "?" + this.Params;
    };

    ToString() {
        return this.BaseURI() + this.URI();
    }
};


