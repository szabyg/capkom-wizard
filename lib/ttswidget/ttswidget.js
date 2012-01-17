(function() {

  jQuery.widget("capkom.ttswidget", {
    options: {
      language: "de",
      backendUri: "http://dev.iks-project.eu/mary",
      backendType: "MARY",
      iconUri: "./speaker.gif",
      dialogTitle: "TTS widget",
      defaultText: "No text found",
      buttonLabel: "Speak"
    },
    _init: function() {},
    _create: function() {
      var _this = this;
      this.button = jQuery("<button class='tts-button'>" + this.options.buttonLabel + "</button>");
      this.button.css("display", "relative");
      this.button.css("top", "0");
      this.button.css("right", "0");
      this.button.css("margin", "8px");
      this.button.appendTo(this.element);
      this.button.button({
        text: false,
        icons: {
          primary: "ui-icon-speaker"
        }
      });
      return this.button.click(function() {
        _this.prepare();
        return _this.talk();
      });
    },
    _destroy: function() {
      this._cleanup();
      return jQuery(this.button).button("destroy").remove();
    },
    prepare: function() {
      return this._cleanup();
    },
    talk: function() {
      var _this = this;
      this.dialog = jQuery("<div id='ttswidget-dialog' title='" + this.options.dialogTitle + "'>\n    " + (this._getText()) + "\n    <audio id='ttswidget-audio' onerror='console.error(this)' controls='controls' style='' src='" + (this._makeLink()) + "' type='audio/ogg'>Your browser does not support the audio tag.</audio>\n</div>");
      this.dialog.appendTo(jQuery("body"));
      this.dialog.dialog({
        close: function() {
          return _this._cleanup();
        }
      });
      this.audioElement = jQuery("#ttswidget-audio")[0];
      this.audioElement.onabort = function() {
        return console.error(attributes);
      };
      this.audioElement.load();
      return this.audioElement.play();
    },
    _cleanup: function() {
      return jQuery("#ttswidget-dialog").dialog("destroy").remove();
    },
    _getText: function() {
      if (this.element.attr("tts")) return this.element.attr("tts");
      if (this.element.text()) {
        return this.element.not(this.button).text().replace("" + this.options.buttonLabel, "");
      }
      return this.options.defaultText;
    },
    _getLang: function() {
      if (this.element.attr("lang")) return this.element.attr("lang");
      if (this.options.lang) return this.options.lang;
    },
    _getGender: function() {
      if (this.element.attr("gender")) return this.element.attr("gender");
      if (this.options.gender) return this.options.gender;
    },
    preset: function(lang, gender) {
      var presets, res;
      if (lang == null) lang = "en";
      if (gender == null) gender = "male";
      presets = {
        "de-male": ["LOCALE=de", "VOICE=bits3"],
        "de-female": ["LOCALE=de", "VOICE=bits1-hsmm"],
        "en-male": ["LOCALE=en_GB", "VOICE=dfki-spike"],
        "en-female": ["LOCALE=en_GB", "VOICE=dfki-prudence"]
      };
      res = presets["" + lang + "-" + gender];
      if (!res) {
        console.error("There's no TTS preset defined for " + lang + " and " + gender + ".");
      }
      return res || presets["de-female"];
    },
    _makeLink: function() {
      var params, res, text, uri;
      text = this._getText();
      uri = this.options.backendUri + "/process?";
      params = this.preset(this._getLang(), this._getGender()).concat(["INPUT_TYPE=TEXT&OUTPUT_TYPE=AUDIO&INPUT_TEXT=" + (encodeURIComponent(text)), "OUTPUT_TEXT=", "effect_Volume_selected=", "effect_Volume_parameters=" + encodeURI("amount:2.0;"), "effect_Volume_default=Default", "effect_Volume_help=Help", "effect_TractScaler_selected=", "effect_TractScaler_parameters" + encodeURI("amount:1.5;"), "effect_TractScaler_default=Default", "effect_TractScaler_help=Help", "effect_F0Scale_selected=", "effect_F0Scale_parameters=" + encodeURI("f0Scale:2.0;"), "effect_F0Scale_default=Default", "effect_F0Scale_help=Help", "effect_F0Add_selected=", "effect_F0Add_parameters=" + encodeURI("f0Add:50.0;"), "effect_F0Add_default=Default", "effect_F0Add_help=Help", "effect_Rate_selected=", "effect_Rate_parameters=" + encodeURI("durScale:1.5;"), "effect_Rate_default=Default", "effect_Rate_help=Help", "effect_Robot_selected=", "effect_Robot_parameters=" + encodeURI("amount:100.0;"), "effect_Robot_default=Default", "effect_Robot_help=Help", "effect_Whisper_selected=", "effect_Whisper_parameters=" + encodeURI("amount:100.0;"), "effect_Whisper_default=Default", "effect_Whisper_help=Help", "effect_Stadium_selected=", "effect_Stadium_parameters=" + encodeURI("amount:100.0"), "effect_Stadium_default=Default", "effect_Stadium_help=Help", "effect_Chorus_selected=", "effect_Chorus_parameters=" + encodeURI("delay1:466;amp1:0.54;delay2:600;amp2:-0.10;delay3:250;amp3:0.30"), "effect_Chorus_default=Default", "effect_Chorus_help=Help", "effect_FIRFilter_selected=", "effect_FIRFilter_parameters=" + encodeURI("type:3;fc1:500.0;fc2:2000.0"), "effect_FIRFilter_default=Default", "effect_FIRFilter_help=Help", "effect_JetPilot_selected=", "effect_JetPilot_parameters=", "effect_JetPilot_default=Default", "effect_JetPilot_help=Help", "HELP_TEXT=", "VOICE_SELECTIONS=bits3%20de%20male%20unitselection%20general", "AUDIO_OUT=WAVE_FILE", "AUDIO=WAVE_FILE"]);
      res = uri + params.join('&');
      console.log(res);
      return res;
    }
  });

}).call(this);
