# Capkom Wizard is freely distributable under the MIT license.

# Author: [Szaby Gruenwald](https://github.com/szabyg) ([Salzburg Research Forschungsgesellschaft mbH](http://www.salzburgresearch.at/))
# 
# This is the central module initializing all the other depending modules.

Capkom = this.Capkom ?= {}

# Startup wizard
jQuery(document).ready -> _.defer ->
    # Load the profile and when it's done initialize the wizard UI
    Capkom.loadProfile ->
        # Initialize navigation bar
        do Capkom.initNav
        # Initialize tts widgets
        Capkom.updateTTS()
        # Initialize capkomSymbol widgets
        jQuery('.capkom-label').capkomSymbol
            profile: Capkom.profile

    # Init the #loadingDiv element
    jQuery('#loadingDiv')
    .ajaxStart(->
        jQuery(this).show()
    )
    .ajaxStop ->
        jQuery(this).hide()

# Getter for the name of the actual stage.
Capkom.getStagename = ->
    window.location.hash.replace /^#/, ""

# initialize or destroy tts widget depending on the profile state
Capkom.updateTTS = ->
    if Capkom.uiLoaded
        if Capkom.profile.get "useAudio"
            jQuery(".tts").ttswidget
                spinnerUri: "css/spinner.gif"
                dialogTitle: "Sprechblase"
        else
            jQuery(":capkom-ttswidget").ttswidget("destroy")


unless @console
    @console = 
        debug: ->
        info: ->
        log: ->
        error: ->
