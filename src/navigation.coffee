# Initialize Capkom object
Capkom = window.Capkom ?= {}

# Define routes
Capkom.RouterClass = Backbone.Router.extend
    initialize: (options) ->
        for stagename, stage of Capkom.stages
            route = stage.route 
            route = stagename if route is undefined
            @route route, stagename, -> _.defer ->
                locRoute = window.location.hash
                stagename = Capkom.getStagename()
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

