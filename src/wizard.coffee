Capkom = window.Capkom ?= {}

# Name of the actual stage
Capkom.getStagename = ->
    result = null
    locRoute = window.location.hash.replace /^#/, ""
    _(Capkom.stages).find (stage, routename) ->
        result = routename if stage.route is locRoute or routename is locRoute
    result

# Load default profile from a backend servlet
jQuery.get "./default-profile.json", (profile) ->
    Capkom.defaultProfile = _.clone profile
    Capkom.profile = _.clone profile

# Startup wizard
jQuery(document).ready -> _.defer ->
    # Start hash routing
    Capkom.router = new Capkom.RouterClass
    do Backbone.history.start

    # Initialize panel view
    jQuery("section").accordion
        autoHeight: false

    # Initialize NEXT button
    jQuery("#nextButton").button()
    .click ->
        # the actual hash
        from = Capkom.getStagename()
        # the next hash based on the order
        next = Capkom.order[ Capkom.order.indexOf(from) + 1 ]
        # Navigate to the next stage if there is one..
        Capkom.router.navigate next, true if next isnt undefined
    jQuery("#prevButton").button()
    .click ->
        # the actual hash
        from = Capkom.getStagename()
        # the next hash based on the order
        next = Capkom.order[ Capkom.order.indexOf(from) - 1 ]
        
        # Navigate to the next stage if there is one..
        Capkom.router.navigate next, true if next isnt undefined

    jQuery("nav a").button()

