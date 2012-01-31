# This module defines the wizard stages.
Capkom = window.Capkom ?= {}

# Defining in which order the wizard stages will follow
Capkom.order = [
    "welcome"
    "fontsize"
    "theme"
    "channels"
    "symbolset"
    "symbolsize"
    "goodbye"
]

Capkom.stages =
    # Definition of the welcome screen
    "welcome":
        title: "Willkommen <img src='symbols/symbol.gif' class='symbol' width='18' alt='Symbole'/>"
        image: "http://www.greeting-cards-4u.com/tubes/CharlyBrown/snoopy.gif"
        speech:
            """
            Willkommen zum Kunstportal CAPKOM!
            Hallo, ich heisse Wizi.
            Ich möchte euch nun ein paar Fragen zur Bedienung des Kunstportals stellen.
            Dies wird nur einige Minuten in Anspruch nehmen.
            """

        html: 
            """
            Willkommen zum Kunstportal CAPKOM!<br/><br/>
            Hallo, ich heiße Wizi. <br/>
            Ich möchte euch nun ein paar Fragen zur Bedienung des Kunstportals stellen. <br/>
            Dies wird nur einige Minuten in Anspruch nehmen.
            """

    # Definition of the font size setting screen
    "fontsize":
        title: "Schriftgröße <img src='symbols/symbol.gif' class='symbol' width='18' alt='Symbole'/>"
        image: "http://www.thepartyanimal-blog.org/wp-content/uploads/2010/09/Halloween-Snoopy5.jpg"
        speech: "Welche Schriftgröße ist für dich am angenehmsten?"
        html:
            """
            Welche Schriftgröße ist für dich am angenehmsten?<br/><br/>
            <div class='fontsize'>
                <input type='radio' name='fontsize' id='fontsize-small' />
                <label for='fontsize-small' ><span class='fontsize-small choose-button'>AAA</span></label>

                <input type='radio' name='fontsize' id='fontsize-medium' />
                <label for='fontsize-medium'><span class='fontsize-medium choose-button'>AAA</span></label>

                <input type='radio' name='fontsize' id='fontsize-large' />
                <label for='fontsize-large' ><span class='fontsize-large'>AAA</span></label>
            </div>
            """
        script: (element) ->
            jQuery("#fontsize-#{Capkom.profile.get 'fontsize'}").attr "checked", "checked"
            jQuery(".fontsize", element).buttonset()
            .change (e) ->
                Capkom.profile.set 'fontsize': e.target.id.replace "fontsize-", ""

    # Definition of the theme selection screen
    "theme":
        title: "Design <img src='symbols/symbol.gif' class='symbol' width='18' alt='Symbole'/>"
        image: "http://www.balloonmaniacs.com/images/snoopygraduateballoon.jpg"
        speech: "Bitte bestimme nun das Bildschirmdesign. Wähle dazu jenes Design, das dir am besten gefällt."
        html: """
            Bitte bestimme nun das Bildschirmdesign.<br/>
            Wähle dazu jenes Design, das dir am besten gefällt.<br/><br/>
            <span id='themeselector'></span>
        """
        script: (element) ->
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
            <label for='e2r-both'>Text + Symbole <img src='symbols/symbol.gif' width='18' alt='Symbole'/></label>
            <input type='radio' name='e2r' id='e2r-alone'/>
            <label for='e2r-alone'>Text</label>
            <br/><br/>
            Sprachausgabe:<br/><br/>
            <input type='radio' name='useAudio' id='audio-on'/>
            <label for='audio-on'><img src='symbols/Gnome-Audio-Volume-Medium-64.png' width='64' alt='Symbole'/></label>
            <input type='radio' name='useAudio' id='audio-off'/>
            <label for='audio-off'><img src='symbols/Gnome-Audio-Volume-Muted-64.png' width='64' alt='Symbole'/></label>

        """
        script: (element) ->
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
        title: "<label symbol-id='symbolset'>Symbolsatz <img src='symbols/symbol.gif' class='symbol' width='18' alt='Symbole'/></label>"
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
        """

    ###
     Definition of the symbol size selection screen
    ###
    "symbolsize":
        title: "Symbolgröße <img src='symbols/symbol.gif' class='symbol' width='18' alt='Symbole'/>"
        # only show it if symbols are turned on
        condition: (profile) ->
            profile.get "useSymbols"
        image: "http://i.fonts2u.com/sn/mp1_snoopy-dings_1.png"
        html: """
            Die CAPKOM-Kunstplattform beinhaltet viele Symbole.<br/>
            Wie groß sollen die Symbole sein?
        """
        speech: "Wie groß sollen die Symbole sein?"

    "goodbye":
        title: "Ende <img src='symbols/symbol.gif' class='symbol' width='18' alt='Symbole'/>"
        image: "http://www.slowtrav.com/blog/teachick/snoopy_thankyou_big.gif"
        html: """
            Vielen Dank für deine Zeit! <br/>
            Dein Profil enthält nun folgende Informationen:<br/><br/>
            <div id="profile"></div>
        """
        script: (el) ->
            jQuery("#profile", el).html JSON.stringify(Capkom.profile.toJSON())
                .replace(/,"/g, ',<br/>"')
                .replace(/^{|}$/g, "")
                .replace(/":/g, '": ')

###
Get an array of stage objects in the configured order.
###
Capkom.getStages = ->
    res = for i, stagename of Capkom.order
        stage = Capkom.stages[stagename]
        stage.name = stagename
        stage

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
            anchorName = jQuery(anchor).find("a").attr("hash").replace /^#/, ""
            ### anchorName not in stageNames? ###
            if _.indexOf(stageNames, anchorName) is -1
    #            el.tabs "remove", i
                jQuery(".stages").find("[href=##{anchorName}]").parent().hide()

        ###
        Return the current anchorNames
        ###
        anchorNames = -> _.map anchors, (anchor) ->
            jQuery(anchor).find("a").attr("hash").replace /^#/, ""

        ###
        Add new tabs
        ###
        for stage, i in stages
            an = anchorNames()
            if _.indexOf(an, stage.name) is -1
                el.append Capkom.renderStage stage, jQuery(".stages"), i
                el.tabs("add", "##{stage.name}", stage.title, i)
            $(".stages").find("[href=##{stage.name}]").parent().show()

