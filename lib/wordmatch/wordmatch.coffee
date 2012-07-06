# Initialize Capkom object
Capkom = this.Capkom ?= {}

# Adds a symbol to a Capkom UI. Depending on the profile and the symbolset 
# the symbol can come from different symbolsets and have different sizes.
# Easiest usage would be this:
#
#     <div id="sizedetect-container"></div>
#
#     jQuery("#sizedetect-container").sizedetect({
#       result: function(size){
#          // code to set profile parameter
#       }
#     });
# That causes a lookup for the `welcome` symbol in the defined 
# symbolsets in the defined size.

jQuery.widget "Capkom.wordmatch"
  # Options:
  options:
      # By default `Capkom.profile` is used for getting the selected symbolset,
      # size and to be informed about profile changes.
      profile: Capkom.profile
      result: (details) ->
        console.info 'detailed results:', details
      symbolSize: 150
      numberOfQuestions: 3
      rootPrefix: 'img/'
      feedbackPos: ['Good!', 'Great!', 'Perfect!', 'Super!', 'Well done!']
      questions: [
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
        ###
        type: 's2w' # symbol to word
        question: 'tree.jpg'
        choices: ['Baum', 'Haus', 'Hose']
        correct: 'Baum'
      ,
        type: 's2w',
        question: 'house.jpg'
        choices: ['Baum', 'Haus', 'Hose']
        correct: 'Haus'
      ,
        type: 's2w',
        question: 'pants.gif'
        choices: ['Baum', 'Haus', 'Hose']
        correct: 'Hose'
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
      ]
      ###
  _create: ->
    @_fixConsole()
    # widget styling
    @_savedCSS =
      position: @element.css 'position'
      top: @element.css 'top'
      bottom: @element.css 'bottom'
      left: @element.css 'left'
      right: @element.css 'right'
      'z-index': @element.css 'z-index'
      'background-color': @element.css 'background-color'

    @element.css
      # position: 'absolute'
      top: '5px'
      bottom: '5px'
      left: '5px'
      right: '5px'
      'background-color': ''
      'z-index': 100

    @element.addClass 'wordmatch-container ui-widget-content'
    @element.append "<div class='progressBar'></div>"
    @progressBar = @element.find ".progressBar"
    @progressBar.css
      'float': 'right'
      'width': '50%'
    @progressBar.progressbar()

    @element.append """
      <div class='play-area'>
        <table style="width: 100%;">
          <tr><td><div class='question-area'></div></td></tr>
          <tr><td><div class='answer-area' style='text-align: center'></div></td></tr>
        </table>
      </div>
    """
    @playArea = @element.find '.play-area'
    @questionArea = @element.find '.question-area'
    @answerArea = @element.find '.answer-area'

    @questionArea.css
      'text-align': 'center'

    @element.append "<div class='msg-dialog'></div>"
    @messageArea = @element.find '.msg-dialog'

    # escape keypress
    jQuery('body').bind 'keyup', widget: @, @_escHandler

    # everything set up, begin the game
    @_beginGame()

  _destroy: ->
    @element.html ""
    @element.removeClass 'wordmatch-container ui-widget-content'
    @element.css @_savedCSS
    # escape keypress
    jQuery('body').unbind 'keyup', @_escHandler

  _beginGame: ->
    # prepare sequence
    @results = {}
    @sequence = []
    for type in @getQuestionTypes()
      @sequence = @sequence.concat @_shuffle(_(@options.questions).filter((q) -> q.type is type)).slice 0, @options.numberOfQuestions
      @results[type] =
        correct: 0
        wrong: 0
        times: new Stat

    @sequence = @_shuffle @sequence
    @console.info 'questions', _.map @sequence, (q) -> q.question
    @timer = new StopWatch @console.error
    @_renderNext()

  getQuestionTypes: ->
    _.uniq(_.map(@options.questions, (q) -> q.type))

  _renderQuestion: (question = @question) ->
    res = ''
    if question.question.match /\.(jpg|png|gif)$/
      res = "<img class='question' src='#{@options.rootPrefix}#{question.question}' style='height:#{@options.symbolSize}px;padding:1em;'/>"
    else
      res = "<h1 style='padding:2ex; text-align:center; font-size:140%;'>#{question.question}</h1>"
    res

  _renderAnswers: (question = @question) ->
    res = ''
    if question.choices[0].match /\.(jpg|png|gif)$/
      for choice in @_shuffle @question.choices
        res += """
          <button value='#{choice}' width='#{@options.symbolSize} height='#{@options.symbolSize}' style='margin: 1ex;'>
            <img class='choice' src='#{@options.rootPrefix}#{choice}' style='height:#{@options.symbolSize}px;'/>
          </button>
        """
    else
      for choice in @_shuffle question.choices
        res += "<button value='#{choice}' width='#{@options.symbolSize} height='#{@options.symbolSize}' style='margin:1ex;'>#{choice}</button>"
    res

  _renderNext: ->
    @updateProgress()
    @answerArea.html ''
    if @sequence.length
      @question = @sequence.shift()
      @currentResultContainer = @results[@question.type]
      @questionArea.html @_renderQuestion()
      @answerArea.html @_renderAnswers()

      @buttonsDisabled = false
      @playArea.find('button')
      .button()
      .css
        minWidth: @options.symbolSize
        minHeight: @options.symbolSize
      .click (e) =>
        unless @buttonsDisabled
          @buttonsDisabled = true
          attempt = jQuery(e.currentTarget).attr('value')
          if attempt is @question.correct
            @currentResultContainer.times.add @timer.end()
            @currentResultContainer.correct++
            jQuery(e.currentTarget).css
              'border': 'lightgreen 5px solid'
            @message @getAPositiveFeedback(), =>
              @buttonsDisabled = false
              @_renderNext()
            , 'correct'
          else
            @currentResultContainer.wrong++
            jQuery(e.currentTarget).css
              'border': 'red 5px solid'
            @message "Leider falsch.. Versuch's noch einmal!", =>
              @buttonsDisabled = false
              jQuery(e.currentTarget).css
                'border': ''
            , 'wrong'
      @timer.start()
    else
      @finish()
  getAPositiveFeedback: ->
    @options.feedbackPos[Math.floor(@options.feedbackPos.length * Math.random())]
  message: (msg, cb, styleClass='') ->
    @messageArea.html(msg).dialog
      hide: "fade"
      close: =>
        _.defer =>
          @messageArea.dialog 'destroy'
          cb()
      dialogClass: "shortmessage #{styleClass}"
      modal: true
    afterWaiting = =>
      @messageArea.dialog('close')

    setTimeout afterWaiting, 1500
  finish: ->
    @playArea.html ''
    @element.css @_savedCSS
    for type in @getQuestionTypes()
      @results[type].score = @results[type].correct / (@results[type].correct + @results[type].wrong)
      @results[type].times = @results[type].times.getStatistics()

    @message "Gratuliere, das war's schon!", =>
      @options.result @results
    @destroy()

  getInnerWidth: ->
    return jQuery(window).width()
    if jQuery.browser.msie
      screen.availWidth
    else
      window.innerWidth

  getInnerHeight: ->
    return jQuery(window).height()
    if jQuery.browser.msie
      screen.availHeight
    else
      window.innerHeight

  _fixConsole: ->
    if window.console
      @console = console
    else
      @console =
        info: ->
        error: ->
        log: ->
  _shuffle: (v) ->
    # http://jsfromhell.com/array/shuffle
    _.shuffle v

  updateProgress: ->
    val = (@options.numberOfQuestions - @sequence.length) / @options.numberOfQuestions * 100
    @progressBar.progressbar 'value', val

  _escHandler: (e) =>
    if e.keyCode is 27
      # e.data.widget.finish()
      e.data.widget.destroy()

