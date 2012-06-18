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
      maxSize: 200
      minSize: 100
      result: (size, details) ->
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
        jQuery('#results').html res
        console.info 'ideal size:', size, 'detailed results:', details

  _create: ->
    # widget styling
    @element.css
      width: window.innerWidth - 30
      height: window.innerHeight - 30
      position: 'absolute'
      top: 5
      left: 5
      border: '3px solid #ccc'
    @element.append "<div class='progressBar'></div>"
    @progressBar = @element.find ".progressBar"
    @progressBar.css
      'float': 'right'
      'width': '50%'
    @progressBar.progressbar()


    # Catchme button and functionality
    @element.append("<button class='catchme'>Catch me!</button>")
    @catchme = @element.find '.catchme'
    console.info @catchme.button()

    # correct click
    @catchme.click (e) =>
      e.stopPropagation()
      @_attempt true

    # wrong click
    @element.click (e) =>
      @_attempt false

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

  _beginGame: ->
    level = 2
    while Math.floor((Math.min window.innerWidth, window.innerHeight) / level) > @options.maxSize
      level++
    @_newLevel level - 1
    @notyetmoved = true

  _newLevel: (level) ->
    # Set up level specific things
    if @size < @options.minSize
      @finish()
    else
      @level = level
      @size = Math.floor((Math.min window.innerWidth, window.innerHeight) / @level)
      @currentLevel = @details[@size.toString()] = []
      @progressBar.progressbar 'value', 0
      @catchme.css 'width', @size
      @catchme.css 'height', @size
      # Reset sensors, start stop watches
      @moveTimeStat.clear()
      @reactionTimeStat.clear()
      console.info 'new level started with symbol size', @size

      # Begin level
      @_newPosition()

  _newPosition: ->
    maxLeft = window.innerWidth - @size - 30
    maxTop = window.innerHeight - @size - 30
    @catchme.css 'left', Math.floor Math.random() * maxLeft
    @catchme.css 'top', Math.floor Math.random() * maxTop
    @notyetmoved = true
    @reactionTimer.clearAndStart()

  _attempt: (succeeded) ->
    # If it's a successful click then register the reaction and move times
    if succeeded
      moveTime = @moveTimer.end()
      # jQuery('#moveTime').html(moveTime)
      @start = new Date().getTime()
      console.info 'success', @level, 'reactionTime:', @reactionTime, 'moveTime:', moveTime

      @currentLevel.push
        value: 1
        moveTime: moveTime
        reactionTime: @reactionTime
      @reactionTimeStat.add @reactionTime
      @moveTimeStat.add moveTime
    else
      # if click failed register failed click
      console.info 'fail'
      @currentLevel.push 0

    # After 7 clicks start a new level or finish game depending the score
    if @currentLevel.length >= 7
      # evaluate current level
      @evaluateCurrentLevel()
      if @currentLevel.score >= 0.5
        # High score --> New level
        @goodSize = @size
        if @currentLevel.moveTimeAverage < 2000
          @_newLevel @level + 2
        else
          @_newLevel @level + 1
      else
        # Low score --> Finish
        @finish()
    else
      progress = (@currentLevel.length / 7) * 100
      console.info 'progress:', progress
      @progressBar.progressbar 'value', Math.floor(progress)
      if succeeded
        # Next task, same level
        @reactionTimer.clear()
        @moveTimer.clear()
        @_newPosition()

  finish: ->
    if @goodSize
      @options.result @goodSize, @details

      @destroy()
    else
      alert "You cannot use the computer with your current devices. Consult with Platus."


  evaluateCurrentLevel: ->
    correct = _.filter(@currentLevel, (r) -> r.value is 1)
    @currentLevel = @details[@size] =
      score: correct.length / @currentLevel.length
      reactionTimeAverage: Math.round @reactionTimeStat.getAverage()
      moveTimeAverage: Math.round @moveTimeStat.getAverage()
      reactionTimeStDev: @reactionTimeStat.getStandardDeviation()
      moveTimeStDev: @moveTimeStat.getStandardDeviation()
    console.info 'level finished', @level, @currentLevel


  _destroy: ->
    @element.html ""


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
  constructor: (@error = -> console.error.apply console, arguments) ->
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
