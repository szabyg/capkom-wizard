Capkom.Profile = Backbone.Model.extend()

Capkom.profile = new Capkom.Profile

Capkom.profile.bind "change:fontsize", (profile, fontsize) ->
    jQuery("body").removeClass "fontsize-small fontsize-medium fontsize-large"
    jQuery("body").addClass "fontsize-#{fontsize}"

Capkom.profile.bind "change", (profile) ->
    console.info "profile change", arguments
    profile.save()

Backbone.sync = (method, model) ->
    console.log method, model

Capkom.loadProfile = (callback) ->
    # Load default profile from a backend servlet
    jQuery.get "./default-profile.json", (profile) -> _.defer ->
        # make sure profile is a json object
        if typeof profile is "string"
            profile = JSON.parse profile
        Capkom.defaultProfile = profile
        Capkom.profile.set profile
        callback?()

