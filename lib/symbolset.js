(function() {
  var Capkom, _base, _ref;

  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};

  if (Capkom.symbolSets == null) Capkom.symbolSets = {};

  if ((_base = Capkom.symbolSets).sets == null) _base.sets = [];

  /*
  Generic
  */

  Capkom.Symbolset = (function() {

    function Symbolset(options) {
      this.options = options;
      this.nameMap = options.nameMap;
      this.name = options.name;
      this.baseUri = options.baseUri;
      this.nameFormat = options.nameFormat;
      this.sizeMap = options.sizeMap;
      this.nameMap = options.nameMap;
      this.symbols = options.symbols;
      Capkom.symbolSets[options.name] = this;
      Capkom.symbolSets.sets.push(this);
    }

    Symbolset.prototype.getSymbolUri = function(symbolId, symbolSize) {
      var imageName, symbolUri;
      imageName = this.nameFormat.replace("{symbolId}", this._applyMapping(symbolId, this.nameMap)).replace("{size}", this._applyMapping(symbolSize, this.sizeMap));
      return symbolUri = this.baseUri + imageName;
    };

    Symbolset.prototype.hasSymbol = function(sName) {
      var symbolName;
      if (this.nameMap) symbolName = this._applyMapping(sName, this.nameMap);
      if (_.indexOf(this.symbols, symbolName) !== -1) return true;
    };

    Symbolset.prototype._applyMapping = function(str, mapping) {
      return mapping[str] || str;
    };

    return Symbolset;

  })();

}).call(this);
