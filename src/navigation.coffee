# This module initializes the navigation bar and its interaction.
Capkom.initNav = ->
    # Initialize NEXT button
    jQuery("#nextButton").button
        icons:
            secondary: "ui-icon-arrowthick-1-e"
    .click (e) ->
        # the actual hash
        from = Capkom.stages[Capkom.getStagename()]
        # the next hash based on the order
        stages = Capkom.getStages()
        next = stages[ _.indexOf(stages, (from)) + 1 ]
        # Navigate to the next stage if there is one..
        Capkom.router.navigate next.name, true if next isnt undefined
        do e.stopImmediatePropagation

    # Initialize Previous button
    jQuery("#prevButton").button
        icons:
            primary: "ui-icon-arrowthick-1-w"
    .click (e) ->
        # the actual hash
        from = Capkom.stages[Capkom.getStagename()]
        # the previous hash based on the order
        stages = Capkom.getStages()
        next = stages[ _.indexOf(stages, (from)) - 1 ]
        # Navigate to the next stage if there is one..
        Capkom.router.navigate next.name, true if next isnt undefined
        do e.stopImmediatePropagation

    # Empty the bar
    jQuery("nav").html ""

    _renderStageTitle = (stage) ->
        """
            <li><a class="stage-title" href="##{stage.name}">#{stage.title}</a></li>
        """
    _renderStage = (stage) ->
        """
            <div id="#{stage.name}">
                <div style="float:left;"><img width="200" class="stage-image #{stage.image ? '': 'hidden'}" alt="Wizard Bild" src="#{stage.image}" /></div>
                <div style="float:left; padding: 5px 15px;">
                    <span class="stage-content tts" lang="de" tts="#{stage.speech}">#{stage.html}</span>
                </div>
            </div>
        """ # "

    for i, stage of Capkom.getStages()
        jQuery(".stages .titles").append jQuery(_renderStageTitle(stage))
        el = jQuery(_renderStage(stage)).appendTo jQuery(".stages")
        stage.script jQuery(".stage-content", el) if stage.script
    jQuery(".stages").tabs()


