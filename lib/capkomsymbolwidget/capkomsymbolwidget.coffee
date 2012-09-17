# Initialize Capkom object
Capkom = this.Capkom ?= {}

# Adds a symbol to a Capkom UI. Depending on the profile and the symbolset 
# the symbol can come from different symbolsets and have different sizes.
# Easiest usage would be this:
#
#     <div symbolId="welcome" class="label">
#         Welcome
#     </div>
#
#     jQuery(".label").capkomSymbol();
# That causes a lookup for the `welcome` symbol in the defined 
# symbolsets in the defined size.

jQuery.widget "Capkom.capkomSymbol",
  # Options:
  options:
  # By default `Capkom.profile` is used for getting the selected symbolset,
  # size and to be informed about profile changes.
    profile: Capkom.profile
    # By default `Capkom.symbolSets` is used to get the symbolsets
    symbolSets: Capkom.symbolSets
    # If no symbolId is defined on a label use `default`
    symbolId: "default"
    # For symbols with static size
    symbolSize: null
    # For testing only, you can put an additional prefix before the symbol uri.
    # This makes sense if the symbolsets are defined relative to the page uri.
    uriPrefix: ""
  _create: ->
    # Make sure no console.info or .error calls on
    if window.console
      @console = window.console
    else
      @console =
        info: ->
        error: ->
        log: ->
    @options.symbolSets ?= Capkom.symbolSets
    @symbolId = @element.attr "symbolId" or @options.symbolId
    @symbolsize = @element.attr "symbolsize" or @options.symbolsize
    # Add symbol markup at the end of this.element
    @symbol = jQuery '<img class="capkom-symbol" style="padding-right:5px;vertical-align:middle;display:none;"/>&nbsp;'
    @symbol.prependTo @element
    @symbol = jQuery 'img.capkom-symbol', @element
    @symbol.hide()
    # display:inline;
    @_profileChange @options.profile
    _profileChange = (profile) =>
      @_profileChange.apply @, [profile]
    @options.profile.bind 'change', _profileChange

  _destroy: ->
    @symbol.remove()

  _profileChange: (profile) ->
    # figure out which symbol to show and show it
    symbolUri = @_getSymbolUri profile, @options.symbolSets
    @symbol.attr 'src', symbolUri
    if profile.get('useSymbols') or @element.attr('donthidesymbol')
      @symbol.show()
    else
      @symbol.hide()

  # figure our the symbol uri
  _getSymbolUri: (profile, sets) ->
    # ranking of symbolsets. the first symbolset having the symbol will be chosen.
    preferredSet = @options.symbolSets[profile.get('symbolSet')]
    symbolSetRanking = _.union [preferredSet], sets.sets
    # detect the symbolset that has the symbol
    symbolSet = _.detect symbolSetRanking, (symbolSet) =>
      symbolSet.hasSymbol @symbolId
    unless symbolSet
      @console.error "No symbolset found for #{@symbolId}"
      return ""
    # selected symbolsize
    symbolSize = @symbolsize or profile.get('symbolsize') or 'medium'

    symbolUri = @options.uriPrefix + symbolSet.getSymbolUri @symbolId, symbolSize

