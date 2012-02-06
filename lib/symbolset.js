(function() {
  var Capkom, _base, _ref;

  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};

  if (Capkom.symbolSets == null) Capkom.symbolSets = {};

  if ((_base = Capkom.symbolSets).sets == null) _base.sets = [];

  /*
  Generic symbol set class
  */

  Capkom.Symbolset = (function() {

    function Symbolset(options) {
      this.options = options;
      this.name = options.name;
      this.nameMap = options.nameMap;
      this.baseUri = options.baseUri;
      this.nameFormat = options.nameFormat;
      this.sizeMap = options.sizeMap;
      this.symbols = options.symbols;
      Capkom.symbolSets[options.name] = this;
      Capkom.symbolSets.sets.push(this);
    }

    Symbolset.prototype.getSymbolUri = function(symbolId, symbolSize) {
      var imageName;
      imageName = this.nameFormat.replace("{symbolId}", this._applyMapping(symbolId, this.nameMap)).replace("{size}", this._applyMapping(symbolSize, this.sizeMap));
      return this.baseUri + imageName;
    };

    Symbolset.prototype.hasSymbol = function(symbolId) {
      var symbolName;
      if (this.nameMap) symbolName = this._applyMapping(symbolId, this.nameMap);
      if (_.contains(this.symbols, symbolName)) return true;
    };

    Symbolset.prototype._applyMapping = function(str, mapping) {
      return mapping[str] || str;
    };

    return Symbolset;

  })();

}).call(this);
