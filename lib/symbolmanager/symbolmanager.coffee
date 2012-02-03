# Initialize Capkom object
Capkom = window.Capkom ?= {}

Capkom.capkomSymbol = 
jQuery.widget "Capkom.capkomSymbol"
    options:
        profile: Capkom.profile
        symbolSets: Capkom.symbolsets
        symbolId: "default"
        uriPrefix: ""
    _create: ->
        @symbolId = @element.attr "symbolId" or @options.symbolId
        # Add symbol markup at the end of this.element
        @symbol = jQuery '<img class="capkom-symbol" style="padding-right:5px;vertical-align:middle;"/>&nbsp;'
        @symbol.hide().prependTo @element
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
        if profile.get 'useSymbols'
            @symbol.show()
        else
            @symbol.hide()

    # figure our the symbol uri
    _getSymbolUri: (profile, sets) ->
        # ranking of symbolsets. the first symbolset having the symbol will be chosen.
        symbolSetRanking = _.union [profile.get('symbolset')], sets.sets
        # detect the symbolset that has the symbol
        symbolSetName = _.detect symbolSetRanking, (setName) =>
            symbolSet = sets[setName]
            symbolName = @symbolId
            symbolName = @_applyMapping @symbolId, symbolSet.nameMap if symbolSet.nameMap
            true if _.indexOf(symbolSet.symbols, symbolName) isnt -1
        unless symbolSetName
            console.error "No symbolset found for #{@symbolId}"
            return ""
        # selected symbolset
        symbolSet = sets[symbolSetName]
        # selected symbolsize
        symbolSize = profile.get('symbolsize') or 'medium'

        # nameformat: "Capkom_{symbolId}-{size}.gif"
        imageName = symbolSet.nameFormat
        .replace("{symbolId}", @_applyMapping @symbolId, symbolSet.nameMap)
        .replace("{size}", @_applyMapping symbolSize, symbolSet.sizeMap)
        symbolUri = @options.uriPrefix + symbolSet.baseUri + imageName

    # replace mapped strings
    _applyMapping: (str, mapping) ->
        mapping[str] or str
