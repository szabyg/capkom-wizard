# This module controls the speech output of the wizard. 
# The backend being used is the MARY Text-to-Speech System developed by DFKI.
class Capkom.Speech
    constructor: (options) ->
        @options = _.extend @options, options

    # Default parameters defined (to be extended if necessary)
    options:
        maryBaseUri: "http://dev.iks-project.eu/mary"
        robotSelected: true

    # For letting the computer speak a new text
    say: (text) ->
        @_init() unless jQuery("#speech").length
        jQuery( @el ).attr "src", @_makeLink @text = text
        @el.load()
        @el.play()

    # Repeat the last text (if any).
    repeat: ->
        @el.currentTime = 0
        @el.load()
        @el.play()

    # Remove last text.
    clear: ->
        jQuery( @el ).attr "src", ""

    # Module initialisation makes sure the existence of an HTML5 audio element
    _init: ->
        @el = jQuery("#speech")[0]
        unless @el
            @el = jQuery('<audio id="speech" controls="controls" style="display:none;" src="" type="audio/ogg">Your browser does not support the audio tag.</audio>')
            .appendTo('body')[0]

    # Internal method for implementing the audio uri.
    _makeLink: (text) ->
        @options.maryBaseUri + "/process?" + [
            "INPUT_TYPE=TEXT&OUTPUT_TYPE=AUDIO&INPUT_TEXT=#{encodeURIComponent text}"
            "LOCALE=de"
            "VOICE=bits3"
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
            "effect_Robot_selected=" + (@options.robotSelected ? "on" : "")
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
        ].join '&'

