# Capkom Wizard is freely distributable under the MIT license.

# Author: [Szaby Gruenwald](https://github.com/szabyg) ([Salzburg Research Forschungsgesellschaft mbH](http://www.salzburgresearch.at/))
# 
# This is the central module initializing all the other depending modules.

Capkom = this.Capkom ?= {}

# Register async process to be waited for.
Capkom.waitForMe = ->
    @_wait ?= []
    i = @_wait.length
    @_wait[i] = 
        ready: false
    ->
        Capkom._wait[i].ready = true
        Capkom._oneDone()

# Register callback for being run once, when all async requests are finished
Capkom.once = (cb) ->
    @_once[@_once.length] =
        done: false
        cb: cb
    @_oneDone()
Capkom._once ?= []
# Trigger check of waiting async processes. If empty, run all waiting callbacks
Capkom._oneDone = ->
    stillWaiting = _(@_wait).detect (w) -> 
        not w.ready
    unless stillWaiting
        for once in Capkom._once
            unless once.done
                once.done = true
                once.cb()
# Startup wizard
jQuery(document).ready -> _.defer ->
    Capkom.once ->
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
