# This module defines the wizard stages.
Capkom = this.Capkom ?= {}

# Defining in which order the wizard stages will follow
Capkom.order = [
    "welcome"
    "symbolsize"
    "read"
    "fontsize"
    "theme"
    "channels"
    "symbolset"
    "goodbye"
]

Capkom.stages =
    # Definition of the welcome screen
    "welcome":
        title: "Willkommen"
        image: "http://www.greeting-cards-4u.com/tubes/CharlyBrown/snoopy.gif"
        speech:
            """
            Willkommen im Online-Atelier! Hier bekommst du Hilfe beim Hochladen neuer Bilder,
            beim Erstellen deines Profils und bei der Kommunikation mit anderen Künstlern.
            Lass‘ uns ein kleines Spiel spielen!
            """

        html: 
            """
            Willkommen im Online-Atelier! Hier bekommst du Hilfe beim Hochladen neuer Bilder,
            beim Erstellen deines Profils und bei der Kommunikation mit anderen Künstlern.
            Lass‘ uns ein kleines Spiel spielen!
            <div class="explain-area"></div>
            """
        explain: (element, done) ->
          explainArea = jQuery '.explain-area', element
          explainWeiter = (done) ->
            weiterArea = explainArea.append("<div class='weiter'></div>").find('.weiter')
            weiterArea.explain
              read: "Hier geht’s im Spiel weiter."
              useAudio: Capkom.profile.get('useAudio')
              html: """
              <button class=" nextButton" alt="Weiter" >
              Weiter
              <i class = "icon-arrow-right" />
              </button>
              """
              script: (element) ->
                jQuery(element).find('button').button()
              after: ->
                _.defer ->
                  weiterArea.remove()
                  done()
              ttsOptions:
                spinnerUri: "css/spinner.gif"
                dialogTitle: "Sprechblase"
                lang: "de"
              forcedClose: (e) ->
                Capkom.audioOff()

          explainAudioKnopf = (done) ->
            audioknopfArea = explainArea.append("<div class='audioknopf'></div>").find('.audioknopf')
            audioknopfArea.explain
              read: "Drücke diesen Knopf, wenn du das Vorlesen aktivieren oder deaktivieren möchtest."
              useAudio: Capkom.profile.get('useAudio')
              html: """
              <button class='tts-button' alt='Vorlesen'><i class='icon-volume-up'/></button>
              """
              script: (element) ->
                jQuery(element).find('button').button()
              after: ->
                _.defer ->
                  audioknopfArea.remove()
                  done()
              ttsOptions:
                spinnerUri: "css/spinner.gif"
                dialogTitle: "Sprechblase"
                lang: "de"
              forcedClose: (e) ->
                Capkom.audioOff()

          Capkom.timeout.start 4, ->
            explainWeiter ->
              console.info "explanation done"
              Capkom.timeout.start 2, ->
                explainAudioKnopf ->
                  done()

        show: (element) ->
          if Capkom.nonClickMode()
            Capkom.timeout.start 2, ->
              Capkom.clickNext()

    ###
     Definition of the symbol size selection screen
    ###
    "symbolsize":
      title: "Symbolgröße"
      # only show it if symbols are turned on
      speech: """
        Wir beginnen mit einem Fangspiel: Fange die Käsestücke mit der Maus, indem du
        auf die Quadrate klickst. Versuche, möglichst viele Quadrate mit der Maus zu treffen, damit deine Maus ausreichend Futter bekommt.
        """

      condition: (profile) ->
        profile.get "useSymbols"
      image: "http://i.fonts2u.com/sn/mp1_snoopy-dings_1.png"
      html: """
      Wir beginnen mit einem Fangspiel: Fange die Käsestücke mit der Maus, indem du
      auf die Quadrate klickst. Versuche, möglichst viele Quadrate mit der Maus zu treffen,
      damit deine Maus ausreichend Futter bekommt.<br/>
      <button class='start'>Start</button>
      <div class='fangspiel-area'></div>
      """
      explain: (element, done) ->
        Capkom.timeout.start 4, ->
          if Capkom.nonClickMode
            ttswidget = jQuery('.tts', element)
            ttswidget.bind 'ttswidgetdone', (e) ->
              done()
            ttswidget.ttswidget('talk')
      show: (element, done) ->
        if Capkom.nonClickMode()
          Capkom.timeout.start 2, ->
            jQuery('.fangspiel-area', element).sizedetect()

      scriptOnce: (element) ->
        jQuery('.start', element).button().click (e) ->
          jQuery('.fangspiel-area', element).sizedetect
            result: (size, details) ->
              Capkom.profile.set
                symbolsizeMin: size
                symbolsizedetectDetails: details

    "read":
      title: "Wort-Bild Spiel"
      image: "http://www.balloonmaniacs.com/images/snoopygraduateballoon.jpg"
      speech: """
      Nun zeigen wir dir immer ein Bild und du musst das richtige Wort dazu finden. Schau
      dir das Bild an und klicke dann von den drei Wörtern auf das jeweils richtige Wort.
      """
      html: """
        Nun zeigen wir dir immer ein Bild und du musst das richtige Wort dazu finden. Schau'
        dir das Bild an und klicke dann von den drei Wörtern auf das jeweils richtige Wort. <br/>
        <button class='start'>Start</button>
        <div class='wortspiel-area'></div>
      """
      scriptOnce: (element) ->
        jQuery('.start', element).button().click (e) ->
          jQuery('.wortspiel-area', element).wordmatch
            rootPrefix: 'lib/wordmatch/img/'
            result: (res) ->
              Capkom.profile.set
                wordmatch: res
              Capkom.clickNext()
              jQuery('.wortspiel-area', element).wordmatch 'destroy'
      show: (element) ->
        _.defer ->
          Capkom.timeout.start 4, ->
            if Capkom.profile.get('useAudio')
              jQuery('.tts', element).ttswidget('talk')

    "fontsize":
        title: "Schriftgröße"
        image: "http://www.thepartyanimal-blog.org/wp-content/uploads/2010/09/Halloween-Snoopy5.jpg"
        speech: "Welche Schriftgröße ist für dich am angenehmsten?"
        html:
            """
            Welche Schriftgröße ist für dich am angenehmsten?<br/><br/>
            <div class='fontsize'></div>
            """
        scriptOnce: (element) ->
            jQuery(".fontsize").fontsize
                value: Number Capkom.profile.get('fontsize').replace("s", "")
                change: (val) ->
                    Capkom.profile.set 'fontsize': "s#{val}"

    # Definition of the theme selection screen
    "theme":
        title: "Design"
        image: "http://www.balloonmaniacs.com/images/snoopygraduateballoon.jpg"
        speech: "Bitte bestimme nun das Bildschirmdesign. Wähle dazu jenes Design, das dir am besten gefällt."
        html: """
            Bitte bestimme nun das Bildschirmdesign.<br/>
            Wähle dazu jenes Design, das dir am besten gefällt.<br/><br/>
            <span id='themeselector'></span>
        """
        scriptOnce: (element) ->
            jQuery("#themeselector", element)
            .themeswitcher
                #width: "17em"
                width: "5em"
                buttonHeight: 30
                onSelect: ->
                    Capkom.profile.set
                        "theme": $.cookie("jquery-ui-theme")

    "channels":
        title: 'Sprache/Symbole <img src="lib/ttswidget/speaker22.png" width="22" alt="Sprache"/>'
        image: "http://www.ecartooes.com/img/snoopy/peanuts_snoopy_11.jpg"
        speech: "Wie sollen Informationen dargestellt werden? Mit oder ohne Symbolen? Mit oder ohne Sprachausgabe?"
        html: """
            Wie sollen Informationen dargestellt werden?<br/><br/>
            <input type='radio' name='e2r' id='e2r-both'/>
            <label for='e2r-both' class='capkom-label' symbolId='text-with-symbols' donthidesymbol='true'>Text + Symbole</label>
            <input type='radio' name='e2r' id='e2r-alone'/>
            <label for='e2r-alone' class='capkom-label' symbolId='text-only' donthidesymbol='true'>Text</label>
            <br/><br/>
            <span symbolId='tts' class='capkom-label'>Sprachausgabe</span>:<br/><br/>
            <input type='radio' name='useAudio' id='audio-on'/>
            <label for='audio-on'>
                <img src='symbols/Gnome-Audio-Volume-Medium-64.png' width='64' alt='Sprachausgabe an'/>
            </label>
            <input type='radio' name='useAudio' id='audio-off'/>
            <label for='audio-off'>
                <img src='symbols/Gnome-Audio-Volume-Muted-64.png' width='64' alt='Keine Sprachausgabe'/>
            </label>
        """
        scriptOnce: (element) ->
            # activate the buttons according to the profile
            if Capkom.profile.get "useSymbols"
                jQuery("#e2r-both").attr "checked", "checked"
            else
                jQuery("#e2r-alone").attr "checked", "checked"
            jQuery('#e2r-alone, #e2r-both')
            .button()
            # Handle click event, change profile
            .click ->
                state = @id.replace "e2r-", ""
                switch state
                    when "alone"
                        Capkom.profile.set
                            useE2r: true
                            useSymbols: false
                    when "both"
                        Capkom.profile.set
                            useE2r: true
                            useSymbols: true

            # Set button state according to the profile
            if Capkom.profile.get "useAudio"
                jQuery("#audio-on").attr "checked", "checked"
            else
                jQuery("#audio-off").attr "checked", "checked"

            jQuery('#audio-on, #audio-off')
            .button()
            # Handle click event, change profile
            .click ->
                state = @id.replace "audio-", ""
                switch state
                    when "on"
                        Capkom.profile.set
                            useAudio: true
                    when "off"
                        Capkom.profile.set
                            useAudio: false

    # Definition of the symbolset selection screen
    "symbolset":
        title: "<label symbol-id='symbolset'>Symbolsatz</label>"
        ###
         only show it if symbols are turned on
        ###
        condition: (profile) ->
            profile.get "useSymbols"
        image: "http://www.gelsenkirchener-geschichten.de/userpix/1208/1208_snoopy006_3.gif"
        speech: "Welche Art der Symbole gefällt dir am besten?"
        html: """
            Welche Art der Symbole gefällt dir am besten?<br/>
            Du kannst dir später auch Deine eigenen Symbole schaffen, indem du eigene Bilder oder Fotos hochlädst.
            <div class='symbolset-symbols'></div>
        """
        scriptOnce: (element) ->
            symbolSets = _.filter Capkom.symbolSets.sets, (symbolSet) ->
                symbolSet.hasSymbol "mainSymbol"
            Capkom.console.info symbolSets
            for symbolSet in symbolSets
                html = """
                    <input type='radio' class='symbolset-selector #{symbolSet.name}' name='symbolset' value='#{symbolSet.name}' id='symbolset-#{symbolSet.name}'/>
                    <label for='symbolset-#{symbolSet.name}'>
                        <img src='#{symbolSet.getSymbolUri("mainSymbol", "large")}'/>
                    </label>
                """
                jQuery(html)
                .appendTo('.symbolset-symbols', element)

            symbolSetName = Capkom.profile.get 'symbolSet'
            jQuery('.symbolset-selector', element)
            .filter(".#{symbolSetName}").attr("checked", "checked").end()
            .button().click ->
                Capkom.console.log 'click'
                Capkom.profile.set
                    symbolSet: jQuery(@).val()
            # Mark current profile selection as active
            jQuery(".symbolset-symbols .symbolset-mainSymbol", element)
            .find(".#{symbolSet}").addClass('selected').end()
            .button()

    "goodbye":
        title: "Ende"
        image: "http://www.slowtrav.com/blog/teachick/snoopy_thankyou_big.gif"
        speech: "Dein Profil enthält nun Informationen, die ich jetzt trotzdem nicht vorlesen werde, weil sie nur für die Entwickler da sind."
        html: """
            Vielen Dank für deine Zeit! <br/>
            Dein Profil enthält nun folgende Informationen:<br/><br/>
            <div id="profile"></div>
        """
        scriptOnce: (el) ->
            profileText = -> JSON.stringify(Capkom.profile.toJSON())
                .replace(/,"/g, ',<br/>"')
                .replace(/^{|}$/g, "")
                .replace(/":/g, '": ')
            Capkom.profile.bind "change", (profile) ->
                jQuery("#goodbye #profile").html profileText()
            jQuery("#profile", el).html profileText()

###
Get an array of stage objects in the configured order.
###
Capkom.getStages = ->
    res = for i, stagename of Capkom.order
        stage = Capkom.stages[stagename]
        stage.name = stagename
        stage
    res[0]._first = true
    res[res.length-1]._last = true


    ### 
    Filter out the dependent and not-to-show stages based on `stage.condition`
    ###
    res = _(res).filter (stage) ->
        true unless stage.condition?(Capkom.profile) is false
Capkom.showStages = (el) ->
    if Capkom.uiLoaded
        stages = @getStages()
        stageNames = _.map stages, (stage) ->
            stage.name
        anchors = jQuery(".stages").find("ul.titles").children()

        ###
        Remove not necessary tabs
        ###
        for i in [0..anchors.length-1].reverse()
            anchor = anchors[i]
            anchorName = jQuery(anchor).find("a").attr("href").replace /^#/, ""
            ### anchorName not in stageNames? ###
            if _.indexOf(stageNames, anchorName) is -1
    #            el.tabs "remove", i
                jQuery(".stages").find("[href=##{anchorName}]").parent().hide()

        ###
        Return the current anchorNames
        ###
        anchorNames = -> _.map anchors, (anchor) ->
            jQuery(anchor).find("a").attr("href").replace /^#/, ""

        ###
        Add new tabs
        ###
        for stage, i in stages
            an = anchorNames()
            if _.indexOf(an, stage.name) is -1
                el.append Capkom.renderStage stage, jQuery(".stages"), i
                el.tabs("add", "##{stage.name}", stage.title, i)
            $(".stages").find("[href=##{stage.name}]").parent().show()

