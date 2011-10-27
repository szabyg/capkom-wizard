(function() {
  var Capkom, _ref;
  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};
  Capkom.stages = {
    "welcome": {
      title: "Capkom Profilerstellung Wizard",
      image: "http://www.greeting-cards-4u.com/tubes/CharlyBrown/snoopy.gif",
      html: "Willkommen zum Kunstportal CAPKOM!<br/><br/>\nHallo, ich heiße Wizi. <br/>\nIch möchte Euch nun ein paar Fragen zur Bedienung des Kunstportals stellen. <br/>\nDies wird nur einige Minuten in Anspruch nehmen.",
      route: ""
    },
    "createuser": {
      title: "Benutzer anlegen",
      image: "symbols/ueberMich.gif",
      html: "Benutzername: <input id=''/><br/>\nPassword: <input id=''/>"
    },
    "fontsize": {
      title: "Schriftgröße",
      image: "http://www.thepartyanimal-blog.org/wp-content/uploads/2010/09/Halloween-Snoopy5.jpg",
      html: "Welche Schriftgröße ist für Dich am angenehmsten?<br/><br/>\n<div class='fontsize'>\n    <input type='radio' name='fontsize' id='fontsize-small' />\n    <label for='fontsize-small' class='fontsize-small'>AAA</label>\n\n    <input type='radio' name='fontsize' id='fontsize-medium' />\n    <label for='fontsize-medium' class='fontsize-medium'>AAA</label>\n\n    <input type='radio' name='fontsize' id='fontsize-large' />\n    <label for='fontsize-large' class='fontsize-large'>AAA</label>\n</div>",
      script: function(element) {
        jQuery("#fontsize-" + Capkom.profile.fontsize).attr("checked", "checked");
        return jQuery(".fontsize", element).buttonset().change(function(e) {
          console.info("fontsize change", arguments, e.target.id);
          return Capkom.profile.fontsize = e.target.id.replace("fontsize-", "");
        });
      }
    },
    "theme": {
      title: "Bildschirm design",
      image: "symbols/ueberMich.gif",
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
    "symbolsize": {
      title: "Symbolgröße",
      image: "symbols/ueberMich.gif",
      html: "Die CAPKOM-Kunstplattform beinhaltet viele Symbole.<br/>\nWie groß sollen die Symbole sein?"
    },
    "e2r": {
      title: "Sprache/Symbolunterstützt",
      image: "symbols/ueberMich.gif",
      html: "Wie sollen Informationen dargestellt werden?<br/>\nText / \n\n<input type='radio' name='e2r' id='e2r-alone'/>\n<label for='e2r-alone'>Einfache Sprache</label>\nText + Symbol []\n<input type='radio' name='e2r' id='e2r-alone'/>\n<label for='e2r-both'>Einfache Sprache und Symbole</label>"
    },
    "symbolset": {
      title: "Symbolsatz",
      image: "symbols/ueberMich.gif",
      html: "Welche Art der Symbole gefällt Dir am besten?<br/>\nDu kannst Dir später auch Deine eigenen Symbole schaffen, indem Du eigene Bilder oder Fotos hochlädst."
    }
  };
  Capkom.order = ["welcome", "fontsize", "theme", "symbolsize", "e2r", "symbolset", "createuser"];
}).call(this);
