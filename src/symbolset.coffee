Capkom = window.Capkom ?= {}
Capkom.symbolSets ?= {}
Capkom.symbolSets.sets ?= []

class Capkom.Symbolset
    constructor: (@options) ->
        @nameMap = options.nameMap
        @name = options.name
        @baseUri = options.baseUri
        @nameFormat = options.nameFormat
        @sizeMap = options.sizeMap
        @nameMap = options.nameMap
        @symbols = options.symbols

        Capkom.symbolSets[options.name] = @
        Capkom.symbolSets.sets.push @

    getSymbolUri: (symbolId, symbolSize) ->
        # nameformat: "Capkom_{symbolId}-{size}.gif"
        imageName = @nameFormat
        .replace("{symbolId}", @_applyMapping symbolId, @nameMap)
        .replace("{size}", @_applyMapping symbolSize, @sizeMap)
        symbolUri = @baseUri + imageName

    hasSymbol: (sName) ->
        symbolName = @_applyMapping sName, @nameMap if @nameMap
        true if _.indexOf(@symbols, symbolName) isnt -1

    # replace mapped strings
    _applyMapping: (str, mapping) ->
        mapping[str] or str
