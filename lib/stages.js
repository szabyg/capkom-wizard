(function() {
  var Capkom, _ref;

  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};

  Capkom.order = ["welcome", "fontsize", "theme", "channels", "symbolset", "symbolsize", "goodbye"];

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
      html: "Wie sollen Informationen dargestellt werden?<br/><br/>\n<input type='radio' name='e2r' id='e2r-both'/>\n<label for='e2r-both'>Text + Symbole <img src='symbols/symbol.gif' width='18' alt='Symbole'/></label>\n<input type='radio' name='e2r' id='e2r-alone'/>\n<label for='e2r-alone'>Text</label>\n<br/><br/>\nSprachausgabe:<br/><br/>\n<input type='radio' name='useAudio' id='audio-on'/>\n<label for='audio-on'><img src='symbols/Gnome-Audio-Volume-Medium-64.png' width='64' alt='Symbole'/></label>\n<input type='radio' name='useAudio' id='audio-off'/>\n<label for='audio-off'><img src='symbols/Gnome-Audio-Volume-Muted-64.png' width='64' alt='Symbole'/></label>\n",
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
      html: "Die CAPKOM-Kunstplattform beinhaltet viele Symbole.<br/>\nWie groß sollen die Symbole sein?"
    },
    "goodbye": {
      title: "Ende",
      image: "http://www.slowtrav.com/blog/teachick/snoopy_thankyou_big.gif",
      speech: "Dein Profil enthält nun Informationen, die ich jetzt trotzdem nicht vorlesen werde, weil sie für dich keinen Sinn machen würden.",
      html: "Vielen Dank für deine Zeit! <br/>\nDein Profil enthält nun folgende Informationen:<br/><br/>\n<div id=\"profile\"></div>",
      script: function(el) {
        return jQuery("#profile", el).html(JSON.stringify(Capkom.profile.toJSON()).replace(/,"/g, ',<br/>"').replace(/^{|}$/g, "").replace(/":/g, '": '));
      }
    }
  };

  /*
  Get an array of stage objects in the configured order.
  */

  Capkom.getStages = function() {
    var i, res, stage, stagename;
    res = (function() {
      var _ref2, _results;
      _ref2 = Capkom.order;
      _results = [];
      for (i in _ref2) {
        stagename = _ref2[i];
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
    var an, anchor, anchorName, anchorNames, anchors, i, stage, stageNames, stages, _i, _j, _len, _len2, _ref2, _ref3, _results, _results2;
    if (Capkom.uiLoaded) {
      stages = this.getStages();
      stageNames = _.map(stages, function(stage) {
        return stage.name;
      });
      anchors = jQuery(".stages").find("ul.titles").children();
      /*
              Remove not necessary tabs
      */
      _ref3 = (function() {
        _results = [];
        for (var _j = 0, _ref2 = anchors.length - 1; 0 <= _ref2 ? _j <= _ref2 : _j >= _ref2; 0 <= _ref2 ? _j++ : _j--){ _results.push(_j); }
        return _results;
      }).apply(this).reverse();
      for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
        i = _ref3[_i];
        anchor = anchors[i];
        anchorName = jQuery(anchor).find("a").attr("hash").replace(/^#/, "");
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
          return jQuery(anchor).find("a").attr("hash").replace(/^#/, "");
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

}).call(this);
