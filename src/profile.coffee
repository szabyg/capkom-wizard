Backbone.sync = (method, model) ->
    console.log method, model

Capkom.loadProfile = (callback) ->
    # Load default profile from a backend servlet
    jQuery.get "./default-profile.json", (profile) ->
        Capkom.defaultProfile = new Backbone.Model profile
        Capkom.profile = new Backbone.Model profile
        callback?()

