(function() {
  var Capkom, _ref;

  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};

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

}).call(this);
