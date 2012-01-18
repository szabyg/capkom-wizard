jQuery.widget "capkom.ttswidget",
    options:
        language: "de"
        backendUri: "http://dev.iks-project.eu/mary"
        backendType: "MARY"
        iconUri: "./speaker.gif"
        dialogTitle: "TTS widget"
        defaultText: "No text found"
        buttonLabel: "Speak"
    _init: ->
    _create: ->
        # Add button to the element
        @button = jQuery "<button class='tts-button'>#{@options.buttonLabel}</button>"
        @button.css "display", "relative"
        @button.css "top", "0"
        @button.css "right", "0"
        @button.css "margin", "8px"
        @button.appendTo @element
        @button.button
            text: false
            icons:
                primary: "ui-icon-speaker"
        @button.click =>
            @prepare()
            @talk()
    _destroy: ->
        @_cleanup()
        jQuery(@button)
        .button("destroy")
        .remove()
    prepare: ->
        @_cleanup()
    talk: ->
        @dialog = jQuery """
            <div id='ttswidget-dialog' title='#{@options.dialogTitle}'>
                #{@_getText()}
                <br/>
                <audio id='ttswidget-audio' onerror='console.error(this)' controls='controls' style='' src='#{@_makeLink()}' type='audio/ogg'>Your browser does not support the audio tag.</audio>
            </div>
        """
        @dialog.appendTo jQuery("body")
        @dialog.dialog
            close: =>
                @_cleanup()
            hide: "fade"
            width: "30%"
        @audioElement = jQuery("#ttswidget-audio")[0]
        @audioElement.onabort = () ->
            console.error attributes
        @audioElement.load()
        @audioElement.play()
        @audioElement.addEventListener 'ended', =>
            setTimeout =>
                @_cleanup()
            , 500

    _cleanup: ->
        jQuery("#ttswidget-dialog").dialog("destroy").remove()
    _getText: ->
        return @element.attr "tts" if @element.attr "tts"
        return @element.not(@button).text().replace("#{@options.buttonLabel}", "") if @element.text()
        return @options.defaultText
    _getLang: ->
        return @element.attr "lang" if @element.attr "lang"
        return @options.lang if @options.lang
    _getGender: ->
        return @element.attr "gender" if @element.attr "gender"
        return @options.gender if @options.gender
    preset: (lang="en", gender="male") ->
        presets = 
            "de-male": [
                    "LOCALE=de"
                    "VOICE=bits3"
                ]
            "de-female": [
                    "LOCALE=de"
                    "VOICE=bits1-hsmm"
                ]
            "en-male": [
                    "LOCALE=en_GB"
                    "VOICE=dfki-spike"
                ]
            "en-female": [
                    "LOCALE=en_GB"
                    "VOICE=dfki-prudence"
                ]
        res = presets["#{lang}-#{gender}"]
        console.error "There's no TTS preset defined for #{lang} and #{gender}." unless res
        return res or presets["de-female"]

    # Internal method for implementing the audio uri.
    _makeLink: () ->
        text = @_getText()
        uri = @options.backendUri + "/process?"
        params = @preset(@_getLang(), @_getGender())
        .concat [
            "INPUT_TYPE=TEXT&OUTPUT_TYPE=AUDIO&INPUT_TEXT=#{encodeURIComponent text}"
            "OUTPUT_TEXT="
            "effect_Volume_selected="
            "effect_Volume_parameters=" + encodeURI "amount:2.0;"
            "effect_Volume_default=Default"
            "effect_Volume_help=Help"
            "effect_TractScaler_selected="
            "effect_TractScaler_parameters" + encodeURI "amount:1.5;"
            "effect_TractScaler_default=Default"
            "effect_TractScaler_help=Help"
            "effect_F0Scale_selected="
            "effect_F0Scale_parameters=" + encodeURI "f0Scale:2.0;"
            "effect_F0Scale_default=Default"
            "effect_F0Scale_help=Help"
            "effect_F0Add_selected="
            "effect_F0Add_parameters=" + encodeURI "f0Add:50.0;"
            "effect_F0Add_default=Default"
            "effect_F0Add_help=Help"
            "effect_Rate_selected="
            "effect_Rate_parameters=" + encodeURI "durScale:1.5;"
            "effect_Rate_default=Default"
            "effect_Rate_help=Help"
            "effect_Robot_selected="
            "effect_Robot_parameters=" + encodeURI "amount:100.0;"
            "effect_Robot_default=Default"
            "effect_Robot_help=Help"
            "effect_Whisper_selected="
            "effect_Whisper_parameters=" + encodeURI "amount:100.0;"
            "effect_Whisper_default=Default"
            "effect_Whisper_help=Help"
            "effect_Stadium_selected="
            "effect_Stadium_parameters=" + encodeURI "amount:100.0"
            "effect_Stadium_default=Default"
            "effect_Stadium_help=Help"
            "effect_Chorus_selected="
            "effect_Chorus_parameters=" + encodeURI "delay1:466;amp1:0.54;delay2:600;amp2:-0.10;delay3:250;amp3:0.30"
            "effect_Chorus_default=Default"
            "effect_Chorus_help=Help"
            "effect_FIRFilter_selected="
            "effect_FIRFilter_parameters=" + encodeURI "type:3;fc1:500.0;fc2:2000.0"
            "effect_FIRFilter_default=Default"
            "effect_FIRFilter_help=Help"
            "effect_JetPilot_selected="
            "effect_JetPilot_parameters="
            "effect_JetPilot_default=Default"
            "effect_JetPilot_help=Help"
            "HELP_TEXT="
            "VOICE_SELECTIONS=bits3%20de%20male%20unitselection%20general"
            "AUDIO_OUT=WAVE_FILE"
            "AUDIO=WAVE_FILE"
        ]
        res = uri + params.join '&'
        res
