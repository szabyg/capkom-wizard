# Initialize Capkom object
Capkom = this.Capkom ?= {}

# This module declares the actions to execute when the profile changes.

# Capkom.Profile is a backbone model
Capkom.Profile = Backbone.Model.extend()

# Capkom.profile contains the profile parameters and takes care of event handling
Capkom.profile = new Capkom.Profile

# Changing `fontsize` effects the body getting the CSS class `fontsize-[small|medium|large]`
Capkom.profile.bind "change:fontsize", (profile, fontsize) ->
    for i in [1..8]
        jQuery("body").removeClass "fontsize-s#{i}"
    jQuery("body").addClass "fontsize-#{fontsize}"



# Changing the `theme` parameter
Capkom.profile.bind "change:theme", (profile, theme) ->
    themeDetails = Capkom.themeMap[theme]
    unless profile.get('themeDetails') is themeDetails
        Capkom.profile.set 'themeDetails', themeDetails
    $.cookie "jquery-ui-theme", theme
    $("#bgThemeActivator").themeswitcher();

# Turn the `useAudio` parameter on/off (true/false)
Capkom.profile.bind "change:useAudio", (profile, audio) ->
    Capkom.updateTTS?()

# Turn the `useSymbols` parameter on/off (true/false)
Capkom.profile.bind "change:useSymbols", (profile, useSymbols) ->
    Capkom.showStages? jQuery ".stages"
    Capkom.updateSymbols?()

# Any change will be saved automatically by the Backbone.sync method
Capkom.profile.bind "change", (profile) ->
    profile.save()

# Implementing the Backbone.sync method is the way of telling how to 
# save the profile e.g. on the backend.
Backbone.sync = (method, model) ->
    # Reference implementation using localStorage
    localStorage.profile = JSON.stringify model.toJSON()
    console?.info "profile saved:", localStorage.profile

# Method for initialisation:
# Load the profile and call the callback
Capkom.loadProfile = (callback) ->
    # When the profile json is loaded, here we can set it
    setProfile = (profile) -> 
        # make sure profile is a json object
        if typeof profile is "string"
            profile = JSON.parse profile
        Capkom.defaultProfile = profile
        Capkom.profile.set profile
        callback?()

    # Get the saved profile if there is on or get the default profile
    if localStorage.profile
        setProfile localStorage.profile
    else
        # Load default profile from a backend servlet
        jQuery.get "./default-profile.json", (profile) -> _.defer ->
            setProfile profile

