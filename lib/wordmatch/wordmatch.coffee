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
        @console.info 'detailed results:', details
      symbolSize: 150
      questions: [
        type: 's2w' # symbol to word
        question: 'img/tree.jpg'
        choices: ['Baum', 'Haus', 'Hose']
        correct: 'Baum'
      ,
        type: 's2w',
        question: 'img/house.jpg'
        choices: ['Baum', 'Haus', 'Hose']
        correct: 'Haus'
      ,
        type: 's2w',
        question: 'img/pants.gif'
        choices: ['Baum', 'Haus', 'Hose']
        correct: 'Hose'
      ,
        type: 'w2s' # word to symbol
        question: 'Baum'
        choices: ['img/tree.jpg', 'img/pants.gif', 'img/house.jpg']
        correct: 'img/tree.jpg'
      ,
        type: 'w2s' # word to symbol
        question: 'Haus'
        choices: ['img/tree.jpg', 'img/pants.gif', 'img/house.jpg']
        correct: 'img/house.jpg'
      ,
        type: 'w2s' # word to symbol
        question: 'Hose'
        choices: ['img/tree.jpg', 'img/pants.gif', 'img/house.jpg']
        correct: 'img/pants.gif'
      ]

  _create: ->
    @_fixConsole()
    # widget styling
    @element.addClass 'wordmatch-container'
    @element.append "<div class='progressBar'></div>"
    @progressBar = @element.find ".progressBar"
    @progressBar.css
      'float': 'right'
      'width': '50%'
    @progressBar.progressbar()

    @element.append """
      <div class='play-area'>
        <table>
          <tr><td><div class='question-area'></div></td></tr>
          <tr><td><div class='answer-area'></div></td></tr>
        </table>
      </div>
    """
    @playArea = @element.find '.play-area'
    @questionArea = @element.find '.question-area'
    @answerArea = @element.find '.answer-area'

    @element.append "<div class='msg-dialog'></div>"
    @messageArea = @element.find '.msg-dialog'
    # everything set up, begin the game
    @_beginGame()

  _destroy: ->
    @element.html ""
    @element.removeClass 'wordmatch-container'
    @element.css
      width: 'auto'
      height: 'auto'

  _beginGame: ->
    # prepare sequence
    @sequence = @_shuffle @options.questions
    @results =
      word2symbol:
        correct: 0
        wrong: 0
        times: new Stat
      symbol2word:
        correct: 0
        wrong: 0
        times: new Stat
    @timer = new StopWatch()

    @_renderNext()
  _renderNext: ->
    @finish() unless @sequence.length
    @question = @sequence.shift()
    switch @question.type
      when 's2w'
        @questionArea.html "<img class='question' src='#{@question.question}' width='#{@options.symbolSize * 2} height='#{@options.symbolSize * 2}'/>"
        @answerArea.html ''
        for choice in @_shuffle @question.choices
          @answerArea.append "<button value='#{choice}' width='#{@options.symbolSize} height='#{@options.symbolSize}'>#{choice}</button>"
        @currentResultContainer = @results.symbol2word
      when 'w2s'
        @questionArea.html "<h1>#{@question.question}</h1>"
        @answerArea.html ''
        for choice in @_shuffle @question.choices
          @answerArea.append """
            <button value='#{choice}' width='#{@options.symbolSize} height='#{@options.symbolSize}'>
              <img class='choice' src='#{choice}' width='#{@options.symbolSize} height='#{@options.symbolSize}'/>
            </button>
          """
        @currentResultContainer = @results.word2symbol
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
          @message 'Korrekt!', =>
            @buttonsDisabled = false
            @_renderNext()
        else
          @currentResultContainer.wrong++
          jQuery(e.currentTarget).css
            'border': 'red 5px solid'
          @message "Leider falsch.. Versuch's noch einmal!", =>
            @buttonsDisabled = false
            jQuery(e.currentTarget).css
              'border': ''
    @timer.start()

  message: (msg, cb) ->
    @messageArea.html(msg).dialog()
    afterWaiting = =>
      @messageArea.dialog('destroy')
      cb()
    setTimeout afterWaiting, 100
  finish: ->
    @playArea.html ''
    @results.word2symbol.score = @results.word2symbol.correct / (@results.word2symbol.correct + @results.word2symbol.wrong)
    @results.word2symbol.times = @results.word2symbol.times.getStatistics()

    @results.symbol2word.score = @results.symbol2word.correct / (@results.symbol2word.correct + @results.symbol2word.wrong)
    @results.symbol2word.times = @results.symbol2word.times.getStatistics()

    console.info 'results', @results
    jQuery('.results').html JSON.stringify @results

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
  _shuffle: (arr) ->
    randOrd = ->
      Math.round(Math.random())-0.5
    arr.splice(0).sort randOrd


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
