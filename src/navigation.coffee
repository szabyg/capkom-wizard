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
                jQuery(".stage").html newStage.html
                jQuery(".stage-image").attr "src", newStage.image
                
                newStage.script jQuery(".stage") if newStage.script

