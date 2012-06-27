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

# TODO useAudio berücksichtigen

jQuery.widget "Capkom.explain"
  # Options:
  options:
      # By default `Capkom.profile` is used for getting the selected symbolset,
      # size and to be informed about profile changes.
      profile: Capkom.profile
      read: "This will be heard"
      html: "This will be shown. <button>Testknopf</button>"
      useAudio: true
      domInit: (element, done) ->
        jQuery(element).find('button').button()
        done()
      after: ->
        alert "this should happen after reading the text."
      ttsOptions: {}
      maxSize: 200
      minSize: 100
      clickCount: 5
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

  _create: ->
    @element.html """
  <div tts="#{@options.read}" class="explain">#{@options.html}</div>
    """
    @explainPanel = @element.find('.explain')
    @options.domInit @explainPanel, =>
      options = _.extend @options.ttsOptions,
        mode: 'auto'
        beforeDialog: =>
          @explainPanel.ttswidget 'getInnerContentElement', (innerContent) =>
            console.info @explainPanel, innerContent
            innerContent.append @explainPanel
        done: =>
          @_trigger 'after'
          _.defer =>
            if @explainPanel
              @explainPanel.remove()
              @explainPanel = null
        forcedClose: =>
          @_trigger 'forcedClose'

      @explainPanel.ttswidget options

  _destroy: ->
    @element.append @explainPanel
    #@explainPanel.remove()
