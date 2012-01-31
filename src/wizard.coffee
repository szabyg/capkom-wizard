# This is the central module initializing all the other depending modules.
Capkom = window.Capkom ?= {}
Capkom.test = ->
    console.info "called"
    false

# Startup wizard
jQuery(document).ready -> _.defer ->
    jQuery('#loadingDiv')
    .ajaxStart(->
        jQuery(this).show()
    )
    .ajaxStop ->
        jQuery(this).hide()

    Capkom.loadProfile ->
        # Initialize navigation bar
        do Capkom.initNav

# Getter for the name of the actual stage.
Capkom.getStagename = ->
    window.location.hash.replace /^#/, ""

Capkom.updateTTS = ->
    if Capkom.uiLoaded
        if Capkom.profile.get "useAudio"
            jQuery(".tts").ttswidget
                spinnerUri: "css/spinner.gif"
        else
            jQuery(":capkom-ttswidget").ttswidget("destroy")

Capkom.updateSymbols = ->
    if Capkom.uiLoaded
        if Capkom.profile.get "useSymbols"
            jQuery(".symbol").show()
        else
            jQuery(".symbol").hide()

