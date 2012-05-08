# Initialize Capkom object
Capkom = this.Capkom ?= {}

loadSymbolset = (url) ->
    cb = Capkom.waitForMe()
    jQuery.ajax
        url: url + "/symbolset.json"
        dataType: "text"
        success: (res) ->
            res = JSON.parse res
            new Capkom.Symbolset res
            cb()
        error: (err) ->
            Capkom.console.error err
            cb()
loadSymbolset "symbols/free1"
loadSymbolset "symbols/capkom"

