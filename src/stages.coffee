Capkom = window.Capkom ?= {}

Capkom.stages =
    "welcome":
        title: "Capkom Profilerstellung Wizard"
        image: "symbols/ueberMich.gif"
        html: 
            """
                Willkommen zum CapKom Kunstportal!<br/>
                [Beschreibung der nächsten Schritte...]
            """
        route: ""

    "createuser":
        title: "Benutzer anlegen"
        html: """
            Benutzername: <input id=''/>
        """

    "fontsize":
        title: "Schriftgröße"
        image: "fontsize.gif"
        html:
            """
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
        title: "Theme"
        html: """
            <div id='themeselector'></div>
        """
        script: (element) ->
            jQuery("#themeselector", element)
            .themeswitcher
                width: 300
                onSelect: (theme) ->
                    console.info "selected theme", theme, arguments, @

    "symbolsize":
        title: "sdfg"
        html: """
            Symbolsize
        """

    "e2r":
        title: "EasyToRead"
        html: """
            Not yet implemented...
        """

    "symbolset":
        title: "Symolsatz"
        html: """
            Not yet implemented...
        """

Capkom.order = [
    "welcome"
    "fontsize"
    "createuser"
    "theme"
    "symbolsize"
    "e2r"
    "symbolset"
]

