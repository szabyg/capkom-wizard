# This module initializes the jQuery UI tabs element and its interaction.
Capkom.initNav = ->
    _renderStageTitle = (stage) ->
        "<li><a class='stage-title capkom-label' symbolId='#{stage.name}' href='##{stage.name}'>#{stage.title}</a></li>"

    for i, stage of Capkom.getStages()
        jQuery(".stages .titles").append jQuery(_renderStageTitle(stage))
        @renderStage stage, jQuery(".stages")
    jQuery(".stages").tabs(
        select: (event, ui) ->
            window.location.hash = ui.tab.hash
    ).addClass('ui-tabs-vertical ui-helper-clearfix')

    Capkom.uiLoaded = true

Capkom.renderStage = (stage, tabsEl, index) ->
    _renderStage = (stage) ->
        """
            <div id="#{stage.name}">
                <table class="ui-widget-content"><tr><td style="vertical-align: top;padding: 1em;">
                    <div>
                        <img width="200" class="stage-image #{stage.image ? '': 'hidden'}" alt="Wizard Bild" src="#{stage.image}" />
                    </div>
                </td><td>
                    <div style="padding: 5px 15px;">
                        <span class="stage-content tts" lang="de">#{stage.html}</span>
                    </div>
                    <div class="buttons">
                        <button class="prevButton" alt="Zurück">
                            <i class="icon-arrow-left"></i>
                            Zurück
                        </button>
                        <button class="nextButton" alt="Weiter">
                            Weiter
                            <i class="icon-arrow-right"/>
                        </button>
                    </div>
                </td></tr></table>
            </div>
        """ # "
    el = null
    if tabsEl.find(".ui-tabs-panel").length and index
        el = jQuery( _renderStage stage ).insertBefore jQuery(tabsEl.find(".ui-tabs-panel")[index])
    else
        el = jQuery( _renderStage stage ).appendTo tabsEl
    stage.script jQuery(".stage-content", el) if stage.script
    if stage._first then jQuery(".prevButton", el).hide()
    if stage._last then jQuery(".nextButton", el).hide()
    jQuery(".prevButton", el).button()
    .click =>
        newIndex = jQuery(".stages").find("ul.titles .ui-tabs-active").prev().index()
        jQuery(".stages").tabs "select", newIndex
    jQuery(".nextButton", el).button()
    .click =>
        newIndex = jQuery(".stages").find("ul.titles .ui-tabs-active").next().index()
        jQuery(".stages").tabs "select", newIndex
    jQuery(".stage-content.tts", el).attr "tts", stage.speech if stage.speech
    el

