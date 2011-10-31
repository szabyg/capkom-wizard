Capkom.Profile = Backbone.Model.extend()

Capkom.profile = new Capkom.Profile

Capkom.profile.bind "change:fontsize", (profile, fontsize) ->
    jQuery("body").removeClass "fontsize-small fontsize-medium fontsize-large"
    jQuery("body").addClass "fontsize-#{fontsize}"

Capkom.profile.bind "change:theme", (profile, theme) ->
    $.cookie "jquery-ui-theme", theme
    $("#bgThemeActivator").themeswitcher();

Capkom.profile.bind "change", (profile) ->
    profile.save()

# TODO Implement some storage
Backbone.sync = (method, model) ->
    localStorage.profile = JSON.stringify model.toJSON()
    console.info "profile saved:", localStorage.profile

Capkom.loadProfile = (callback) ->
    setProfile = (profile) -> 
        # make sure profile is a json object
        if typeof profile is "string"
            profile = JSON.parse profile
        Capkom.defaultProfile = profile
        Capkom.profile.set profile
        callback?()

    if localStorage.profile
        setProfile localStorage.profile
    else
        # Load default profile from a backend servlet
        jQuery.get "./default-profile.json", (profile) -> _.defer ->
            setProfile profile

