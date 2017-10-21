
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

    POST(fn) {
        $.ajax({
            url: this.Builder.ToString(),
            type: 'POST',
            dataType: 'json',
            success: function (data) {
                this.ResponseContent = data;
                if (fn != null) {
                    fn(data);
                }
            }
        })
    };

    PUT(fn) {
        $.ajax({
            url: this.Builder.ToString(),
            type: 'PUT',
            dataType: 'json',
            success: function (data) {
                this.ResponseContent = data;
                if (fn != null) {
                    fn(data);
                }
            }
        })
    };

    PATCH(fn) {
        $.ajax({
            url: this.Builder.ToString(),
            type: 'PATCH',
            dataType: 'json',
            success: function (data) {
                this.ResponseContent = data;
                if (fn != null) {
                    fn(data);
                }
            }
        })
    };

    DELETE(fn) {
        $.ajax({
            url: this.Builder.ToString(),
            type: 'DELETE',
            dataType: 'json',
            success: function (data) {
                this.ResponseContent = data;
                if (fn != null) {
                    fn(data);
                }
            }
        })
    };


};

