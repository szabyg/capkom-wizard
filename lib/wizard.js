(function() {
  var Capkom, _ref;
  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};
  Capkom.getStagename = function() {
    return window.location.hash.replace(/^#/, "");
  };
  jQuery(document).ready(function() {
    return _.defer(function() {
      return Capkom.loadProfile(function() {
        Capkom.router = new Capkom.RouterClass;
        if (!Backbone.history.start()) {
          Capkom.router.navigate(Capkom.order[0], true);
        }
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
  });
}).call(this);
