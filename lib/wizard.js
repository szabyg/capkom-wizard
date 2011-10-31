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
        return Capkom.initNav();
      });
    });
  });
}).call(this);
