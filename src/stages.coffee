Capkom = window.Capkom ?= {}

Capkom.stages =
    "welcome":
        title: "Capkom Profilerstellung Wizard"
        image: "http://www.greeting-cards-4u.com/tubes/CharlyBrown/snoopy.gif"
        html: 
            """
            Willkommen zum Kunstportal CAPKOM!<br/><br/>
            Hallo, ich heiße Wizi. <br/>
            Ich möchte Euch nun ein paar Fragen zur Bedienung des Kunstportals stellen. <br/>
            Dies wird nur einige Minuten in Anspruch nehmen.
            """

    "createuser":
        title: "Benutzer anlegen"
        image: "symbols/ueberMich.gif"
        html: """
            Benutzername: <input id=''/><br/>
            Password: <input id=''/>
        """

    "fontsize":
        title: "Schriftgröße"
        image: "http://www.thepartyanimal-blog.org/wp-content/uploads/2010/09/Halloween-Snoopy5.jpg"
        html:
            """
            Welche Schriftgröße ist für Dich am angenehmsten?<br/><br/>
            <div class='fontsize'>
                <input type='radio' name='fontsize' id='fontsize-small' />
                <label for='fontsize-small' class='fontsize-small'>AAA</label>

                <input type='radio' name='fontsize' id='fontsize-medium' />
                <label for='fontsize-medium' class='fontsize-medium'>AAA</label>

                <input type='radio' name='fontsize' id='fontsize-large' />
                <label for='fontsize-large' class='fontsize-large'>AAA</label>
            </div>
            """
        script: (element) ->
            jQuery("#fontsize-#{Capkom.profile.fontsize}").attr "checked", "checked"
            jQuery(".fontsize", element).buttonset()
            .change (e) ->
                console.info "fontsize change", arguments, e.target.id
                Capkom.profile.fontsize = e.target.id.replace "fontsize-", ""

    "theme":
        title: "Bildschirm design"
        image: "symbols/ueberMich.gif"
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

    "symbolsize":
        title: "Symbolgröße"
        image: "symbols/ueberMich.gif"
        html: """
            Die CAPKOM-Kunstplattform beinhaltet viele Symbole.<br/>
            Wie groß sollen die Symbole sein?
        """

    "e2r":
        title: "Sprache/Symbolunterstützt"
        image: "symbols/ueberMich.gif"
        html: """
            Wie sollen Informationen dargestellt werden?<br/>

            <input type='radio' name='e2r' id='e2r-alone'/>
            <label for='e2r-alone'>Text</label>
            <input type='radio' name='e2r' id='e2r-alone'/>
            <label for='e2r-both'>Text + Symbole</label>
            <br/><br/>
            Audio:
            <input type='checkbox' name='audio' id='audioButton'/>
            <label for='audioButton'>[Audio-Symbol]</label>
        """
        script: (element) ->
            jQuery('input[name=e2r]').buttonset()
            jQuery('input[name=audio]').button()

    "symbolset":
        title: "Symbolsatz"
        image: "http://www.fongia.com/varie/varie/snoopy2.gif"
        html: """
            Welche Art der Symbole gefällt Dir am besten?<br/>
            Du kannst Dir später auch Deine eigenen Symbole schaffen, indem Du eigene Bilder oder Fotos hochlädst.
        """

Capkom.order = [
    "welcome"
    "fontsize"
    "theme"

    # TODO implement dependent stages
    "e2r" # TODO add audio question
    "symbolset"
    "symbolsize"

    "createuser"
]

