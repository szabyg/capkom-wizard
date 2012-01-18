# This is the central module initializing all the other depending modules.
Capkom = window.Capkom ?= {}

# Startup wizard
jQuery(document).ready -> _.defer ->
    Capkom.loadProfile ->
        # Start hash routing
        Capkom.router = new Capkom.RouterClass
        # Instantiate Speech module
#        Capkom.speech = new Capkom.Speech

#        unless Backbone.history.start()
#            Capkom.router.navigate Capkom.order[0], true

        # Initialize panel view
#        jQuery("section").accordion
#            autoHeight: false

        # Initialize navigation bar
        do Capkom.initNav

# Getter for the name of the actual stage.
Capkom.getStagename = ->
    window.location.hash.replace /^#/, ""


