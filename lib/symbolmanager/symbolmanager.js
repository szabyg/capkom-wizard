(function() {
  var Capkom, _ref;

  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};

  Capkom.capkomSymbol = jQuery.widget("Capkom.capkomSymbol", {
    options: {
      profile: Capkom.profile,
      symbolSets: Capkom.symbolsets,
      symbolId: "default",
      uriPrefix: ""
    },
    _create: function() {
      var _profileChange,
        _this = this;
      this.symbolId = this.element.attr("symbolId" || this.options.symbolId);
      this.symbol = jQuery('<img class="capkom-symbol" style="padding-right:5px;vertical-align:middle;"/>&nbsp;');
      this.symbol.hide().prependTo(this.element);
      this._profileChange(this.options.profile);
      _profileChange = function(profile) {
        return _this._profileChange.apply(_this, [profile]);
      };
      return this.options.profile.bind('change', _profileChange);
    },
    _destroy: function() {
      return this.symbol.remove();
    },
    _profileChange: function(profile) {
      var symbolUri;
      symbolUri = this._getSymbolUri(profile, this.options.symbolSets);
      this.symbol.attr('src', symbolUri);
      if (profile.get('useSymbols')) {
        return this.symbol.show();
      } else {
        return this.symbol.hide();
      }
    },
    _getSymbolUri: function(profile, sets) {
      var imageName, symbolSet, symbolSetName, symbolSetRanking, symbolSize, symbolUri,
        _this = this;
      symbolSetRanking = _.union([profile.get('symbolset')], sets.sets);
      symbolSetName = _.detect(symbolSetRanking, function(setName) {
        var symbolName, symbolSet;
        symbolSet = sets[setName];
        symbolName = _this.symbolId;
        if (symbolSet.nameMap) {
          symbolName = _this._applyMapping(_this.symbolId, symbolSet.nameMap);
        }
        if (_.indexOf(symbolSet.symbols, symbolName) !== -1) return true;
      });
      if (!symbolSetName) {
        console.error("No symbolset found for " + this.symbolId);
        return "";
      }
      symbolSet = sets[symbolSetName];
      symbolSize = profile.get('symbolsize') || 'medium';
      imageName = symbolSet.nameFormat.replace("{symbolId}", this._applyMapping(this.symbolId, symbolSet.nameMap)).replace("{size}", this._applyMapping(symbolSize, symbolSet.sizeMap));
      return symbolUri = this.options.uriPrefix + symbolSet.baseUri + imageName;
    },
    _applyMapping: function(str, mapping) {
      return mapping[str] || str;
    }
  });

}).call(this);
