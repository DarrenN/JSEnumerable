// Generated by CoffeeScript 1.6.3
(function() {
  var Enumerable, root,
    __slice = [].slice;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  Enumerable = (function() {
    function Enumerable() {
      this.values = _.toArray(arguments);
      this.events = {};
      if (((typeof _ !== "undefined" && _ !== null) && typeof _ === "function") === false) {
        throw new Error("Underscore.js is required");
      }
    }

    Enumerable.prototype.set = function() {
      var v, values, _i, _len, _results;
      values = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (values.length > 1) {
        _results = [];
        for (_i = 0, _len = values.length; _i < _len; _i++) {
          v = values[_i];
          _results.push(this.set(v));
        }
        return _results;
      } else {
        if ((this.buffer_length != null) && this.values.length >= this.buffer_length) {
          this.shift();
        }
        this.values.push(values[0]);
        return this.trigger('set', values[0]);
      }
    };

    Enumerable.prototype.get = function(index) {
      var val;
      if (this.values[index] != null) {
        val = this.values[index];
      }
      if (val != null) {
        return this.trigger('get', val);
      }
    };

    Enumerable.prototype.remove = function(value) {
      var index, val, values;
      index = _.indexOf(this.values, value);
      if (index === -1) {
        return this.trigger('remove', false);
      }
      val = this.values[index];
      values = this.values.slice(0, index).concat(_.rest(this.values, index + 1));
      this.values = values;
      return this.trigger('remove', val);
    };

    Enumerable.prototype.pop = function() {
      this.values.pop();
      return this.trigger('pop');
    };

    Enumerable.prototype.shift = function() {
      return this.trigger('shift', this.values.shift());
    };

    Enumerable.prototype.each = function(fn, context) {
      var _this = this;
      return _.each(this.values, function(v) {
        _this.trigger('each', v);
        return fn(v);
      }, context);
    };

    Enumerable.prototype.map = function(fn, context) {
      return this.trigger('map', _.map(this.values, fn, context));
    };

    Enumerable.prototype.forEach = function(fn, context) {
      return this.each(fn, context);
    };

    Enumerable.prototype.reduce = function(fn, memo, context) {
      return this.trigger('reduce', _.reduce(this.values, fn, memo, context));
    };

    Enumerable.prototype.reduceRight = function(fn, memo, context) {
      return this.trigger('reduceRight', _.reduce(this.values, fn, memo, context));
    };

    Enumerable.prototype.register = function(event, fn) {
      return this.events[event] = fn;
    };

    Enumerable.prototype.deregister = function(event) {
      if (this.events[event] != null) {
        return delete this.events[event];
      }
    };

    Enumerable.prototype.trigger = function() {
      var args, event;
      event = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if ((event != null) && (this.events[event] != null)) {
        this.events[event](args);
      }
      return this.cleanReturnVal(args);
    };

    Enumerable.prototype.cleanReturnVal = function(val) {
      if (_.isArray(val) && val.length === 1) {
        return val[0];
      } else {
        return val;
      }
    };

    Enumerable.prototype.toString = function() {
      return JSON.stringify(this.values);
    };

    Enumerable.prototype.setBuffer = function(buffer_length) {
      var v, _i, _len, _ref, _results;
      this.buffer_length = buffer_length;
      if (this.values.length > 0 && this.values.length > this.buffer_length) {
        _ref = this.values.slice(0, this.values.length - this.buffer_length);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          v = _ref[_i];
          _results.push(this.shift(v));
        }
        return _results;
      }
    };

    return Enumerable;

  })();

  if (typeof module === 'object' && module && typeof module.exports === 'object') {
    module.exports = Enumerable;
  } else if (typeof exports === 'object' && exports) {
    exports.Enumerable = Enumerable;
  } else if (typeof define === 'function' && define.amd) {
    define('enumerable', [], function() {
      return Enumerable;
    });
  } else {
    root.Enumerable = Enumerable;
  }

}).call(this);
