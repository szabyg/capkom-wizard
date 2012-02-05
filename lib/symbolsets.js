(function() {
  var Capkom, _ref;

  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};

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

}).call(this);
