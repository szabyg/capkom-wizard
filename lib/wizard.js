(function() {
  var Capkom, _ref;

  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};

  jQuery(document).ready(function() {
    return _.defer(function() {
      Capkom.loadProfile(function() {
        Capkom.router = new Capkom.RouterClass;
        Capkom.speech = new Capkom.Speech;
        if (!Backbone.history.start()) {
          Capkom.router.navigate(Capkom.order[0], true);
        }
        jQuery("section").accordion({
          autoHeight: false
        });
        return Capkom.initNav();
      });
      return jQuery(".audioButton").bind("click", function() {
        return Capkom.speech.repeat();
      });
    });
  });

  Capkom.getStagename = function() {
    return window.location.hash.replace(/^#/, "");
  };

}).call(this);
