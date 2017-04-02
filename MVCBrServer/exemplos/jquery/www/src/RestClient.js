
class RestClient {
    constructor(AODataBuilder) {
        this.Builder = AODataBuilder;
        this.ResponseCode = 0;
        this.ResponseContent = "";
    }
    ResponseCode() {
        return this.ResponseCode;
    }
    Content() {
        return this.ResponseContent;
    }


    GET(fn) {
        this.ResponseCode = 0;
        $.ajax({
            url: this.Builder.ToString(),
            type: 'GET',
            dataType: 'json',
            success: function (data) {
                this.ResponseContent = data;
                if (fn != null) {
                    fn(data);
                }
            }
        });
    };


};

