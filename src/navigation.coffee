# Initialize Capkom object
Capkom = window.Capkom ?= {}

# Initializing navigation bar
Capkom.initNav = ->
    # Empty the bar
    jQuery("nav").html ""
    # Create an entry for each stage
    for i, stage of Capkom.getStages()
        jQuery("nav").append jQuery """
            <input type='radio' name='capkom-wizard-nav' id='#{stage.name}'/>
            <label for='#{stage.name}'>#{1 + Number i}. #{stage.title}</label>
        """
    # Activate the current stage
    jQuery("input##{Capkom.getStagename()}").attr "checked", "checked"
    # Initialize jQuery UI buttonset
    do jQuery("nav").buttonset
    # Initialize click event handler
    jQuery("nav input").click ->
        Capkom.router.navigate @id, true

# Define routes
Capkom.RouterClass = Backbone.Router.extend
    routes:
        "": "startpage"
    startpage: ->
        @navigate Capkom.order[0], true
    initialize: (options) ->
        for i, stage of Capkom.getStages()
            @route stage.name, stage.name, -> _.defer ->
                locRoute = window.location.hash
                stagename = Capkom.getStagename()
                if Capkom.order.indexOf(stagename) is 0
                    jQuery("#prevButton").hide()
                else
                    jQuery("#prevButton").show()
                newStage = Capkom.stages[stagename]

                # Fill in all template parts and initialize the interaction
                jQuery(".stage-title").html newStage.title
                jQuery(".stage-content").html newStage.html
                if newStage.image
                    jQuery(".stage-image")
                    .show()
                    .attr "src", newStage.image
                else
                    jQuery(".stage-image")
                    .hide()
                newStage.script jQuery(".stage-content") if newStage.script
                do Capkom.initNav


