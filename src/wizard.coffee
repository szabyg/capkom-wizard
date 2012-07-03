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
        jQuery(".tts").ttswidget Capkom.getTTSOptions()
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

Capkom.canClick = ->
  console.info 'canClick: true'
  Capkom.profile.set canClick: true

jQuery('body').click ->
  @canClick()


Capkom.autoReadMode = ->
  Capkom.profile.get 'useAudio'

class Capkom.Timeout
  start: (secs, cb) ->
    @clear()
    run = =>
      @timer = null
      cb()
    @timer = setTimeout run, secs*1000
  clear: ->
    if @timer
      console.info "Cancel timeout"
      clearTimeout @timer
Capkom.timeout = new Capkom.Timeout

Capkom.audioOff = ->
  Capkom.canClick()
  console.info 'deactivate audio'
  Capkom.profile.set useAudio: false

Capkom.audioOn = ->
  Capkom.canClick()
  console.info 'activate audio'
  Capkom.profile.set useAudio: true

Capkom.getTTSOptions = ->
  spinnerUri: "css/spinner.gif"
  dialogTitle: "Sprechblase"
  lang: "de"
  forcedClose: ->
    Capkom.timeout.clear()
    Capkom.audioOff()
  manualActivate: ->
    Capkom.audioOn()
  active: not Capkom.profile.get "useAudio"
Capkom.symbolunderstandingQuestions = [
    question: 'hund.jpg', choices: ['futter.jpg', 'lolli.jpg', 'apfel.jpg'], correct: 'futter.jpg', type: 'su'
  ,
    question: 'baby.jpg', choices: ['auto.jpg', 'ei.jpg', 'kinderwagen.jpg'], correct: 'kinderwagen.jpg', type: 'su'
  ,
    question: 'apfel.jpg', choices: ['wasser.jpg', 'birne.jpg', 'kuchen.jpg'], correct: 'birne.jpg', type: 'su'
  ,
    question: 'baum.jpg', choices: ['apfel.jpg', 'dog.jpg', 'auto.jpg'], correct: 'apfel.jpg', type: 'su'
  ,
    question: 'flugzeug.jpg', choices: ['dog.jpg', 'ballon.jpg', 'cat.jpg'], correct: 'ballon.jpg', type: 'su'
  ]
Capkom.wordmatchQuestions = [
      type: 's2w' # symbol to word
      question: 'tree.jpg'
      choices: ['Baum', 'Haus', 'Hose']
      correct: 'Baum'
    ,
      type: 's2w' # symbol to word
      question: 'house.jpg'
      choices: ['Baum', 'Haus', 'Hose']
      correct: 'Haus'
    ,
      type: 's2w' # symbol to word
      question: 'pants.gif'
      choices: ['Baum', 'Haus', 'Hose']
      correct: 'Hose'
    ,
      type: 's2w'
      question: 'apfel.jpg'
      choices: ['Apfel', 'Hund', 'Erdbeere']
      correct: 'Apfel'
    ,
      type: 's2w' # symbol to word
      question: 'auto.jpg'
      choices: ['Hund', 'Erdbeere', 'Auto']
      correct: 'Auto'
    ,
      type: 's2w' # symbol to word
      question: 'ei.jpg'
      choices: ['Auto', 'Ei', 'Haus']
      correct: 'Ei'
    ,
      type: 's2w' # symbol to word
      question: 'rose.jpg'
      choices: ['Rose', 'Haus', 'Ei']
      correct: 'Rose'
    ,
      type: 's2w' # symbol to word
      question: 'erdbeere.jpg'
      choices: ['Katze', 'Erdbeere', 'Auto']
      correct: 'Erdbeere'
    ,
      type: 'w2s' # word to symbol
      question: 'Baum'
      choices: ['tree.jpg', 'pants.gif', 'house.jpg']
      correct: 'tree.jpg'
    ,
      type: 'w2s' # word to symbol
      question: 'Haus'
      choices: ['tree.jpg', 'pants.gif', 'house.jpg']
      correct: 'house.jpg'
    ,
      type: 'w2s' # word to symbol
      question: 'Hose'
      choices: ['tree.jpg', 'pants.gif', 'house.jpg']
      correct: 'pants.gif'
    ,
      type: 'w2s' # word to symbol
      question: 'Apfel'
      choices: ['cat.jpg', 'haus.jpg', 'apfel.jpg']
      correct: 'apfel.jpg'
    ,
      type: 'w2s' # word to symbol
      question: 'Auto'
      choices: ['tree.jpg', 'pants.gif', 'auto.jpg']
      correct: 'auto.jpg'
    ,
      type: 'w2s' # word to symbol
      question: 'Ei'
      choices: ['ei.jpg', 'haus.jpg', 'katze.jpg']
      correct: 'ei.jpg'
    ,
      type: 'w2s' # word to symbol
      question: 'Katze'
      choices: ['hund.jpg', 'katze.jpg', 'pants.gif']
      correct: 'katze.jpg'
    ,
      type: 'w2s' # word to symbol
      question: 'Schmetterling'
      choices: ['hund.jpg', 'schmetterling.jpg', 'tree.jpg']
      correct: 'schmetterling.jpg'
    ]
