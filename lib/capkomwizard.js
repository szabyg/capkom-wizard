(function() {
  var Capkom, _base, _ref, _ref2, _ref3, _ref4, _ref5, _ref6;

  jQuery.widget("capkom.ttswidget", {
    options: {
      language: "de",
      backendUri: "http://dev.iks-project.eu/mary",
      backendType: "MARY",
      iconClass: "ui-icon-speaker",
      spinnerUri: "spinner.gif",
      dialogTitle: "TTS widget",
      defaultText: "No text found",
      buttonLabel: "Speak",
      errorMsg: "Error loading audio."
    },
    _create: function() {
      var _this = this;
      this.button = jQuery("<button class='tts-button'>" + this.options.buttonLabel + "</button>");
      this.button.css("display", "relative");
      this.button.css("top", "0");
      this.button.css("right", "0");
      this.button.css("margin", "8px");
      this.button.prependTo(this.element);
      this.button.button({
        text: false,
        icons: {
          primary: this.options.iconClass
        }
      });
      return this.button.click(function(e) {
        e.preventDefault();
        _this.talk();
        return false;
      });
    },
    _destroy: function() {
      this._cleanup();
      return jQuery(this.button).button("destroy").remove();
    },
    prepare: function() {
      return this._cleanup();
    },
    talk: function() {
      var _this = this;
      this.prepare();
      this.dialog = jQuery("<div id='ttswidget-dialog' title='" + this.options.dialogTitle + "'>\n    " + (this._getText()) + "\n    <br/><br/>\n    <audio id='ttswidget-audio' onerror='console.error(this)' controls='controls' style='' src='" + (this._makeLink()) + "' type='audio/ogg'>Your browser does not support the audio tag.</audio>\n    <img class='spinner' src='" + this.options.spinnerUri + "'/>\n</div>");
      this.dialog.appendTo(jQuery("body"));
      this.dialog.dialog({
        close: function() {
          return setTimeout(function() {
            return _this._cleanup();
          }, 500);
        },
        hide: "fade",
        width: "500"
      });
      this.audioElement = jQuery("#ttswidget-audio")[0];
      this.audioElement.onabort = function() {
        return console.error(attributes);
      };
      this.audioElement.load();
      this.audioElement.play();
      jQuery(this.audioElement).bind('playing', function() {
        return jQuery(".spinner", _this.dialog).hide();
      });
      jQuery(this.audioElement).bind('ended', function() {
        _this.dialog.dialog("close");
        return setTimeout(function() {
          return _this._cleanup();
        }, 500);
      });
      return jQuery(this.audioElement).bind('error', function(e) {
        var errorHtml;
        errorHtml = "<br/>\n<div style=\"color: red\">\n    <span class=\"ui-icon ui-icon-alert\" style=\"float:left; margin:0 7px 20px 0;\"></span>" + _this.options.errorMsg + "\n</div>";
        return _this.dialog.append(errorHtml);
      });
    },
    _cleanup: function() {
      return jQuery("#ttswidget-dialog").dialog("destroy").remove();
    },
    _getText: function() {
      if (this.element.attr("tts")) return this.element.attr("tts");
      if (this.element.text()) {
        return this.element.not(this.button).text().replace("" + this.options.buttonLabel, "");
      }
      return this.options.defaultText;
    },
    _getLang: function() {
      if (this.element.attr("lang")) return this.element.attr("lang");
      if (this.options.lang) return this.options.lang;
    },
    _getGender: function() {
      if (this.element.attr("gender")) return this.element.attr("gender");
      if (this.options.gender) return this.options.gender;
    },
    preset: function(lang, gender) {
      var presets, res;
      if (lang == null) lang = "en";
      if (gender == null) gender = "male";
      presets = {
        "de-male": ["LOCALE=de", "VOICE=bits3"],
        "de-female": ["LOCALE=de", "VOICE=bits1-hsmm"],
        "en-male": ["LOCALE=en_GB", "VOICE=dfki-spike"],
        "en-female": ["LOCALE=en_GB", "VOICE=dfki-prudence"]
      };
      res = presets["" + lang + "-" + gender];
      if (!res) {
        console.error("There's no TTS preset defined for " + lang + " and " + gender + ".");
      }
      return res || presets["de-female"];
    },
    _makeLink: function() {
      var params, res, text, uri, _encodeURI;
      _encodeURI = function(str) {
        return encodeURI(str).replace(/'/g, "%27");
      };
      text = this._getText();
      uri = this.options.backendUri + "/process?";
      params = this.preset(this._getLang(), this._getGender()).concat(["INPUT_TYPE=TEXT&OUTPUT_TYPE=AUDIO&INPUT_TEXT=" + (_encodeURI(text)), "OUTPUT_TEXT=", "effect_Volume_selected=", "effect_Volume_parameters=" + encodeURI("amount:2.0;"), "effect_Volume_default=Default", "effect_Volume_help=Help", "effect_TractScaler_selected=", "effect_TractScaler_parameters" + encodeURI("amount:1.5;"), "effect_TractScaler_default=Default", "effect_TractScaler_help=Help", "effect_F0Scale_selected=", "effect_F0Scale_parameters=" + encodeURI("f0Scale:2.0;"), "effect_F0Scale_default=Default", "effect_F0Scale_help=Help", "effect_F0Add_selected=", "effect_F0Add_parameters=" + encodeURI("f0Add:50.0;"), "effect_F0Add_default=Default", "effect_F0Add_help=Help", "effect_Rate_selected=", "effect_Rate_parameters=" + encodeURI("durScale:1.5;"), "effect_Rate_default=Default", "effect_Rate_help=Help", "effect_Robot_selected=", "effect_Robot_parameters=" + encodeURI("amount:100.0;"), "effect_Robot_default=Default", "effect_Robot_help=Help", "effect_Whisper_selected=", "effect_Whisper_parameters=" + encodeURI("amount:100.0;"), "effect_Whisper_default=Default", "effect_Whisper_help=Help", "effect_Stadium_selected=", "effect_Stadium_parameters=" + encodeURI("amount:100.0"), "effect_Stadium_default=Default", "effect_Stadium_help=Help", "effect_Chorus_selected=", "effect_Chorus_parameters=" + encodeURI("delay1:466;amp1:0.54;delay2:600;amp2:-0.10;delay3:250;amp3:0.30"), "effect_Chorus_default=Default", "effect_Chorus_help=Help", "effect_FIRFilter_selected=", "effect_FIRFilter_parameters=" + encodeURI("type:3;fc1:500.0;fc2:2000.0"), "effect_FIRFilter_default=Default", "effect_FIRFilter_help=Help", "effect_JetPilot_selected=", "effect_JetPilot_parameters=", "effect_JetPilot_default=Default", "effect_JetPilot_help=Help", "HELP_TEXT=", "VOICE_SELECTIONS=bits3%20de%20male%20unitselection%20general", "AUDIO_OUT=WAVE_FILE", "AUDIO=WAVE_FILE"]);
      res = uri + params.join('&');
      return res;
    }
  });

  Capkom = (_ref = this.Capkom) != null ? _ref : this.Capkom = {};

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
      this.symbol = jQuery('img.capkom-symbol', this.element);
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
      if (profile.get('useSymbols') || this.element.attr('donthidesymbol')) {
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

  Capkom = (_ref2 = this.Capkom) != null ? _ref2 : this.Capkom = {};

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

  Capkom = (_ref3 = this.Capkom) != null ? _ref3 : this.Capkom = {};

  new Capkom.Symbolset({
    name: "default",
    baseUri: "symbols/free1/",
    nameFormat: "{symbolId}{size}.png",
    sizeMap: {
      /* "25x25"
      */
      small: "25",
      /* "50x50"
      */
      medium: "50",
      /* "100x100"
      */
      large: "100"
    },
    nameMap: {
      mainSymbol: "Willkommen-home",
      welcome: "Willkommen-home",
      theme: "design",
      channels: "Sprache-Symbole",
      "text-with-symbols": "Text+Symbole",
      "text-only": "Text",
      symbolset: "Symbole",
      goodbye: "ende"
    },
    symbols: ["back", "design", "ende", "fontsize", "Sprache-Symbole", "Symbole", "symbolsize", "Text", "Text+Symbole", "tts", "weiter", "Willkommen-home"]
  });

  new Capkom.Symbolset({
    name: "capkom",
    baseUri: "symbols/capkom/",
    nameFormat: "{size}/Capkom_{symbolId}.gif",
    sizeMap: {
      /* "25x25"
      */
      small: "small",
      /* "50x50"
      */
      medium: "medium",
      /* "100x100"
      */
      large: "big"
    },
    nameMap: {
      mainSymbol: "Profil_m",
      friends: "Freunde",
      event: "Event_m",
      profile: "Profil_m",
      search: "Suche",
      welcome: "Profil_m"
    },
    symbols: ["Event_m", "Event_w", "Freunde", "Galerie", "Kalender", "Kuenstlergruppe", "Kuenstler_m", "Kuenstler_w", "Kunstwerk", "MeinKunstwerk_m", "MeinKunstwerk_w", "Profil_m", "Profil_w", "Suche"]
  });

  Capkom = (_ref4 = this.Capkom) != null ? _ref4 : this.Capkom = {};

  jQuery(document).ready(function() {
    return _.defer(function() {
      Capkom.loadProfile(function() {
        Capkom.initNav();
        Capkom.updateTTS();
        return jQuery('.capkom-label').capkomSymbol({
          profile: Capkom.profile
        });
      });
      return jQuery('#loadingDiv').ajaxStart(function() {
        return jQuery(this).show();
      }).ajaxStop(function() {
        return jQuery(this).hide();
      });
    });
  });

  Capkom.getStagename = function() {
    return window.location.hash.replace(/^#/, "");
  };

  Capkom.updateTTS = function() {
    if (Capkom.uiLoaded) {
      if (Capkom.profile.get("useAudio")) {
        return jQuery(".tts").ttswidget({
          spinnerUri: "css/spinner.gif"
        });
      } else {
        return jQuery(":capkom-ttswidget").ttswidget("destroy");
      }
    }
  };

  Capkom = (_ref5 = this.Capkom) != null ? _ref5 : this.Capkom = {};

  Capkom.order = ["welcome", "fontsize", "symbolsize", "theme", "channels", "symbolset", "goodbye"];

  Capkom.stages = {
    "welcome": {
      title: "Willkommen",
      image: "http://www.greeting-cards-4u.com/tubes/CharlyBrown/snoopy.gif",
      speech: "Willkommen zum Kunstportal CAPKOM!\nHallo, ich heisse Wizi.\nIch möchte euch nun ein paar Fragen zur Bedienung des Kunstportals stellen.\nDies wird nur einige Minuten in Anspruch nehmen.",
      html: "Willkommen zum Kunstportal CAPKOM!<br/><br/>\nHallo, ich heiße Wizi. <br/>\nIch möchte euch nun ein paar Fragen zur Bedienung des Kunstportals stellen. <br/>\nDies wird nur einige Minuten in Anspruch nehmen."
    },
    "fontsize": {
      title: "Schriftgröße",
      image: "http://www.thepartyanimal-blog.org/wp-content/uploads/2010/09/Halloween-Snoopy5.jpg",
      speech: "Welche Schriftgröße ist für dich am angenehmsten?",
      html: "Welche Schriftgröße ist für dich am angenehmsten?<br/><br/>\n<div class='fontsize'>\n    <input type='radio' name='fontsize' id='fontsize-small' />\n    <label for='fontsize-small' ><span class='fontsize-small choose-button'>AAA</span></label>\n\n    <input type='radio' name='fontsize' id='fontsize-medium' />\n    <label for='fontsize-medium'><span class='fontsize-medium choose-button'>AAA</span></label>\n\n    <input type='radio' name='fontsize' id='fontsize-large' />\n    <label for='fontsize-large' ><span class='fontsize-large'>AAA</span></label>\n</div>",
      script: function(element) {
        jQuery("#fontsize-" + (Capkom.profile.get('fontsize'))).attr("checked", "checked");
        return jQuery(".fontsize", element).buttonset().change(function(e) {
          return Capkom.profile.set({
            'fontsize': e.target.id.replace("fontsize-", "")
          });
        });
      }
    },
    "theme": {
      title: "Design",
      image: "http://www.balloonmaniacs.com/images/snoopygraduateballoon.jpg",
      speech: "Bitte bestimme nun das Bildschirmdesign. Wähle dazu jenes Design, das dir am besten gefällt.",
      html: "Bitte bestimme nun das Bildschirmdesign.<br/>\nWähle dazu jenes Design, das dir am besten gefällt.<br/><br/>\n<span id='themeselector'></span>",
      script: function(element) {
        return jQuery("#themeselector", element).themeswitcher({
          width: "5em",
          buttonHeight: 30,
          onSelect: function() {
            return Capkom.profile.set({
              "theme": $.cookie("jquery-ui-theme")
            });
          }
        });
      }
    },
    "channels": {
      title: 'Sprache/Symbole <img src="lib/ttswidget/speaker22.png" width="22" alt="Sprache"/>',
      image: "http://www.ecartooes.com/img/snoopy/peanuts_snoopy_11.jpg",
      speech: "Wie sollen Informationen dargestellt werden? Mit oder ohne Symbolen? Mit oder ohne Sprachausgabe?",
      html: "Wie sollen Informationen dargestellt werden?<br/><br/>\n<input type='radio' name='e2r' id='e2r-both'/>\n<label for='e2r-both' class='capkom-label' symbolId='text-with-symbols' donthidesymbol='true'>Text + Symbole</label>\n<input type='radio' name='e2r' id='e2r-alone'/>\n<label for='e2r-alone' class='capkom-label' symbolId='text-only' donthidesymbol='true'>Text</label>\n<br/><br/>\n<span symbolId='tts' class='capkom-label'>Sprachausgabe</span>:<br/><br/>\n<input type='radio' name='useAudio' id='audio-on'/>\n<label for='audio-on'>\n    <img src='symbols/Gnome-Audio-Volume-Medium-64.png' width='64' alt='Sprachausgabe an'/>\n</label>\n<input type='radio' name='useAudio' id='audio-off'/>\n<label for='audio-off'>\n    <img src='symbols/Gnome-Audio-Volume-Muted-64.png' width='64' alt='Keine Sprachausgabe'/>\n</label>",
      script: function(element) {
        if (Capkom.profile.get("useSymbols")) {
          jQuery("#e2r-both").attr("checked", "checked");
        } else {
          jQuery("#e2r-alone").attr("checked", "checked");
        }
        jQuery('#e2r-alone, #e2r-both').button().click(function() {
          var state;
          state = this.id.replace("e2r-", "");
          switch (state) {
            case "alone":
              return Capkom.profile.set({
                useE2r: true,
                useSymbols: false
              });
            case "both":
              return Capkom.profile.set({
                useE2r: true,
                useSymbols: true
              });
          }
        });
        if (Capkom.profile.get("useAudio")) {
          jQuery("#audio-on").attr("checked", "checked");
        } else {
          jQuery("#audio-off").attr("checked", "checked");
        }
        return jQuery('#audio-on, #audio-off').button().click(function() {
          var state;
          state = this.id.replace("audio-", "");
          switch (state) {
            case "on":
              return Capkom.profile.set({
                useAudio: true
              });
            case "off":
              return Capkom.profile.set({
                useAudio: false
              });
          }
        });
      }
    },
    "symbolset": {
      title: "<label symbol-id='symbolset'>Symbolsatz</label>",
      /*
               only show it if symbols are turned on
      */
      condition: function(profile) {
        return profile.get("useSymbols");
      },
      image: "http://www.gelsenkirchener-geschichten.de/userpix/1208/1208_snoopy006_3.gif",
      speech: "Welche Art der Symbole gefällt dir am besten?",
      html: "Welche Art der Symbole gefällt dir am besten?<br/>\nDu kannst dir später auch Deine eigenen Symbole schaffen, indem du eigene Bilder oder Fotos hochlädst.\n<div class='symbolset-symbols'></div>",
      script: function(element) {
        var html, symbolSet, symbolSetName, symbolSets, _i, _len;
        symbolSets = _.filter(Capkom.symbolSets.sets, function(symbolSet) {
          return symbolSet.hasSymbol("mainSymbol");
        });
        console.info(symbolSets);
        for (_i = 0, _len = symbolSets.length; _i < _len; _i++) {
          symbolSet = symbolSets[_i];
          html = "<input type='radio' class='symbolset-selector " + symbolSet.name + "' name='symbolset' value='" + symbolSet.name + "' id='symbolset-" + symbolSet.name + "'/>\n<label for='symbolset-" + symbolSet.name + "'>\n    <img src='" + (symbolSet.getSymbolUri("mainSymbol", "large")) + "'/>\n</label>";
          jQuery(html).appendTo('.symbolset-symbols', element);
        }
        symbolSetName = Capkom.profile.get('symbolSet');
        jQuery('.symbolset-selector', element).filter("." + symbolSetName).attr("checked", "checked").end().button().click(function() {
          console.log('click');
          return Capkom.profile.set({
            symbolSet: jQuery(this).val()
          });
        });
        return jQuery(".symbolset-symbols .symbolset-mainSymbol", element).find("." + symbolSet).addClass('selected').end().button();
      }
    },
    /*
         Definition of the symbol size selection screen
    */
    "symbolsize": {
      title: "Symbolgröße",
      condition: function(profile) {
        return profile.get("useSymbols");
      },
      image: "http://i.fonts2u.com/sn/mp1_snoopy-dings_1.png",
      html: "Die CAPKOM-Kunstplattform beinhaltet viele Symbole.<br/>\nWie groß sollen die Symbole sein? <br/><br/>\n<div class='symbolsize-symbols'>\n    <input type='radio' name='symbolsize' id='symbolsize-small' />\n    <label for='symbolsize-small' ><span class='symbolsize-small choose-button'>\n        <img src='symbols/ui/symbolsize25.png' title='klein'/>\n    </span></label>\n\n    <input type='radio' name='symbolsize' id='symbolsize-medium' />\n    <label for='symbolsize-medium'><span class='symbolsize-medium choose-button'>\n        <img src='symbols/ui/symbolsize50.png' title='mittel'/>\n    </span></label>\n\n    <input type='radio' name='symbolsize' id='symbolsize-large' />\n    <label for='symbolsize-large' ><span class='symbolsize-large'>\n        <img src='symbols/ui/symbolsize100.png' title='groß'/>\n    </span></label>\n</div>",
      script: function(element) {
        jQuery("#symbolsize-" + (Capkom.profile.get('symbolsize'))).attr("checked", "checked");
        return jQuery(".symbolsize-symbols", element).buttonset().change(function(e) {
          return Capkom.profile.set({
            'symbolsize': e.target.id.replace("symbolsize-", "")
          });
        });
      }
    },
    "goodbye": {
      title: "Ende",
      image: "http://www.slowtrav.com/blog/teachick/snoopy_thankyou_big.gif",
      speech: "Dein Profil enthält nun Informationen, die ich jetzt trotzdem nicht vorlesen werde, weil sie für dich keinen Sinn machen würden.",
      html: "Vielen Dank für deine Zeit! <br/>\nDein Profil enthält nun folgende Informationen:<br/><br/>\n<div id=\"profile\"></div>",
      script: function(el) {
        var profileText;
        profileText = function() {
          return JSON.stringify(Capkom.profile.toJSON()).replace(/,"/g, ',<br/>"').replace(/^{|}$/g, "").replace(/":/g, '": ');
        };
        Capkom.profile.bind("change", function(profile) {
          return jQuery("#goodbye #profile").html(profileText());
        });
        return jQuery("#profile", el).html(profileText());
      }
    }
  };

  /*
  Get an array of stage objects in the configured order.
  */

  Capkom.getStages = function() {
    var i, res, stage, stagename;
    res = (function() {
      var _ref6, _results;
      _ref6 = Capkom.order;
      _results = [];
      for (i in _ref6) {
        stagename = _ref6[i];
        stage = Capkom.stages[stagename];
        stage.name = stagename;
        _results.push(stage);
      }
      return _results;
    })();
    /* 
    Filter out the dependent and not-to-show stages based on `stage.condition`
    */
    return res = _(res).filter(function(stage) {
      if ((typeof stage.condition === "function" ? stage.condition(Capkom.profile) : void 0) !== false) {
        return true;
      }
    });
  };

  Capkom.showStages = function(el) {
    var an, anchor, anchorName, anchorNames, anchors, i, stage, stageNames, stages, _i, _j, _len, _len2, _ref6, _ref7, _results, _results2;
    if (Capkom.uiLoaded) {
      stages = this.getStages();
      stageNames = _.map(stages, function(stage) {
        return stage.name;
      });
      anchors = jQuery(".stages").find("ul.titles").children();
      /*
              Remove not necessary tabs
      */
      _ref7 = (function() {
        _results = [];
        for (var _j = 0, _ref6 = anchors.length - 1; 0 <= _ref6 ? _j <= _ref6 : _j >= _ref6; 0 <= _ref6 ? _j++ : _j--){ _results.push(_j); }
        return _results;
      }).apply(this).reverse();
      for (_i = 0, _len = _ref7.length; _i < _len; _i++) {
        i = _ref7[_i];
        anchor = anchors[i];
        anchorName = jQuery(anchor).find("a").attr("href").replace(/^#/, "");
        /* anchorName not in stageNames?
        */
        if (_.indexOf(stageNames, anchorName) === -1) {
          jQuery(".stages").find("[href=#" + anchorName + "]").parent().hide();
        }
      }
      /*
              Return the current anchorNames
      */
      anchorNames = function() {
        return _.map(anchors, function(anchor) {
          return jQuery(anchor).find("a").attr("href").replace(/^#/, "");
        });
      };
      /*
              Add new tabs
      */
      _results2 = [];
      for (i = 0, _len2 = stages.length; i < _len2; i++) {
        stage = stages[i];
        an = anchorNames();
        if (_.indexOf(an, stage.name) === -1) {
          el.append(Capkom.renderStage(stage, jQuery(".stages"), i));
          el.tabs("add", "#" + stage.name, stage.title, i);
        }
        _results2.push($(".stages").find("[href=#" + stage.name + "]").parent().show());
      }
      return _results2;
    }
  };

  Capkom = (_ref6 = this.Capkom) != null ? _ref6 : this.Capkom = {};

  Capkom.Profile = Backbone.Model.extend();

  Capkom.profile = new Capkom.Profile;

  Capkom.profile.bind("change:fontsize", function(profile, fontsize) {
    jQuery("body").removeClass("fontsize-small fontsize-medium fontsize-large");
    return jQuery("body").addClass("fontsize-" + fontsize);
  });

  Capkom.profile.bind("change:theme", function(profile, theme) {
    $.cookie("jquery-ui-theme", theme);
    return $("#bgThemeActivator").themeswitcher();
  });

  Capkom.profile.bind("change:useAudio", function(profile, audio) {
    return typeof Capkom.updateTTS === "function" ? Capkom.updateTTS() : void 0;
  });

  Capkom.profile.bind("change:useSymbols", function(profile, useSymbols) {
    if (typeof Capkom.showStages === "function") {
      Capkom.showStages(jQuery(".stages"));
    }
    return typeof Capkom.updateSymbols === "function" ? Capkom.updateSymbols() : void 0;
  });

  Capkom.profile.bind("change", function(profile) {
    return profile.save();
  });

  Backbone.sync = function(method, model) {
    localStorage.profile = JSON.stringify(model.toJSON());
    return console.info("profile saved:", localStorage.profile);
  };

  Capkom.loadProfile = function(callback) {
    var setProfile;
    setProfile = function(profile) {
      if (typeof profile === "string") profile = JSON.parse(profile);
      Capkom.defaultProfile = profile;
      Capkom.profile.set(profile);
      return typeof callback === "function" ? callback() : void 0;
    };
    if (localStorage.profile) {
      return setProfile(localStorage.profile);
    } else {
      return jQuery.get("./default-profile.json", function(profile) {
        return _.defer(function() {
          return setProfile(profile);
        });
      });
    }
  };

  Capkom.initNav = function() {
    var i, stage, _ref7, _renderStageTitle;
    _renderStageTitle = function(stage) {
      return "<li><a class='stage-title capkom-label' symbolId='" + stage.name + "' href='#" + stage.name + "'>" + stage.title + "</a></li>";
    };
    _ref7 = Capkom.getStages();
    for (i in _ref7) {
      stage = _ref7[i];
      jQuery(".stages .titles").append(jQuery(_renderStageTitle(stage)));
      this.renderStage(stage, jQuery(".stages"));
    }
    jQuery(".stages").tabs({
      select: function(event, ui) {
        return window.location.hash = ui.tab.hash;
      }
    }).addClass('ui-tabs-vertical ui-helper-clearfix');
    return Capkom.uiLoaded = true;
  };

  Capkom.renderStage = function(stage, tabsEl, index) {
    var el, _renderStage,
      _this = this;
    _renderStage = function(stage) {
      var _ref7;
      return "<div id=\"" + stage.name + "\">\n    <table class=\"ui-widget-content\"><tr><td style=\"vertical-align: top;padding: 1em;\">\n        <div>\n            <img width=\"200\" class=\"stage-image " + ((_ref7 = stage.image) != null ? _ref7 : {
        '': 'hidden'
      }) + "\" alt=\"Wizard Bild\" src=\"" + stage.image + "\" />\n        </div>\n    </td><td>\n        <div style=\"padding: 5px 15px;\">\n            <span class=\"stage-content tts\" lang=\"de\">" + stage.html + "</span>\n        </div>\n        <div class=\"buttons\">\n            <button class=\"prevButton\" alt=\"Zurück\">Zurück</button>\n            <button class=\"nextButton\" alt=\"Weiter\">Weiter</button>\n        </div>\n    </td></tr></table>\n</div>";
    };
    el = null;
    if (tabsEl.find(".ui-tabs-panel").length && index) {
      el = jQuery(_renderStage(stage)).insertBefore(jQuery(tabsEl.find(".ui-tabs-panel")[index]));
    } else {
      el = jQuery(_renderStage(stage)).appendTo(tabsEl);
    }
    if (stage.script) stage.script(jQuery(".stage-content", el));
    jQuery(".prevButton", el).button().click(function() {
      var newIndex;
      newIndex = jQuery(".stages").find("ul.titles .ui-tabs-active").prev().index();
      return jQuery(".stages").tabs("select", newIndex);
    });
    jQuery(".nextButton", el).button().click(function() {
      var newIndex;
      newIndex = jQuery(".stages").find("ul.titles .ui-tabs-active").next().index();
      return jQuery(".stages").tabs("select", newIndex);
    });
    if (stage.speech) jQuery(".stage-content.tts", el).attr("tts", stage.speech);
    return el;
  };

}).call(this);
