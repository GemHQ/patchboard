// Generated by CoffeeScript 1.3.3
var Accept, Authorization, Basic, ContentType, Method, Path, Query,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Path = (function() {

  function Path(pattern) {
    this.type = "path";
    this.pattern = this.parse_pattern(pattern);
    this.matchers = {};
  }

  Path.prototype.parse_pattern = function(pattern) {
    var captures, component, components, name, _i, _len;
    captures = [];
    pattern = pattern.slice(1);
    components = pattern.split("/");
    for (_i = 0, _len = components.length; _i < _len; _i++) {
      component = components[_i];
      if (component.indexOf(":") === 0) {
        name = component.slice(1);
        captures.push({
          name: name
        });
      } else {
        captures.push(component);
      }
    }
    return captures;
  };

  Path.prototype.match = function(path) {
    var captured, got, index, path_parts, want, _i, _len;
    path_parts = path.slice(1).split("/");
    if (path_parts.length === this.pattern.length) {
      captured = {};
      for (index = _i = 0, _len = path_parts.length; _i < _len; index = ++_i) {
        got = path_parts[index];
        want = this.pattern[index];
        if (want.constructor === String) {
          if (got !== want) {
            return false;
          }
        } else {
          captured[want.name] = got;
        }
      }
      return captured;
    } else {
      return false;
    }
  };

  return Path;

})();

Query = (function() {

  function Query(query_spec) {
    var _base, _base1;
    this.type = "query";
    this.matchers = {};
    this.spec = query_spec;
    (_base = this.spec).required || (_base.required = {});
    (_base1 = this.spec).optional || (_base1.optional = {});
  }

  Query.prototype.match = function(input) {
    var key, spec, value, _ref;
    for (key in input) {
      value = input[key];
      if (!this.spec.required[key] && !this.spec.optional[key]) {
        return false;
      }
    }
    _ref = this.spec.required;
    for (key in _ref) {
      spec = _ref[key];
      if (!input[key]) {
        return false;
      }
    }
    return true;
  };

  return Query;

})();

Basic = (function() {

  function Basic(value) {
    this.value = value;
    this.matchers = {};
  }

  Basic.prototype.match = function(input) {
    if (this.value === "[any]") {
      return true;
    } else {
      return input === this.value;
    }
  };

  return Basic;

})();

Method = (function(_super) {

  __extends(Method, _super);

  function Method(method) {
    this.type = "method";
    Method.__super__.constructor.call(this, method);
  }

  Method.prototype.match = function(input) {
    return input === this.value;
  };

  return Method;

})(Basic);

Authorization = (function(_super) {

  __extends(Authorization, _super);

  function Authorization(authorization) {
    this.type = "authorization";
    Authorization.__super__.constructor.call(this, authorization);
  }

  Authorization.prototype.match = function(input) {
    var scheme;
    if (this.value === "[any]") {
      return true;
    } else if (input) {
      scheme = input.split(" ")[0];
      return scheme === this.value;
    } else {
      return false;
    }
  };

  return Authorization;

})(Basic);

ContentType = (function(_super) {

  __extends(ContentType, _super);

  function ContentType(content_type) {
    this.type = "content_type";
    ContentType.__super__.constructor.call(this, content_type);
  }

  ContentType.prototype.match = function(input) {
    if (this.value === "[any]") {
      return true;
    } else {
      if (input === this.value) {
        return input;
      } else {
        return false;
      }
    }
  };

  return ContentType;

})(Basic);

Accept = (function() {

  function Accept(value, payload) {
    this.value = value;
    this.payload = payload;
    this.type = "accept";
  }

  Accept.prototype.match = function(input) {
    if (this.value === "[any]") {
      return true;
    } else {
      if (input === this.value) {
        return input;
      } else {
        return false;
      }
    }
  };

  return Accept;

})();

module.exports = {
  Path: Path,
  Method: Method,
  Query: Query,
  Authorization: Authorization,
  ContentType: ContentType,
  Accept: Accept
};