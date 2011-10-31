(function() {
  Capkom.Profile = Backbone.Model.extend();
  Capkom.profile = new Capkom.Profile;
  Capkom.profile.bind("change:fontsize", function(profile, fontsize) {
    jQuery("body").removeClass("fontsize-small fontsize-medium fontsize-large");
    return jQuery("body").addClass("fontsize-" + fontsize);
  });
  Capkom.profile.bind("change", function(profile) {
    console.info("profile change", arguments);
    return profile.save();
  });
  Backbone.sync = function(method, model) {
    return console.log(method, model);
  };
  Capkom.loadProfile = function(callback) {
    return jQuery.get("./default-profile.json", function(profile) {
      Capkom.defaultProfile = profile;
      Capkom.profile.set(profile);
      return typeof callback === "function" ? callback() : void 0;
    });
  };
}).call(this);