# Class for calculating simple statistical data
class Stat
  constructor: (opts) ->
    options =
      dropMargins: true
    @options = _.extend options, opts
    @_values = []
  getSamples: ->
    if @options.dropMargins
      res = _.sortBy @_values, (v) -> v
      return res.slice 1, -1
    else
      return @_values
  add: (val) ->
    @_values.push val
  length: ->
    @_values.length
  clear: ->
    @_values = []
  getAverage: ->
    sum = 0
    smpls = @getSamples()
    _.each smpls, (val) ->
      sum += val
    sum / smpls.length
  getVariance: ->
    av = @getAverage()
    smpls = @getSamples()
    v = 0
    _.each smpls, (val) ->
      v += (av - val) * (av - val)
    v = v / smpls.length
  getStandardDeviation: ->
    Math.sqrt @getVariance()
  getStatistics: ->
    average: @getAverage()
    variance: @getVariance()
    standardDeviation: @getStandardDeviation()

# Class for measuring time in milliseconds
class StopWatch
  constructor: (@error = -> @console.error.apply @console, arguments) ->
    @elapsed = 0
    @status = 'idle'
  start: ->
    if @status is 'idle'
      @startTime = new Date().getTime()
      @status = 'running'
    else
      @error "Already running!"
  stop: ->
    if @status is 'running'
      @elapsed += new Date().getTime() - @startTime
      @status = 'idle'
    else
      @error "Stop watch is not running, cannot stop!"
  clear: ->
    @elapsed = 0
    @status = 'idle'
  isRunning: ->
    @status is 'running'
  end: ->
    @stop()
    res = @elapsed
    @clear()
    res
  clearAndStart: ->
    @clear()
    @start()
