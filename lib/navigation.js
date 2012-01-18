(function() {

  Capkom.initNav = function() {
    var el, i, stage, _ref, _renderStage, _renderStageTitle;
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
    _renderStageTitle = function(stage) {
      return "<li><a class=\"stage-title\" href=\"#" + stage.name + "\">" + stage.title + "</a></li>";
    };
    _renderStage = function(stage) {
      var _ref;
      return "<div id=\"" + stage.name + "\">\n    <div style=\"float:left;\"><img width=\"200\" class=\"stage-image " + ((_ref = stage.image) != null ? _ref : {
        '': 'hidden'
      }) + "\" alt=\"Wizard Bild\" src=\"" + stage.image + "\" /></div>\n    <div style=\"float:left; padding: 5px 15px;\">\n        <span class=\"stage-content tts\" lang=\"de\" tts=\"" + stage.speech + "\">" + stage.html + "</span>\n    </div>\n</div>";
    };
    _ref = Capkom.getStages();
    for (i in _ref) {
      stage = _ref[i];
      jQuery(".stages .titles").append(jQuery(_renderStageTitle(stage)));
      el = jQuery(_renderStage(stage)).appendTo(jQuery(".stages"));
      if (stage.script) stage.script(jQuery(".stage-content", el));
    }
    return jQuery(".stages").tabs();
  };

}).call(this);
