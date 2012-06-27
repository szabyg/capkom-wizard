# Capkom Wizard is freely distributable under the MIT license.

# Author: [Szaby Gruenwald](https://github.com/szabyg) ([Salzburg Research Forschungsgesellschaft mbH](http://www.salzburgresearch.at/))
# 
# This is the central module initializing all the other depending modules.

Capkom = this.Capkom ?= {}

# Register async process to be waited for.
Capkom.waitForMe = ->
    @_wait ?= []
    i = @_wait.length
    Capkom.console.info "Waiting for ##{i}.."
    @_wait[i] = 
        ready: false
    ->
        Capkom.console.info "##{i} is ready"
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

#        Backbone.history.start
#            pushState: true

# Getter for the name of the actual stage.
Capkom.getStagename = ->
    window.location.hash.replace /^#/, ""

# initialize or destroy tts widget depending on the profile state
Capkom.updateTTS = ->
    if Capkom.uiLoaded
        jQuery(".tts").ttswidget
            spinnerUri: "css/spinner.gif"
            dialogTitle: "Sprechblase"
            forceQuit: ->
              Capkom.audioOff()
            manualActivate: ->
              Capkom.audioOn()
            disabled: not Capkom.profile.get "useAudio"
    else
        jQuery(":capkom-ttswidget").ttswidget('option', 'disabled', true)

# Make sure no console.info or .error calls on 
if window.console
    Capkom.console = console
else
    Capkom.console = Capkom.console =
        info: ->
        error: ->
        log: ->


Capkom.clickNext = ->
  activeTab = jQuery('.ui-tabs-panel').filter (e, el) ->
    jQuery(el).css('display') != 'none'
  jQuery('.nextButton', activeTab).trigger 'click'

Capkom.nonClickMode = ->
  not Capkom.profile.get 'canClick'

jQuery('body').click ->
  Capkom.profile.set canClick: true

Capkom.autoReadMode = ->
  Capkom.profile.get 'useAudio'

class Capkom.Timeout
  start: (secs, cb) ->
    @clear()
    # @timer = setTimeout cb, secs*1000
  clear: ->
    if @timer
      console.info "Cancel timeout"
      clearTimeout @timer
Capkom.timeout = new Capkom.Timeout

Capkom.audioOff = ->
  console.info 'deactivate audio'
  Capkom.profile.set useAudio: false

Capkom.audioOn = ->
  console.info 'activate audio'
  Capkom.profile.set useAudio: true
