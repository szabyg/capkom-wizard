Capkom = window.Capkom ?= {}

# Defining in which order the wizard stages will follow
Capkom.order = [
    "welcome"
    "fontsize"
    "theme"
    "e2r"
    "symbolset"
    "symbolsize"
    "createuser"
]

Capkom.stages =
    # Definition of the welcome screen
    "welcome":
        title: "Capkom Profil Wizard"
        image: "http://www.greeting-cards-4u.com/tubes/CharlyBrown/snoopy.gif"
        html: 
            """
            Willkommen zum Kunstportal CAPKOM!<br/><br/>
            Hallo, ich heiße Wizi. <br/>
            Ich möchte Euch nun ein paar Fragen zur Bedienung des Kunstportals stellen. <br/>
            Dies wird nur einige Minuten in Anspruch nehmen.
            """

    # Definition of the user creation screen
    "createuser":
        title: "Benutzer anlegen"
        image: "symbols/ueberMich.gif"
        html: """
            <table>
                <tr><td>Benutzername:</td><td><input id=''/></td></tr>
                <tr><td>Password:</td><td><input type='password' id=''/></td></tr>
            </table>
        """

    # Definition of the font size setting screen
    "fontsize":
        title: "Schriftgröße"
        image: "http://www.thepartyanimal-blog.org/wp-content/uploads/2010/09/Halloween-Snoopy5.jpg"
        html:
            """
            Welche Schriftgröße ist für Dich am angenehmsten?<br/><br/>
            <div class='fontsize'>
                <input type='radio' name='fontsize' id='fontsize-small' />
                <label for='fontsize-small' ><span class='fontsize-small'>AAA</span></label>

                <input type='radio' name='fontsize' id='fontsize-medium' />
                <label for='fontsize-medium'><span class='fontsize-medium'>AAA</span></label>

                <input type='radio' name='fontsize' id='fontsize-large' />
                <label for='fontsize-large' ><span class='fontsize-large'>AAA</span></label>
            </div>
            """
        script: (element) ->
            jQuery("#fontsize-#{Capkom.profile.fontsize}").attr "checked", "checked"
            jQuery(".fontsize", element).buttonset()
            .change (e) ->
                console.info "fontsize change", arguments, e.target.id
                Capkom.profile.fontsize = e.target.id.replace "fontsize-", ""

    # Definition of the theme selection screen
    "theme":
        title: "Design"
        image: "http://www.balloonmaniacs.com/images/snoopygraduateballoon.jpg"
        html: """
            Bitte bestimme nun das Bildschirmdesign.<br/>
            Wähle dazu jenes Design, das Dir am besten gefällt.<br/><br/>
            <span id='themeselector'></span>
        """
        script: (element) ->
            jQuery("#themeselector", element)
            .themeswitcher
                width: 300
                onSelect: (theme) ->
                    console.info "selected theme", theme, arguments, @

    # Definition of the symbol size selection screen
    "symbolsize":
        title: "Symbolgröße"
        # only show it if symbols are turned on
        condition: (profile) ->
            profile.useSymbols
        image: "http://i.fonts2u.com/sn/mp1_snoopy-dings_1.png"
        html: """
            Die CAPKOM-Kunstplattform beinhaltet viele Symbole.<br/>
            Wie groß sollen die Symbole sein?
        """

    # Definition of the welcome screen
    # TODO add audio question
    "e2r":
        title: "Sprache/Symbolunterstützt"
        image: "http://www.ecartooes.com/img/snoopy/peanuts_snoopy_11.jpg"
        html: """
            Wie sollen Informationen dargestellt werden?<br/>
            <input type='radio' name='e2r' id='e2r-alone'/>
            <label for='e2r-alone'>Text</label>
            <input type='radio' name='e2r' id='e2r-both'/>
            <label for='e2r-both'>Text + Symbole</label>
            <br/><br/>
            Audio:
            <input type='checkbox' name='audio' id='audioButton'/>
            <label for='audioButton'>[Audio-Symbol]</label>
        """
        script: (element) ->
            jQuery('#e2r-alone, #e2r-both').button()
            jQuery('input[name=audio]').button()

    # Definition of the symbolset selection screen
    "symbolset":
        title: "Symbolsatz"
        # only show it if symbols are turned on
        condition: (profile) ->
            profile.useSymbols
        image: "http://www.gelsenkirchener-geschichten.de/userpix/1208/1208_snoopy006_3.gif"
        html: """
            Welche Art der Symbole gefällt Dir am besten?<br/>
            Du kannst Dir später auch Deine eigenen Symbole schaffen, indem Du eigene Bilder oder Fotos hochlädst.
        """

Capkom.getStages = ->
    res = for i, stagename of Capkom.order
        stage = Capkom.stages[stagename]
        stage.name = stagename
        stage
    res = _(res).filter (stage) ->
        true unless stage.condition?(Capkom.profile) is false
