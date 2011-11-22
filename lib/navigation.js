
  Capkom.initNav = function() {
    var i, stage, _ref;
    jQuery("#nextButton").button({
      icons: {
        secondary: "ui-icon-arrowthick-1-e"
      }
    }).click(function(e) {
      var from, next, stages;
      from = Capkom.stages[Capkom.getStagename()];
      stages = Capkom.getStages();
      next = stages[_.indexOf(stages, from) + 1];
      if (next !== void 0) Capkom.router.navigate(next.name, true);
      return e.stopImmediatePropagation();
    });
    jQuery("#prevButton").button({
      icons: {
        primary: "ui-icon-arrowthick-1-w"
      }
    }).click(function(e) {
      var from, next, stages;
      from = Capkom.stages[Capkom.getStagename()];
      stages = Capkom.getStages();
      next = stages[_.indexOf(stages, from) - 1];
      if (next !== void 0) Capkom.router.navigate(next.name, true);
      return e.stopImmediatePropagation();
    });
    jQuery("nav").html("");
    _ref = Capkom.getStages();
    for (i in _ref) {
      stage = _ref[i];
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
      var i, stage, _ref, _results;
      _ref = Capkom.getStages();
      _results = [];
      for (i in _ref) {
        stage = _ref[i];
        _results.push(this.route(stage.name, stage.name, function() {
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
          if (newStage.speech) {
            Capkom.speech.say(newStage.speech);
          } else {
            Capkom.speech.clear();
          }
          if (newStage.script) newStage.script(jQuery(".stage-content"));
          return Capkom.initNav();
        }));
      }
      return _results;
    }
  });
