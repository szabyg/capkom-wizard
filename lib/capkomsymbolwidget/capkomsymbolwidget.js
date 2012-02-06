(function() {
  var Capkom, _ref;

  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};

  jQuery.widget("Capkom.capkomSymbol", {
    options: {
      profile: Capkom.profile,
      symbolSets: Capkom.symbolSets,
      symbolId: "default",
      uriPrefix: ""
    },
    _create: function() {
      var _base, _profileChange,
        _this = this;
      if ((_base = this.options).symbolSets == null) {
        _base.symbolSets = Capkom.symbolSets;
      }
      this.symbolId = this.element.attr("symbolId" || this.options.symbolId);
      this.symbol = jQuery('<img class="capkom-symbol" style="padding-right:5px;vertical-align:middle;display:none;"/>&nbsp;');
      this.symbol.prependTo(this.element);
      this.symbol = jQuery('img', this.element);
      this.symbol.hide();
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
      var preferredSet, symbolSet, symbolSetRanking, symbolSize, symbolUri,
        _this = this;
      preferredSet = this.options.symbolSets[profile.get('symbolSet')];
      symbolSetRanking = _.union([preferredSet], sets.sets);
      symbolSet = _.detect(symbolSetRanking, function(symbolSet) {
        return symbolSet.hasSymbol(_this.symbolId);
      });
      if (!symbolSet) {
        console.error("No symbolset found for " + this.symbolId);
        return "";
      }
      symbolSize = profile.get('symbolsize') || 'medium';
      return symbolUri = this.options.uriPrefix + symbolSet.getSymbolUri(this.symbolId, symbolSize);
    }
  });

}).call(this);
