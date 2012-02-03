(function() {
  var Capkom, _ref;

  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};

  Capkom.test = function() {
    console.info("called");
    return false;
  };

  jQuery(document).ready(function() {
    return _.defer(function() {
      jQuery('#loadingDiv').ajaxStart(function() {
        return jQuery(this).show();
      }).ajaxStop(function() {
        return jQuery(this).hide();
      });
      return Capkom.loadProfile(function() {
        return Capkom.initNav();
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

  Capkom.updateSymbols = function() {
    if (Capkom.uiLoaded) {
      jQuery('.capkom-label').capkomSymbol({
        profile: Capkom.profile
      });
      if (Capkom.profile.get("useSymbols")) {
        return jQuery(".symbol").show();
      } else {
        return jQuery(".symbol").hide();
      }
    }
  };

}).call(this);
