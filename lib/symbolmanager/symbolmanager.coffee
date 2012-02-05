# Initialize Capkom object
Capkom = window.Capkom ?= {}

Capkom.capkomSymbol = 
jQuery.widget "Capkom.capkomSymbol"
    options:
        profile: Capkom.profile
        symbolSets: Capkom.symbolSets
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
        preferredSet = @options.symbolSets[profile.get('symbolset')]
        symbolSetRanking = _.union [preferredSet], sets.sets
        # detect the symbolset that has the symbol
        symbolSet = _.detect symbolSetRanking, (symbolSet) =>
            symbolSet.hasSymbol @symbolId
        unless symbolSet
            console.error "No symbolset found for #{@symbolId}"
            return ""
        # selected symbolsize
        symbolSize = profile.get('symbolsize') or 'medium'

        symbolUri = @options.uriPrefix + symbolSet.getSymbolUri @symbolId, symbolSize

