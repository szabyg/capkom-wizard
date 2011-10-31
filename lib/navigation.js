(function() {
  var Capkom, _ref;
  Capkom = (_ref = window.Capkom) != null ? _ref : window.Capkom = {};
  Capkom.initNav = function() {
    var i, stage, _ref2;
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
    jQuery("nav").html("");
    _ref2 = Capkom.getStages();
    for (i in _ref2) {
      stage = _ref2[i];
      jQuery("nav").append(jQuery("<input type='radio' name='capkom-wizard-nav' id='nav-" + stage.name + "'/>\n<label for='nav-" + stage.name + "'>" + (1 + Number(i)) + ". " + stage.title + "</label>"));
    }
    jQuery("input#nav-" + (Capkom.getStagename())).attr("checked", "checked");
    jQuery("nav").buttonset();
    return jQuery("nav input").click(function() {
      return Capkom.router.navigate(this.id.replace("nav-", ""), true);
    });
  };
  Capkom.RouterClass = Backbone.Router.extend({
    initialize: function(opts) {
      var i, stage, _ref2, _results;
      _ref2 = Capkom.getStages();
      _results = [];
      for (i in _ref2) {
        stage = _ref2[i];
        _results.push(this.route(stage.name, stage.name, function() {
          return _.defer(function() {
            var locRoute, newStage, stagename;
            locRoute = window.location.hash;
            stagename = Capkom.getStagename();
            if (Capkom.order.indexOf(stagename) === 0) {
              jQuery("#prevButton").hide();
            } else {
              jQuery("#prevButton").show();
            }
            newStage = Capkom.stages[stagename];
            jQuery(".stage-title").html(newStage.title);
            jQuery(".stage-content").html(newStage.html);
            if (newStage.image) {
              jQuery(".stage-image").show().attr("src", newStage.image);
            } else {
              jQuery(".stage-image").hide();
            }
            if (newStage.script) {
              newStage.script(jQuery(".stage-content"));
            }
            return Capkom.initNav();
          });
        }));
      }
      return _results;
    }
  });
}).call(this);
