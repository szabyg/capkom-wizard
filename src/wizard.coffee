Capkom = window.Capkom ?= {}

# Name of the actual stage
Capkom.getStagename = ->
    window.location.hash.replace /^#/, ""


# Startup wizard
jQuery(document).ready -> _.defer ->
    Capkom.loadProfile ->
        # Start hash routing
        Capkom.router = new Capkom.RouterClass
        unless Backbone.history.start()
            Capkom.router.navigate Capkom.order[0], true

        # Initialize panel view
        jQuery("section").accordion
            autoHeight: false

        # Initialize navigation bar
        do Capkom.initNav

