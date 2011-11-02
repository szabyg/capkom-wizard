# Initialize Capkom object
Capkom = window.Capkom ?= {}

# Initializing navigation bar
Capkom.initNav = ->
    # Initialize NEXT button
    jQuery("#nextButton").button()
#        icons:
#            secondary: "ui-icon-arrowthick-1-e"
    .click (e) ->
        # the actual hash
        from = Capkom.stages[Capkom.getStagename()]
        # the next hash based on the order
        stages = Capkom.getStages()
        next = stages[ stages.indexOf(from) + 1 ]
        # Navigate to the next stage if there is one..
        Capkom.router.navigate next.name, true if next isnt undefined
        do e.stopImmediatePropagation

    # Initialize Previous button
    jQuery("#prevButton").button()
#        icons:
#            primary: "ui-icon-arrowthick-1-w"
    .click (e) ->
        # the actual hash
        from = Capkom.stages[Capkom.getStagename()]
        # the previous hash based on the order
        stages = Capkom.getStages()
        next = stages[ stages.indexOf(from) - 1 ]
        # Navigate to the next stage if there is one..
        Capkom.router.navigate next.name, true if next isnt undefined
        do e.stopImmediatePropagation

    # Empty the bar
    jQuery("nav").html ""

    # Create an entry for each stage
    for i, stage of Capkom.getStages()
        jQuery("nav").append jQuery """
            <input type='radio' name='capkom-wizard-nav' id='nav-#{stage.name}'/>
            <label for='nav-#{stage.name}'>#{1 + Number i}. #{stage.title}</label>
        """

    # Activate the current stage
    jQuery("input#nav-#{Capkom.getStagename()}").attr "checked", "checked"

    # Initialize jQuery UI buttonset
    do jQuery("nav").buttonset

    # Initialize click event handler
    jQuery("nav input").click ->
        Capkom.router.navigate @id.replace("nav-",""), true

# Dynamically define routes based on the defined wizard stages
Capkom.RouterClass = Backbone.Router.extend
    initialize: (opts) ->
        for i, stage of Capkom.getStages()
            # Initialize a route and define how it's handled
            @route stage.name, stage.name, -> 
                locRoute = window.location.hash
                stagename = Capkom.getStagename()
                if Capkom.order.indexOf(stagename) is 0
                    jQuery("#prevButton").hide()
                else
                    jQuery("#prevButton").show()
                newStage = Capkom.stages[stagename]

                # Fill in all "template parts" and initialize the interaction
                # title and raw html
                jQuery(".stage-title").html newStage.title
                jQuery(".stage-content").html newStage.html

                # Show the corresponding image or hide the tag if no image is defined
                if newStage.image
                    jQuery(".stage-image")
                    .show()
                    .attr "src", newStage.image
                else
                    jQuery(".stage-image")
                    .hide()

                # Run the initialisation script defined for the stage
                newStage.script jQuery(".stage-content") if newStage.script
                do Capkom.initNav

