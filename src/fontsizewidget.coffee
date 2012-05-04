jQuery.widget "capkom.fontsize",
    options:
        min: 1
        max: 8
        value: 1
        styleClass: "fontsize-widget"
        change: (val) ->
            console.info "fontsize value:", val
    _create: ->
        @element.addClass @options.styleClass
        for i in [@options.min..@options.max]
            @element.append jQuery """
                <input type='radio' name='fontsize' id='fontsize-s#{i}' />
                <label for='fontsize-s#{i}' ><span class='fontsize-s#{i} choose-button'>AAA</span></label>
            """
        console.log @element, "created."
        @_setValue @options.value
        @buttonset = jQuery(@element).buttonset
            styleclass: "fontsize-buttons"
        .change (e) =>
            @options.change @options.value = e.target.id.replace "fontsize-s", ""
    _destroy: ->
        @element.removeClass @options.styleClass
    _setOption: ( key, value ) ->
        switch key
            when "value"
                @_setValue value
    _setValue: (val) ->
        jQuery("#fontsize-s#{val}").attr "checked", "checked"
        @buttonset?.buttonset 'refresh'
        @options.value = val

