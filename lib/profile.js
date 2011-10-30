(function() {
  Backbone.sync = function(method, model) {
    return console.log(method, model);
  };
  Capkom.loadProfile = function(callback) {
    return jQuery.get("./default-profile.json", function(profile) {
      Capkom.defaultProfile = new Backbone.Model(profile);
      Capkom.profile = new Backbone.Model(profile);
      return typeof callback === "function" ? callback() : void 0;
    });
  };
}).call(this);
