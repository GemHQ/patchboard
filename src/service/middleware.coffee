utils = require("connect/lib/utils")
`
exports.json = function(options){
  options = options || {};
  return function json(req, res, next) {
    if (req._body) return next();
    req.body = req.body || {};

    // ignore GET
    if ('GET' == req.method || 'HEAD' == req.method) return next();

    // check Content-Type
    if ('application/json' != utils.mime(req)) return next();

    // flag as parsed
    req._body = true;

    // parse
    var buf = '';
    req.setEncoding('utf8');
    req.on('data', function(chunk){ buf += chunk });
    req.on('end', function(){
      if ('{' != buf[0] && '[' != buf[0]) return next(utils.error(400));
      try {
        req.body = JSON.parse(buf);
        next();
      } catch (err){
        err.status = 400;
        next(err);
      }
    });
  }
};

`
exports.json2 = (options) ->
  options ||= {}
  json_regex = /\+json$/
  (req, res, next) ->
    if req._body
      return next()
    req.body ||= {}
    # ignore bodiless methods
    method = req.method
    if method == "GET" || method == "HEAD" || method == "OPTIONS"
      return next()

    string = req.headers["content-type"]
    media_type = string.split(";")[0]
    if !(media_type == "application/json" || json_regex.test(media_type))
      return next()

    req._body = true

    buf = ""
    req.setEncoding("utf8")
    req.on "data", (chunk) -> buf += chunk
    req.on "end", () ->
      if !(buf[0] == "{" || buf[0] == "[")
        return next(utils.error(400))
      try
        req.body = JSON.parse(buf)
        next()
      catch err
        err.status = 400
        next(err)


