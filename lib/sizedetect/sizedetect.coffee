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

jQuery.widget "Capkom.sizedetect"
  # Options:
  options:
      # By default `Capkom.profile` is used for getting the selected symbolset,
      # size and to be informed about profile changes.
      profile: Capkom.profile
      symbolLabel: "Catch me!"
      maxSize: 200
      minSize: 100
      clickCount: 5
      timeout: 400
      rootPrefix: ''
      result: (bestSize, details) ->
        res = "<h2>Results</h2>"
        res += "Measured Sizes (these sizes depend from the screen size)"
        res += "<ul>"
        for size, result of details
          res += """
          <li>
            size: #{size}px, score: #{Math.round(result.score * 100)} %<br/>
            Reaction time: average: #{result.reactionTimeAverage}, standard deviation: #{result.reactionTimeStDev}<br/>
            Move time: average: #{result.moveTimeAverage}, standard deviation: #{result.moveTimeStDev}
           </li>
           """
        res += "</ul>"
        res += "<p>Minimum size resulted in #{bestSize}</p>"
        jQuery('#results').html res
        @console.info 'ideal size:', size, 'detailed results:', details
      noclick: (e) ->
        alert "You cannot use the computer with your current devices. Consult with Platus."

  _create: ->
    @_fixConsole()
    # widget styling
    @element.addClass 'sizedetect-container'
    @_savedCSS =
      position: @element.css 'position'
      top: @element.css 'top'
      bottom: @element.css 'bottom'
      left: @element.css 'left'
      right: @element.css 'right'
      'z-index': @element.css 'z-index'
      'background-color': @element.css 'background-color'

    @element.css
      position: 'fixed'
      top: '5px'
      bottom: '5px'
      left: '5px'
      right: '5px'
      'background-color': '#fff'
      'z-index': 100
      #test-area {
      # width: @getInnerWidth() - 30
      # height: @getInnerHeight() - 30

    # Create progress bar
    @element.append "<div class='progressBar'></div>"
    @progressBar = @element.find ".progressBar"
    @progressBar.css
      'float': 'right'
      'width': '50%'
    @progressBar.progressbar()

    # Catchme button and functionality
    # @element.append("<button class='catchme'>#{@options.symbolLabel}</button>")
    @element.append("<button class='catchme'><img src='#{@options.rootPrefix}aron.png'/></button>")
    @catchme = @element.find '.catchme'
    @console.info @catchme.button()

    @catchme.find('.ui-button-text').css
      'padding': 0
    # correct click
    @catchme.click (e) =>
      e.stopPropagation()
      @_attempt true

    # Hide mouse cursor
    @catchme.css
      cursor: "url(#{@options.rootPrefix}blank.cur), none"
    @element.css
      cursor: "url(#{@options.rootPrefix}blank.cur), none"

    # Create custom cursor
    @element.append "<img class='custom-cursor' src='#{@options.rootPrefix}futter.png'/>"
    @cursor = jQuery '.custom-cursor', @element
    @cursor.css
      # cursor: 'none'
      # width: '100px'
      # height: '100px'
      position: 'absolute'
      #display: 'none'
      top: 0
      left: 0
      'z-index': 10000
      # border: '1px solid red'
      'pointer-events': 'none'

    @cursor.click (e) =>
      @cursor.hide()
      console.info e
      jQuery(document.elementFromPoint(e.clientX, e.clientY)).trigger 'click'
      _.defer =>
        @cursor.show()
      false

    @element.mouseout (e) =>
      console.info 'element out', 'e', e, 'e.relatedTarget', e.relatedTarget
      unless @catchme.has e.relatedTarget
        @cursor.hide()
      false

    @element.mouseenter (e) =>
      console.info 'element enter', e
      @cursor.show()
      false

    @element.mousemove (e) =>
      console.info 'element move'
      @cursor.css
        left: e.clientX - (@cursorsize / 2)
        top: e.clientY - (@cursorsize / 2)

    # wrong click
    @element.click (e) =>
      @_attempt false

    # escape keypress
    jQuery('body').bind 'keyup', widget: @, @_escHandler

    # measure delay before first mouse move (reaction time)
    @element.mousemove (e) =>
      if @notyetmoved
        @notyetmoved = false
        @reactionTime = @reactionTimer.end()
        @moveTimer.start()
        # jQuery('#reactionTime').html(@reactionTime)

    # display elements for debug info
    @element.append('<div id="moveTime"></div>')
    @element.append('<div id="reactionTime"></div>')
    # @result collects all results of the levels
    @details = {}

    # Set up measurement and statistics counters
    @moveTimer = new StopWatch
    @reactionTimer = new StopWatch

    @moveTimeStat = new Stat
    @reactionTimeStat = new Stat

    # everything set up, begin the game
    @_beginGame()

  _destroy: ->
    @element.html ""
    @element.removeClass 'sizedetect-container'
    @element.css @_savedCSS
      # width: 'auto'
      # height: 'auto'
    # escape keypress
    jQuery('body').unbind 'keyup', @_escHandler

  _beginGame: ->
    level = 2
    while Math.floor((Math.min @getInnerWidth(), @getInnerHeight()) / level) > @options.maxSize
      level++
    @_newLevel level - 1

  _newLevel: (level) ->
    # Set up level specific things
    if @size < @options.minSize
        @finish()
    else
        @level = level
        @size = Math.floor((Math.min @getInnerWidth(), @getInnerHeight()) / @level)
        @cursorsize = @size / 2
        @cursor.css
          height: @cursorsize
          width: @cursorsize
        @currentLevel = @details[@size.toString()] = []
        @progressBar.progressbar 'value', 0
        @catchme.add('img', @catchme)
        .css
          'width': @size
          'height': @size
        # Reset sensors, start stop watches
        @moveTimeStat.clear()
        @reactionTimeStat.clear()
        @console.info 'new level started with symbol size', @size

        # Begin level
        @_newPosition()

  _newPosition: ->
    maxLeft = @getInnerWidth() - @size - 30
    maxTop = @getInnerHeight() - @size - 30
    @catchme.css 'left', Math.floor Math.random() * maxLeft
    @catchme.css 'top', Math.floor Math.random() * maxTop
    @notyetmoved = true
    @reactionTimer.clearAndStart()
    @timeoutTimer = setTimeout =>
      @timeout()
    , @options.timeout * 1000

  timeout: ->
    @finish()

  _attempt: (succeeded) ->
    clearTimeout @timeoutTimer
    # If it's a successful click then register the reaction and move times
    if succeeded
      moveTime = @moveTimer.end()
      # jQuery('#moveTime').html(moveTime)
      @start = new Date().getTime()
      @console.info 'success', @level, 'reactionTime:', @reactionTime, 'moveTime:', moveTime

      @currentLevel.push
        value: 1
        moveTime: moveTime
        reactionTime: @reactionTime
      @reactionTimeStat.add @reactionTime
      @moveTimeStat.add moveTime
    else
      # if click failed register failed click
      @console.info 'fail'
      @currentLevel.push 0

    # After e.g. 5 clicks start a new level or finish game depending the score
    if @currentLevel.length >= @options.clickCount
      # evaluate current level
      @evaluateCurrentLevel()
      if @currentLevel.score >= 0
        # High score --> New level
        @goodSize = @size
        @console.info "goodSize is", @goodSize, @
        if @currentLevel.moveTimeAverage < 2000
          @_newLevel @level + 2
        else
          @_newLevel @level + 1
      else
        # Low score --> Finish
        @finish()
    else
      progress = (@currentLevel.length / @options.clickCount) * 100
      @console.info 'progress:', progress
      @progressBar.progressbar 'value', Math.floor(progress)
      if succeeded
        # Next task, same level
        @reactionTimer.clear()
        @moveTimer.clear()
        @_newPosition()

  finish: ->
    if @goodSize
      @console.info 'goodSize', @goodSize, @
      @options.result.apply @, [@goodSize, @details]
    else
      @_trigger 'noclick'
    @destroy()

  evaluateCurrentLevel: ->
    correct = _.filter(@currentLevel, (r) -> r.value is 1)
    @currentLevel = @details[@size] =
      score: correct.length / @currentLevel.length
      reactionTimeAverage: Math.round @reactionTimeStat.getAverage()
      moveTimeAverage: Math.round @moveTimeStat.getAverage()
      reactionTimeStDev: @reactionTimeStat.getStandardDeviation()
      moveTimeStDev: @moveTimeStat.getStandardDeviation()
    @console.info 'level finished', @level, @currentLevel

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
