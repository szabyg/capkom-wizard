(function() {
  var Capkom, _ref;
  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};
  Capkom.getStagename = function() {
    var locRoute, result;
    result = null;
    locRoute = window.location.hash.replace(/^#/, "");
    _(Capkom.stages).find(function(stage, routename) {
      if (stage.route === locRoute || routename === locRoute) {
        return result = routename;
      }
    });
    return result;
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
      return jQuery("#nextButton").button().click(function() {
        var from, next;
        from = Capkom.getStagename();
        next = Capkom.order[Capkom.order.indexOf(from) + 1];
        if (next !== void 0) {
          return Capkom.router.navigate(next, true);
        }
      });
    });
  });
}).call(this);
