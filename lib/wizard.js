(function() {
  var Capkom, _ref;

  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};

  jQuery(document).ready(function() {
    return _.defer(function() {
      return Capkom.loadProfile(function() {
        Capkom.router = new Capkom.RouterClass;
        return Capkom.initNav();
      });
    });
  });

  Capkom.getStagename = function() {
    return window.location.hash.replace(/^#/, "");
  };

}).call(this);
