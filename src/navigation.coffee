# Initialize Capkom object
Capkom = window.Capkom ?= {}

Capkom.initNav = ->
    jQuery("nav").html ""
    for i, stagename of Capkom.order
        stage = Capkom.stages[stagename]
        route = stage.route 
        route = stagename if route is undefined
        jQuery("nav").append jQuery """
            <input type='radio' name='capkom-wizard-nav' href='##{route}' id='#{stagename}'/>
            <label for='#{stagename}'>#{1 + Number i}. #{stage.title}</label>
        """
    jQuery("input##{Capkom.getStagename()}").attr "checked", "checked"
    do jQuery("nav").buttonset
    jQuery("nav input").click ->
        Capkom.router.navigate @id, true

# Define routes
Capkom.RouterClass = Backbone.Router.extend
    routes:
        "": "startpage"
    startpage: ->
        @navigate Capkom.order[0], true
    initialize: (options) ->
        for stagename, stage of Capkom.stages
            route = stage.route 
            route = stagename if route is undefined
            @route route, stagename, -> _.defer ->
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


