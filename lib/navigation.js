(function() {
  var Capkom, _ref;
  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};
  Capkom.RouterClass = Backbone.Router.extend({
    initialize: function(options) {
      var route, stage, stagename, _ref2, _results;
      _ref2 = Capkom.stages;
      _results = [];
      for (stagename in _ref2) {
        stage = _ref2[stagename];
        route = stage.route;
        if (route === void 0) {
          route = stagename;
        }
        _results.push(this.route(route, stagename, function() {
          return _.defer(function() {
            var locRoute, newStage;
            locRoute = window.location.hash;
            stagename = Capkom.getStagename();
            newStage = Capkom.stages[stagename];
            jQuery(".stage-title").html(newStage.title);
            jQuery(".stage-content").html(newStage.html);
            if (newStage.image) {
              jQuery(".stage-image").show().attr("src", newStage.image);
            } else {
              jQuery(".stage-image").hide();
            }
            if (newStage.script) {
              return newStage.script(jQuery(".stage-content"));
            }
          });
        }));
      }
      return _results;
    }
  });
}).call(this);
