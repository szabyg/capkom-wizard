# This module defines the wizard stages.
Capkom = this.Capkom ?= {}

# Defining in which order the wizard stages will follow
Capkom.order = [
    "welcome"
    "symbolsize"
    "fontsize"
    "symbolset"
    "read"
    "symbolunderstanding"
    "lookforcorrect"
    "theme"
    # "channels"
    "goodbye"
]

Capkom.stages =
  # Definition of the welcome screen
  "welcome":
      title: "Willkommen"
      image: "img/welcome.png"
      speech:
          """
          Hallo im Online-Atelier! Ich helfe dir damit du das Online-Atelier gut verwenden kannst. Lass uns
          zuerst spielen!
          """

      html:
          """
          Hallo im Online-Atelier! Ich helfe Dir damit Du das Online-Atelier gut verwenden kannst. Lass uns
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
              <button class="previousButton demoButton" alt="Zurück" ><i class = "icon-arrow-left" /> Zurück</button>&nbsp;<button class="nextButton demoButton" alt="Weiter" >Weiter <i class = "icon-arrow-right" /></button>
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

        Capkom.timeout.start 2, ->
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
      Wir beginnen mit einem Spiel: Füttere den Hund. Das Füttern geht so: Klicke mit der linken Maus-Taste auf den Hund.
      Wenn du es oft schaffst, ist der Hund glücklich und gesund.

    """

    condition: (profile) ->
      profile.get "useSymbols"
    image: "img/symbolsize.png"
    html: """
      Wir beginnen mit einem Spiel: Füttere den Hund. Das Füttern geht so: Klicke mit der linken Maus-Taste auf den Hund.
      Wenn du es oft schaffst, ist der Hund glücklich und gesund.
      <button class='start'>Start</button>
      <div class='fangspiel-area'></div>
    """
    _dont_startGame: (element, done) ->
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
      Bild aus der zweiten Reihe. Klicke das richtige Bild an!
    """

    condition: (profile) ->
      profile.get "useSymbols"
    image: "img/symbolmatch.png"
    html: """
      Finde heraus welche Bilder zusammengehören. Zu dem Bild in der ersten Reihe passt immer ein
      Bild aus der zweiten Reihe. Klicke das richtige Bild an!
      <button class='start'>Start</button>
    """
    scriptOnce: (element) ->
      jQuery('.start', element).button().click (e) ->
        jQuery('.play-area', element).wordmatch
          rootPrefix: 'lib/wordmatch/img/'
          result: (res) ->
            Capkom.profile.set
              symbolunderstanding: res
            Capkom.clickNext()
            jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'
          questions: Capkom.symbolunderstandingQuestions
          numberOfQuestions: 5
          feedbackPos: ['Super!', 'Toll!', 'Sehr gut!', 'Perfekt!']
        jQuery('.start', element).hide()
    startGame: (element, done) ->
      jQuery('.play-area', element).wordmatch
        rootPrefix: 'lib/wordmatch/img/'
        result: (res) ->
          Capkom.profile.set
            symbolunderstanding: res
          Capkom.clickNext()
          jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'
          jQuery('.start', element).show()
        questions: Capkom.symbolunderstandingQuestions
        numberOfQuestions: 5
        feedbackPos: ['Super!', 'Toll!', 'Sehr gut!', 'Perfekt!']
        done()
      jQuery('.start', element).hide()

    show: (element) ->
    hide: (element) ->
      jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'
  ###
   Definition of the symbol size selection screen
  ###
  "lookforcorrect":
    title: "Fehlersuche"
    # only show it if symbols are turned on
    speech: """
      Suche und klicke auf das gleiche Bild.
    """

    condition: (profile) ->
      profile.get "useSymbols"
    image: "http://i.fonts2u.com/sn/mp1_snoopy-dings_1.png"
    html: """
      Suche und klicke auf das gleiche Bild.
      <button class='start'>Start</button>
    """
    scriptOnce: (element) ->
      jQuery('.start', element).button().click (e) ->
        jQuery('.play-area', element).wordmatch
          rootPrefix: 'lib/wordmatch/img/'
          result: (res) ->
            Capkom.profile.set
              lookforcorrect: res
            Capkom.clickNext()
            jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'
          questions: Capkom.lookforcorrectQuestions
          numberOfQuestions: 6
          feedbackPos: ['Super!', 'Toll!', 'Sehr gut!', 'Perfekt!']
        jQuery('.start', element).hide()

    startGame: (element, done) ->
      jQuery('.play-area', element).wordmatch
        rootPrefix: 'lib/wordmatch/img/'
        result: (res) ->
          Capkom.profile.set
            lookforcorrect: res
          Capkom.clickNext()
          jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'
          jQuery('.start', element).show()
        questions: Capkom.lookforcorrectQuestions
        numberOfQuestions: 6
        feedbackPos: ['Super!', 'Toll!', 'Sehr gut!', 'Perfekt!']
        done()
      jQuery('.start', element).hide()

    show: (element) ->
    hide: (element) ->
      jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'

  "read":
    title: "Wort-Bild Spiel"
    image: "img/read.png"
    speech: """
      Bei diesem Spiel zeigen wir dir Wörter und Bilder. Klicke das richtige Wort oder Bild an!
    """
    html: """
      Bei diesem Spiel zeigen wir dir Wörter und Bilder. Klicke das richtige Wort / Bild an!
      <br/>
      <button class='start'>Start</button>
      <button class='skip'>Überspringen</button>
    """
    scriptOnce: (element) ->
      jQuery('.start', element).button().click (e) ->
        jQuery('.play-area', element).wordmatch
          rootPrefix: 'lib/wordmatch/img/'
          result: (res) ->
            Capkom.profile.set
              read: res
            Capkom.clickNext()
            jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'
          questions: Capkom.wordmatchQuestions
          feedbackPos: ['Super!', 'Toll!', 'Sehr gut!', 'Perfekt!']
        jQuery('.start', element).hide()
      jQuery('.skip', element).button().click (e) ->
        Capkom.profile.set
          read:
            symbol2word:
              correct: 0
              "wrong": 0
              "times":
                "average": 0
                "variance": 0
                "standardDeviation": 0
              "score": 0
            word2symbol:
              "correct": 0
              "wrong": 0
              "times":
                "average": 0
                "variance": 0
                "standardDeviation": 0
              "score": 0
        Capkom.clickNext()

    startGame: (element, done) ->
      jQuery('.play-area', element).wordmatch
        rootPrefix: 'lib/wordmatch/img/'
        result: (res) ->
          Capkom.profile.set
            read: res
          done()
          Capkom.clickNext()
          jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'
          jQuery('.start', element).show()
        questions: Capkom.wordmatchQuestions
        feedbackPos: ['Super!', 'Toll!', 'Sehr gut!', 'Perfekt!']
      jQuery('.start', element).hide()

    show: (element) ->
    hide: (element) ->
      jQuery(':Capkom-wordmatch.play-area', element).wordmatch 'destroy'

  "fontsize":
      title: "Schriftgröße"
      image: "img/fontsize.png"
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
      image: "img/design.png"
      speech: """
        Wie soll dein Online-Atelier aussehen? Klicke auf ein Bild zum ausprobieren. Wenn Du fertig bist, klicke auf weiter.
      """
      html: """
        Wie soll dein Online-Atelier aussehen? Klicke auf ein Bild zum ausprobieren. Wenn Du fertig bist, klicke auf weiter.
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
          jQuery('.plus', element).hide()

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
      image: "img/symbolset.png"
      speech: "Welches Bild siehst Du besser? Klicke es an!"
      html: """
          Welches Bild siehst Du besser? </br> Klicke es an!
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
      image: "img/goodbye.png"
      speech: "Du hast nun dein Online-Atelier so eingestellt, dass du es gut verwenden kannst."
      html: """
        Du hast nun dein Online-Atelier so eingestellt, dass du es gut verwenden kannst.
        <br/><br/>
        Usertest ID: <span id='usertest-id'/>
      """
      scriptOnce: (el) ->
          profileText = -> JSON.stringify(Capkom.profile.toJSON())
              .replace(/,"/g, ',<br/>"')
              .replace(/^{|}$/g, "")
              .replace(/":/g, '": ')
          Capkom.profile.bind "change", (profile) ->
              jQuery("#goodbye #profile").html profileText()
          jQuery("#profile", el).html profileText()
      startGame: ->
        if Capkom.allStagesFinished()
          Capkom.profile.set
            dimensions: Capkom.getDimensions
          Capkom.saveTestData Capkom.profile
Capkom.getTestDataId = (cb) ->
  db = jQuery.couch.db('capkom-testresults')
  db.info success: (data) ->
    Capkom.console.info 'view data', data.doc_count
    cb "UT-#{data.doc_count}"
Capkom.saveTestData = (doc) ->
  # if jQuery.browser.msie
  jQuery.couch.urlPrefix = "http://dev.iks-project.eu/couchdb"
  # else
    # jQuery.couch.urlPrefix = "http://dev.iks-project.eu/cors/dev.iks-project.eu:80/couchdb";
  jQuery.couch.info success: (data) ->
  db = jQuery.couch.db('capkom-testresults')
  db.info
    success: (data) ->
      Capkom.console.info 'db info', data
    error: (jqXhr, message) ->
      Capkom.console.error "couchdb info error: #{message}"

  save = ->
    db.saveDoc doc.toJSON(),
      success: (res) ->
        if res.ok
          Capkom.console.info "doc saved", res
          doc.set _rev: res.rev
          jQuery('#usertest-id').html "#{doc.get '_id'}"
        else
          Capkom.console.info 'Error saving Usertest document', res
      error: (jqXhr, message) ->
        Capkom.console.error "saveDoc error: #{message}"
  if doc.get '_id'
    save()
  else
    Capkom.getTestDataId (id) ->
      doc.set '_id': id
      save()

Capkom.allStagesFinished = ->
  return Capkom.profile.get('read') and Capkom.profile.get('symbolunderstanding') and Capkom.profile.get('symbolsizedetectDetails') # are all filled out

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

