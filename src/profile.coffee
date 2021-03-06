# Initialize Capkom object
Capkom = this.Capkom ?= {}

# This module declares the actions to execute when the profile changes.

# Capkom.Profile is a backbone model
Capkom.Profile = Backbone.Model.extend()

# Capkom.profile contains the profile parameters and takes care of event handling
Capkom.profile = new Capkom.Profile
  navigator: _(window.navigator).pick ['appCodeName','appName', 'appVersion', 'language', 'platform', 'product', 'userAgent', 'vendor', 'vendorSub']

# Changing `fontsize` effects the body getting the CSS class `fontsize-[small|medium|large]`
Capkom.profile.bind "change:fontsize", (profile, fontsize) ->
    for i in [1..8]
        jQuery("body").removeClass "fontsize-s#{i}"
    jQuery("body").addClass "fontsize-#{fontsize}"



# Changing the `theme` parameter
Capkom.profile.bind "change:theme", (profile, theme) ->
    td = {}
    # The theme details go to the profile for non-jqueryui-theme clients.
    themeDetails = Capkom.themeMap[theme]
    # Remove properties ending with .png
    _(themeDetails).each (v, k) ->
        if typeof v isnt "string" or v.indexOf('.png') is -1
            td[k] = v
    unless profile.get('themeDetails') is td
        Capkom.profile.set 'themeDetails', td
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
    Capkom.console.info "profile saved:", localStorage.profile

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
          profile.created = new Date()
          setProfile profile

