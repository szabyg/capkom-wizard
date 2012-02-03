(function() {

  Capkom.initNav = function() {
    var i, stage, _ref, _renderStageTitle;
    jQuery("nav").html("");
    _renderStageTitle = function(stage) {
      return "<li><a class='stage-title capkom-label' symbolId='" + stage.name + "' href='#" + stage.name + "'>" + stage.title + "</a></li>";
    };
    _ref = Capkom.getStages();
    for (i in _ref) {
      stage = _ref[i];
      jQuery(".stages .titles").append(jQuery(_renderStageTitle(stage)));
      this.renderStage(stage, jQuery(".stages"));
    }
    jQuery(".stages").tabs({
      select: function(event, ui) {
        return window.location.hash = ui.tab.hash;
      }
    }).addClass('ui-tabs-vertical ui-helper-clearfix');
    Capkom.uiLoaded = true;
    Capkom.updateTTS();
    return Capkom.updateSymbols();
  };

  Capkom.renderStage = function(stage, tabsEl, index) {
    var el, _renderStage,
      _this = this;
    _renderStage = function(stage) {
      var _ref;
      return "<div id=\"" + stage.name + "\">\n    <table class=\"ui-widget-content\"><tr><td style=\"vertical-align: top;padding: 1em;\">\n        <div>\n            <img width=\"200\" class=\"stage-image " + ((_ref = stage.image) != null ? _ref : {
        '': 'hidden'
      }) + "\" alt=\"Wizard Bild\" src=\"" + stage.image + "\" />\n        </div>\n    </td><td>\n        <div style=\"padding: 5px 15px;\">\n            <span class=\"stage-content tts\" lang=\"de\">" + stage.html + "</span>\n        </div>\n        <div class=\"buttons\">\n            <button class=\"prevButton\" alt=\"Zurück\">Zurück</button>\n            <button class=\"nextButton\" alt=\"Weiter\">Weiter</button>\n        </div>\n    </td></tr></table>\n</div>";
    };
    el = null;
    if (tabsEl.find(".ui-tabs-panel").length && index) {
      el = jQuery(_renderStage(stage)).insertBefore(jQuery(tabsEl.find(".ui-tabs-panel")[index]));
    } else {
      el = jQuery(_renderStage(stage)).appendTo(tabsEl);
    }
    if (stage.script) stage.script(jQuery(".stage-content", el));
    jQuery(".prevButton", el).button().click(function() {
      var newIndex;
      newIndex = jQuery(".stages").find("ul.titles .ui-tabs-active").prev().index();
      return jQuery(".stages").tabs("select", newIndex);
    });
    jQuery(".nextButton", el).button().click(function() {
      var newIndex;
      newIndex = jQuery(".stages").find("ul.titles .ui-tabs-active").next().index();
      return jQuery(".stages").tabs("select", newIndex);
    });
    if (stage.speech) jQuery(".stage-content.tts", el).attr("tts", stage.speech);
    return el;
  };

}).call(this);
