# This module defines the wizard stages.
Capkom = this.Capkom ?= {}

# Defining in which order the wizard stages will follow
Capkom.order = [
    "welcome"
    "symbolsize"
    "fontsize"
    "read"
    "symbolunderstanding"
    "theme"
    # "channels"
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
          Hallo im Online-Atelier! Wir helfen dir damit du das Online-Atelier gut verwenden kannst. Lass uns
          zuerst spielen!
          """

      html:
          """
          Hallo im Online-Atelier! Wir helfen dir damit du das Online-Atelier gut verwenden kannst. Lass uns
          zuerst spielen!
          <div class="explain-area"></div>
          """
      explain: (element, done) ->
        explainArea = jQuery '.explain-area', element
        explainWeiter = (done) ->
          weiterArea = explainArea.append("<div class='weiter'></div>").find('.weiter')
          weiterArea.explain
            read: "Wenn du jetzt spielen willst, dann benütze den Weiter-Knopf um anzufangen"
            useAudio: Capkom.profile.get('useAudio')
            html: """
              <button class="previousButton demoButton" alt="Zurück" >Zurück <i class = "icon-arrow-left" /></button>&nbsp;<button class="nextButton demoButton" alt="Weiter" >Weiter <i class = "icon-arrow-right" /></button>
            """
            script: (element) ->
              jQuery(element).find('button').button()
            after: ->
              _.defer ->
                weiterArea.remove()
                done()
            ttsOptions: Capkom.getTTSOptions()

        explainAudioKnopf = (done) ->
          audioknopfArea = explainArea.append("<div class='audioknopf'></div>").find('.audioknopf')
          audioknopfArea.explain
            read: """
              Wenn du nicht willst das dir der Text vorgelesen wird, dann drücke diesen Knopf. Du kannst diesen Knopf
              auch später wieder einschalten. Wenn du den Ton eingeschaltet hast ist der Knopf rot umrandet.
            """
            useAudio: Capkom.profile.get('useAudio')
            html: """
            <button class='tts-button demoButton' alt='Vorlesen'><i class='icon-volume-up'/></button>
            """
            script: (element) ->
              jQuery(element).find('button').button()
            after: ->
              _.defer ->
                audioknopfArea.remove()
                done()
            ttsOptions: Capkom.getTTSOptions()

        Capkom.timeout.start 4, ->
          explainAudioKnopf ->
            Capkom.timeout.start 1, ->
              explainWeiter ->
                done()

      ###
      show: (element) ->
        if Capkom.nonClickMode()
          Capkom.timeout.start 2, ->
            Capkom.clickNext()
      ###

  ###
   Definition of the symbol size selection screen
  ###
  "symbolsize":
    title: "Symbolgröße"
    # only show it if symbols are turned on
    speech: """
      Wir beginnen mit einem Spiel: Füttere den Hund. Ziehe die Futterdose auf das Bild von dem Hund.
      Wenn du es oft schaffst, ist der Hund glücklich und gesund.
    """

    condition: (profile) ->
      profile.get "useSymbols"
    image: "http://i.fonts2u.com/sn/mp1_snoopy-dings_1.png"
    html: """
      Wir beginnen mit einem Spiel: Füttere den Hund. Ziehe die Futterdose auf das Bild von dem Hund.
      Wenn du es oft schaffst, ist der Hund glücklich und gesund.
      <button class='start'>Start</button>
      <div class='fangspiel-area'></div>
    """
    ###
    explain: (element, done) ->
      Capkom.timeout.start 4, ->
        if Capkom.nonClickMode
          ttswidget = jQuery('.tts', element)
          _done = (e) ->
            done()
            ttswidget.unbind 'ttswidgetdone', _done
          ttswidget.bind 'ttswidgetdone', _done
          ttswidget.ttswidget('talk')
    show: (element, done) ->
      if Capkom.nonClickMode()
        Capkom.timeout.start 2, ->
          jQuery('.fangspiel-area', element).sizedetect
            rootPrefix: 'lib/sizedetect/'
            result: (size, details) ->
              Capkom.profile.set
                symbolsizeMin: size
                symbolsizedetectDetails: details
    ###
    startGame: (element, done) ->
      jQuery('.fangspiel-area', element).sizedetect
        rootPrefix: 'lib/sizedetect/'
        result: (size, details) ->
          Capkom.profile.set
            symbolsizeMin: size
            symbolsizedetectDetails: details
          # done()
          Capkom.canClick()
          Capkom.clickNext()
    scriptOnce: (element) ->
      jQuery('.start', element).button().click (e) ->
        jQuery('.fangspiel-area', element).sizedetect
          rootPrefix: 'lib/sizedetect/'
          result: (size, details) ->
            Capkom.profile.set
              symbolsizeMin: size
              symbolsizedetectDetails: details
            Capkom.clickNext()

  ###
   Definition of the symbol size selection screen
  ###
  "symbolunderstanding":
    title: "Symbol-Verständnis"
    # only show it if symbols are turned on
    speech: """
      Finde heraus welche Bilder zusammengehören. Zu dem Bild in der ersten Reihe passt immer ein
      Bild aus der zweiten Reihe.
    """

    condition: (profile) ->
      profile.get "useSymbols"
    image: "http://i.fonts2u.com/sn/mp1_snoopy-dings_1.png"
    html: """
      Finde heraus welche Bilder zusammengehören. Zu dem Bild in der ersten Reihe passt immer ein
      Bildaus der zweiten Reihe.
      <button class='start'>Start</button>
      <div class='fangspiel-area'></div>
    """
    scriptOnce: (element) ->
      jQuery('.start', element).button().click (e) ->
        jQuery('.play-area', element).wordmatch
          rootPrefix: 'lib/wordmatch/img/'
          result: (res) ->
            Capkom.profile.set
              wordmatch: res
            Capkom.clickNext()
            jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'
          questions: Capkom.symbolunderstandingQuestions
          numberOfQuestions: 5
          feedbackPos: ['Super! :-)', 'Toll! :-)', 'Sehr gut! :-)', 'Perfekt! :-)']
        jQuery('.start', element).hide()

    startGame: (element, done) ->
      jQuery('.play-area', element).wordmatch
        rootPrefix: 'lib/wordmatch/img/'
        result: (res) ->
          Capkom.profile.set
            wordmatch: res
          Capkom.clickNext()
          jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'
          jQuery('.start', element).show()
        questions: Capkom.symbolunderstandingQuestions
        numberOfQuestions: 5
        feedbackPos: ['Super! :-)', 'Toll! :-)', 'Sehr gut! :-)', 'Perfekt! :-)']
        done()
      jQuery('.start', element).hide()

    show: (element) ->
    hide: (element) ->
      jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'

  "read":
    title: "Wort-Bild Spiel"
    image: "http://www.balloonmaniacs.com/images/snoopygraduateballoon.jpg"
    speech: """
      Bei diesem Spiel zeigen wir dir Wörter und Bilder. Wähle das passende Wort oder Bild aus.
    """
    html: """
      Bei diesem Spiel zeigen wir dir Wörter und Bilder. Wähle das passende Wort oder Bild aus.
      <br/>
      <button class='start'>Start</button>
    """
    scriptOnce: (element) ->
      jQuery('.start', element).button().click (e) ->
        jQuery('.play-area', element).wordmatch
          rootPrefix: 'lib/wordmatch/img/'
          result: (res) ->
            Capkom.profile.set
              wordmatch: res
            Capkom.clickNext()
            jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'
          questions: Capkom.wordmatchQuestions
          feedbackPos: ['Super! :-)', 'Toll! :-)', 'Sehr gut! :-)', 'Perfekt! :-)']
        jQuery('.start', element).hide()

    startGame: (element, done) ->
      jQuery('.play-area', element).wordmatch
        rootPrefix: 'lib/wordmatch/img/'
        result: (res) ->
          Capkom.profile.set
            wordmatch: res
          done()
          Capkom.clickNext()
          jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'
          jQuery('.start', element).show()
        questions: Capkom.wordmatchQuestions
        feedbackPos: ['Super! :-)', 'Toll! :-)', 'Sehr gut! :-)', 'Perfekt! :-)']
      jQuery('.start', element).hide()

    show: (element) ->
    hide: (element) ->
      jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'

  "fontsize":
      title: "Schriftgröße"
      image: "http://www.thepartyanimal-blog.org/wp-content/uploads/2010/09/Halloween-Snoopy5.jpg"
      speech: "Klicke auf die Schriftgröße, die du am besten lesen kannst. Du kannst diese hier ausprobieren. Wenn du fertig bist, klicke auf den Weiter Knopf."
      html:
          """
          Klicke auf die Schriftgröße, die du am besten lesen kannst. Du kannst diese hier ausprobieren. Wenn du fertig bist, klicke auf den Weiter Knopf.<br/><br/>
          <div class='fontsize'></div>
          """
      scriptOnce: (element) ->
          jQuery(".fontsize").fontsize
              value: Number Capkom.profile.get('fontsize').replace("s", "")
              change: (val) ->
                  Capkom.profile.set 'fontsize': "s#{val}"

  # Definition of the theme selection screen
  "theme":
      title: "Aussehen"
      image: "http://www.balloonmaniacs.com/images/snoopygraduateballoon.jpg"
      speech: """
        Wie soll dein Online-Atelier aussehen? Hier siehst du mehrere Bilder und du kannst sie gleich
        ausprobieren. Dann drücke auf den Knopf "Weiter".
      """
      html: """
        Wie soll dein Online-Atelier aussehen? Hier siehst du mehrere Bilder und du kannst sie gleich
        ausprobieren. Dann drücke auf den Knopf "Weiter".
        <br/><br/>
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
      title: "<label symbol-id='symbolset'>Bildart</label>"
      ###
       only show it if symbols are turned on
      ###
      condition: (profile) ->
          profile.get "useSymbols"
      image: "http://www.gelsenkirchener-geschichten.de/userpix/1208/1208_snoopy006_3.gif"
      speech: "Welche Art von bildern gefällt dier besser. Suche dir eines aus. Später kannst du auch deine eigenen Bilder und Fotos verwenden."
      html: """
          Welche Art von Bildern gefällt dir besser? Suche dir eines aus.<br/>
          <div class='symbolset-symbols'></div>
          Später kannst du auch deine eigenen Bilder und Fotos verwenden.
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
      speech: "Du hast nun dein Online-Atelier so eingestellt, dass du es gut verwenden kannst."
      html: """
        Du hast nun dein Online-Atelier so eingestellt, dass du es gut verwenden kannst.
        <br/><br/>
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

