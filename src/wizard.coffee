# Capkom Wizard is freely distributable under the MIT license.

# Author: [Szaby Gruenwald](https://github.com/szabyg) ([Salzburg Research Forschungsgesellschaft mbH](http://www.salzburgresearch.at/))
# 
# This is the central module initializing all the other depending modules.

Capkom = this.Capkom ?= {}

# Register async process to be waited for. Used to make sure that the symbolsets are loaded before
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
  Capkom.console.info 'canClick: true'
  Capkom.profile.set canClick: true

jQuery('body').click ->
  @canClick()


Capkom.autoReadMode = ->
  Capkom.profile.get 'useAudio'

class Capkom.Timeout
  start: (secs, cb) ->
    Capkom.console.info "Capkom.Timeout: Wait for #{secs} seconds..."
    @clear()
    run = =>
      @timer = null
      Capkom.console.info "Capkom.Timeout: Time over, go on."
      cb()
    @timer = setTimeout run, secs*1000
  clear: ->
    if @timer
      Capkom.console.info "Cancel timeout"
      clearTimeout @timer
Capkom.timeout = new Capkom.Timeout

Capkom.audioOff = ->
  Capkom.canClick()
  Capkom.console.info 'deactivate audio'
  Capkom.profile.set useAudio: false

Capkom.audioOn = ->
  Capkom.canClick()
  Capkom.console.info 'activate audio'
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
    question: 'hund.jpg', choices: ['futter.jpg', 'lolli.jpg', 'apfel.jpg'], correct: 'futter.jpg', type: 'symbolunderstanding'
  ,
    question: 'baby.jpg', choices: ['auto.jpg', 'ei.jpg', 'kinderwagen.jpg'], correct: 'kinderwagen.jpg', type: 'symbolunderstanding'
  ,
    question: 'apfel.jpg', choices: ['wasser.jpg', 'birne.jpg', 'kuchen.jpg'], correct: 'birne.jpg', type: 'symbolunderstanding'
  ,
    question: 'baum.jpg', choices: ['apfel.jpg', 'dog.jpg', 'auto.jpg'], correct: 'apfel.jpg', type: 'symbolunderstanding'
  ,
    question: 'flugzeug.jpg', choices: ['dog.jpg', 'ballon.jpg', 'cat.jpg'], correct: 'ballon.jpg', type: 'symbolunderstanding'
  ]
Capkom.wordmatchQuestions = [
      type: 'symbol2word' # symbol to word
      question: 'tree.jpg'
      choices: ['Baum', 'Haus', 'Hose']
      correct: 'Baum'
    ,
      type: 'symbol2word' # symbol to word
      question: 'house.jpg'
      choices: ['Baum', 'Haus', 'Hose']
      correct: 'Haus'
    ,
      type: 'symbol2word' # symbol to word
      question: 'pants.gif'
      choices: ['Baum', 'Haus', 'Hose']
      correct: 'Hose'
    ,
      type: 'symbol2word'
      question: 'apfel.jpg'
      choices: ['Apfel', 'Hund', 'Erdbeere']
      correct: 'Apfel'
    ,
      type: 'symbol2word' # symbol to word
      question: 'auto.jpg'
      choices: ['Hund', 'Erdbeere', 'Auto']
      correct: 'Auto'
    ,
      type: 'symbol2word' # symbol to word
      question: 'ei.jpg'
      choices: ['Auto', 'Ei', 'Haus']
      correct: 'Ei'
    ,
      type: 'symbol2word' # symbol to word
      question: 'rose.jpg'
      choices: ['Rose', 'Haus', 'Ei']
      correct: 'Rose'
    ,
      type: 'symbol2word' # symbol to word
      question: 'erdbeere.jpg'
      choices: ['Katze', 'Erdbeere', 'Auto']
      correct: 'Erdbeere'
    ,
      type: 'word2symbol' # word to symbol
      question: 'Baum'
      choices: ['tree.jpg', 'pants.gif', 'house.jpg']
      correct: 'tree.jpg'
    ,
      type: 'word2symbol' # word to symbol
      question: 'Haus'
      choices: ['tree.jpg', 'pants.gif', 'house.jpg']
      correct: 'house.jpg'
    ,
      type: 'word2symbol' # word to symbol
      question: 'Hose'
      choices: ['tree.jpg', 'pants.gif', 'house.jpg']
      correct: 'pants.gif'
    ,
      type: 'word2symbol' # word to symbol
      question: 'Apfel'
      choices: ['cat.jpg', 'haus.jpg', 'apfel.jpg']
      correct: 'apfel.jpg'
    ,
      type: 'word2symbol' # word to symbol
      question: 'Auto'
      choices: ['tree.jpg', 'pants.gif', 'auto.jpg']
      correct: 'auto.jpg'
    ,
      type: 'word2symbol' # word to symbol
      question: 'Ei'
      choices: ['ei.jpg', 'haus.jpg', 'katze.jpg']
      correct: 'ei.jpg'
    ,
      type: 'word2symbol' # word to symbol
      question: 'Katze'
      choices: ['hund.jpg', 'katze.jpg', 'pants.gif']
      correct: 'katze.jpg'
    ,
      type: 'word2symbol' # word to symbol
      question: 'Schmetterling'
      choices: ['hund.jpg', 'schmetterling.jpg', 'tree.jpg']
      correct: 'schmetterling.jpg'
    ]
