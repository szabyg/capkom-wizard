Capkom = this.Capkom ?= {}
Capkom.symbolSets ?= {}
Capkom.symbolSets.sets ?= []

###
Generic symbol set class
###
class Capkom.Symbolset
    constructor: (@options) ->
        # Name of the set
        @name = options.name
        # [plain string-string mapping object] 
        # Mapping from symbol IDs to image naming
        @nameMap = options.nameMap
        # [string] Location of the symbol set
        @baseUri = options.baseUri
        # [string] Name format of the files (e.g. "{symbolId}{size}.png" or "{size}/{symbolId}.png")
        @nameFormat = options.nameFormat
        # [plain string-string mapping object] 
        # Mapping from "small", "medium", "large" to however the symbol set uses sizes
        @sizeMap = options.sizeMap
        # [Array of Strings] List of provided symbols
        @symbols = options.symbols

        Capkom.symbolSets[options.name] = @
        Capkom.symbolSets.sets.push @

    # Get full Uri symbol for `symbolId` in the given `symbolSize`
    getSymbolUri: (symbolId, symbolSize) ->
        imageName = @nameFormat
        .replace("{symbolId}", @_applyMapping symbolId, @nameMap)
        .replace("{size}", @_applyMapping symbolSize, @sizeMap)
        return @baseUri + imageName

    # return `true` if the symbol set has a symbol for given symbol Id
    hasSymbol: (symbolId) ->
        symbolName = @_applyMapping symbolId, @nameMap if @nameMap
        true if _.contains @symbols, symbolName

    # replace mapped strings
    _applyMapping: (str, mapping) ->
        mapping[str] or str
