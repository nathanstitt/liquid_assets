this.LQT || (this.LQT = {});

LQT._FNS = {

    html: function (html) {
        return html.replace(/\\/g, '\\\\')
            .replace(/'/g, '\\\'')
            .replace(/"/g, '\\\"')
            .replace(/\r/g, '\\r')
            .replace(/\n/g, '\\n');
    },
    err: function (msg) {
        var html = '<pre style="font-family:Courier; font-weight:bold; \
font-size:14px; color:red; padding:4px 20px 4px 20px; border:1px solid #CCC; \
background-color:#FFF5F0; line-height:1.6em; white-space:pre-wrap; \
white-space:-moz-pre-wrap; white-space:-pre-wrap; white-space:-o-pre-wrap; \
word-wrap:break-word; z-index:9999">' + msg + '</pre>';
        return html;
    },
    rethrow: function (err, filename) {
        var msg = 'An error occurred while rendering\n' +
            'Line: ' + $_line_num + (filename ? '  File: ' + filename : '') +
            '\n    ' + err;
        $_buf += $_err(msg);
    },
    merge: function () {
        var ret = {};
        for (var i in arguments) {
            var obj = arguments[i];
            for (var j in obj) {
                ret[j] = obj[j];
            }
        }
        return ret;
    },
    range: function (s, e) {
        s = parseInt(s);
        e = parseInt(e);
        var r = [];
        if (isNaN(s) || isNaN(e)) return r;
        for (; s <= e; s++) {
            r.push(s);
        }
        return r;
    },
    array: function (data) {
        if (Array.isArray(data)) return data;
        var ret = [];
        for (var i in data) {
            if (i !== 'size') {
                ret.push(data[i]);
            }
        }
        return ret;
    }

}
