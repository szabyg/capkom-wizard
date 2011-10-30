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

        # Initialize NEXT button
        jQuery("#nextButton").button()
        .click ->
            # the actual hash
            from = Capkom.stages[Capkom.getStagename()]
            # the next hash based on the order
            stages = Capkom.getStages()
            next = stages[ stages.indexOf(from) + 1 ]
            # Navigate to the next stage if there is one..
            Capkom.router.navigate next.name, true if next isnt undefined
        # Initialize Previous button
        jQuery("#prevButton").button()
        .click ->
            # the actual hash
            from = Capkom.stages[Capkom.getStagename()]
            # the previous hash based on the order
            stages = Capkom.getStages()
            next = stages[ stages.indexOf(from) - 1 ]
            # Navigate to the next stage if there is one..
            Capkom.router.navigate next.name, true if next isnt undefined

        # Initialize navigation bar
        do Capkom.initNav

