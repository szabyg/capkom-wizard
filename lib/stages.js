(function() {
  var Capkom, _ref;
  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};
  Capkom.stages = {
    "welcome": {
      title: "Capkom Profilerstellung Wizard",
      image: "symbols/ueberMich.gif",
      html: "Willkommen zum CapKom Kunstportal!<br/>\n[Beschreibung der nächsten Schritte...]",
      route: ""
    },
    "createuser": {
      title: "Benutzer anlegen",
      html: "Benutzername: <input id=''/>"
    },
    "fontsize": {
      title: "Schriftgröße",
      image: "fontsize.gif",
      html: "<div class='fontsize'>\n    <input type='radio' name='fontsize' id='fontsize-small' />\n    <label for='fontsize-small' class='fontsize-small'>AAA</label>\n\n    <input type='radio' name='fontsize' id='fontsize-medium' />\n    <label for='fontsize-medium' class='fontsize-medium'>AAA</label>\n\n    <input type='radio' name='fontsize' id='fontsize-large' />\n    <label for='fontsize-large' class='fontsize-large'>AAA</label>\n</div>",
      script: function(element) {
        jQuery("#fontsize-" + Capkom.profile.fontsize).attr("checked", "checked");
        return jQuery(".fontsize", element).buttonset().change(function(e) {
          console.info("fontsize change", arguments, e.target.id);
          return Capkom.profile.fontsize = e.target.id.replace("fontsize-", "");
        });
      }
    },
    "theme": {
      title: "Theme",
      html: "<div id='themeselector'></div>",
      script: function(element) {
        return jQuery("#themeselector", element).themeswitcher();
      }
    },
    "symbolsize": {
      title: "sdfg",
      html: "Symbolsize"
    },
    "e2r": {
      title: "EasyToRead",
      html: "Not yet implemented..."
    },
    "symbolset": {
      title: "Symolsatz",
      html: "Not yet implemented..."
    }
  };
  Capkom.order = ["welcome", "fontsize", "createuser", "theme", "symbolsize", "e2r", "symbolset"];
}).call(this);