Capkom.lookforcorrectQuestions = [
      type: 'color'
      question: 'dog.jpg'
      choices: ['dog.jpg', 'mod/dog1.jpg', 'mod/dog2.jpg']
      correct: 'dog.jpg'
    ,
      type: 'b&w'
      question: 'mod/dogsw.jpg'
      choices: ['mod/dogsw.jpg', 'mod/dog1sw.jpg', 'mod/dog2sw.jpg']
      correct: 'mod/dogsw.jpg'
    ,
      type: 'color'
      question: 'flugzeug.jpg'
      choices: ['flugzeug.jpg', 'mod/flugzeug1.jpg', 'mod/flugzeug2.jpg']
      correct: 'flugzeug.jpg'
    ,
      type: 'b&w'
      question: 'mod/flugzeugsw.jpg'
      choices: ['mod/flugzeugsw.jpg', 'mod/flugzeug1sw.jpg', 'mod/flugzeug2sw.jpg']
      correct: 'mod/flugzeugsw.jpg'
    ,
      type: 'color'
      question: 'rose.jpg'
      choices: ['rose.jpg', 'mod/rose1.jpg', 'mod/rose2.jpg']
      correct: 'rose.jpg'
    ,
      type: 'b&w'
      question: 'mod/rosesw.jpg'
      choices: ['mod/rosesw.jpg', 'mod/rose1sw.jpg', 'mod/rose2sw.jpg']
      correct: 'mod/rosesw.jpg'
    ,
    ]
jQuery(document).ready ->
  # Preload
  _.defer ->
    jQuery(['lib/sizedetect/aron.png', 'lib/sizedetect/futter.png']).preload()
    dir = 'lib/wordmatch/img/'
    jQuery(["#{dir}apfel.jpg", "#{dir}cat.jpg", "#{dir}futter.jpg", "#{dir}kuchen.jpg", "#{dir}schwein.jpg",
    "#{dir}auto.jpg", "#{dir}dog.jpg", "#{dir}haus.jpg", "#{dir}labrador.jpg", "#{dir}tree.jpg",
    "#{dir}baby.jpg", "#{dir}drache.jpg", "#{dir}house.jpg", "#{dir}lolli.jpg", "#{dir}wasser.jpg",
    "#{dir}ballon.jpg", "#{dir}ei.jpg", "#{dir}hund.jpg", "#{dir}pants.gif",
    "#{dir}baum.jpg", "#{dir}erdbeere.jpg", "#{dir}katze.jpg", "#{dir}rose.jpg",
    "#{dir}birne.jpg", "#{dir}flugzeug.jpg", "#{dir}kinderwagen.jpg", "#{dir}schmetterling.jpg"]).preload()
    jQuery(["#{dir}/mod/dogsw.jpg", "#{dir}/mod/dog1sw.jpg", "#{dir}/mod/dog2sw.jpg", "#{dir}/mod/dog1.jpg", "#{dir}/mod/dog2.jpg",
    "#{dir}/mod/flugzeugsw.jpg", "#{dir}/mod/flugzeug1sw.jpg", "#{dir}/mod/flugzeug2sw.jpg", "#{dir}/mod/flugzeug1.jpg", "#{dir}/mod/flugzeug2.jpg",
    "#{dir}/mod/rosesw.jpg", "#{dir}/mod/rose1sw.jpg", "#{dir}/mod/rose2sw.jpg", "#{dir}/mod/rose1.jpg", "#{dir}/mod/rose2.jpg", ]).preload
document.ondragstart = -> false

# Capkom.getDimensions