(function() {
  var Capkom, _ref;
  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};
  Capkom.order = ["welcome", "fontsize", "theme", "channels", "symbolset", "symbolsize", "createuser"];
  Capkom.stages = {
    "welcome": {
      title: "Capkom Profil Wizard",
      image: "http://www.greeting-cards-4u.com/tubes/CharlyBrown/snoopy.gif",
      html: "Willkommen zum Kunstportal CAPKOM!<br/><br/>\nHallo, ich heiße Wizi. <br/>\nIch möchte Euch nun ein paar Fragen zur Bedienung des Kunstportals stellen. <br/>\nDies wird nur einige Minuten in Anspruch nehmen."
    },
    "fontsize": {
      title: "Schriftgröße",
      image: "http://www.thepartyanimal-blog.org/wp-content/uploads/2010/09/Halloween-Snoopy5.jpg",
      html: "Welche Schriftgröße ist für Dich am angenehmsten?<br/><br/>\n<div class='fontsize'>\n    <input type='radio' name='fontsize' id='fontsize-small' />\n    <label for='fontsize-small' ><span class='fontsize-small choose-button'>AAA</span></label>\n\n    <input type='radio' name='fontsize' id='fontsize-medium' />\n    <label for='fontsize-medium'><span class='fontsize-medium choose-button'>AAA</span></label>\n\n    <input type='radio' name='fontsize' id='fontsize-large' />\n    <label for='fontsize-large' ><span class='fontsize-large'>AAA</span></label>\n</div>",
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
      html: "Bitte bestimme nun das Bildschirmdesign.<br/>\nWähle dazu jenes Design, das Dir am besten gefällt.<br/><br/>\n<span id='themeselector'></span>",
      script: function(element) {
        return jQuery("#themeselector", element).themeswitcher({
          width: 300,
          onSelect: function(theme) {
            return console.info("selected theme", theme, arguments, this);
          }
        });
      }
    },
    "channels": {
      title: "Sprache/Symbolunterstützt",
      image: "http://www.ecartooes.com/img/snoopy/peanuts_snoopy_11.jpg",
      html: "Wie sollen Informationen dargestellt werden?<br/>\n<input type='radio' name='e2r' id='e2r-alone'/>\n<label for='e2r-alone'>Text</label>\n<input type='radio' name='e2r' id='e2r-both'/>\n<label for='e2r-both'>Text + Symbole</label>\n<br/><br/>\nAudio:\n<input type='checkbox' name='audio' id='audioButton'/>\n<label for='audioButton'>[Audio-Symbol]</label>",
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
          jQuery("#audioButton").attr("checked", "checked");
        }
        return jQuery('input[name=audio]').button().click(function() {
          var useAudio;
          useAudio = jQuery(this).attr("checked");
          return Capkom.profile.set({
            "useAudio": useAudio
          });
        });
      }
    },
    "symbolset": {
      title: "Symbolsatz",
      condition: function(profile) {
        return profile.get("useSymbols");
      },
      image: "http://www.gelsenkirchener-geschichten.de/userpix/1208/1208_snoopy006_3.gif",
      html: "Welche Art der Symbole gefällt Dir am besten?<br/>\nDu kannst Dir später auch Deine eigenen Symbole schaffen, indem Du eigene Bilder oder Fotos hochlädst."
    },
    "symbolsize": {
      title: "Symbolgröße",
      condition: function(profile) {
        return profile.get("useSymbols");
      },
      image: "http://i.fonts2u.com/sn/mp1_snoopy-dings_1.png",
      html: "Die CAPKOM-Kunstplattform beinhaltet viele Symbole.<br/>\nWie groß sollen die Symbole sein?"
    },
    "createuser": {
      title: "Benutzer anlegen",
      image: "symbols/ueberMich.gif",
      html: "<table>\n    <tr><td>Benutzername:</td><td><input id=''/></td></tr>\n    <tr><td>Password:</td><td><input type='password' id=''/></td></tr>\n</table>"
    }
  };
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
    return res = _(res).filter(function(stage) {
      if ((typeof stage.condition === "function" ? stage.condition(Capkom.profile) : void 0) !== false) {
        return true;
      }
    });
  };
}).call(this);
