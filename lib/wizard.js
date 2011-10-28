(function() {
  var Capkom, _ref;
  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};
  Capkom.getStagename = function() {
    return window.location.hash.replace(/^#/, "");
  };
  jQuery.get("./default-profile.json", function(profile) {
    Capkom.defaultProfile = _.clone(profile);
    return Capkom.profile = _.clone(profile);
  });
  jQuery(document).ready(function() {
    return _.defer(function() {
      Capkom.router = new Capkom.RouterClass;
      Backbone.history.start();
      jQuery("section").accordion({
        autoHeight: false
      });
      jQuery("#nextButton").button().click(function() {
        var from, next, stages;
        from = Capkom.stages[Capkom.getStagename()];
        stages = Capkom.getStages();
        next = stages[stages.indexOf(from) + 1];
        if (next !== void 0) {
          return Capkom.router.navigate(next.name, true);
        }
      });
      jQuery("#prevButton").button().click(function() {
        var from, next, stages;
        from = Capkom.stages[Capkom.getStagename()];
        stages = Capkom.getStages();
        next = stages[stages.indexOf(from) - 1];
        if (next !== void 0) {
          return Capkom.router.navigate(next.name, true);
        }
      });
      return Capkom.initNav();
    });
  });
}).call(this);
