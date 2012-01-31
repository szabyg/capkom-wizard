# TTS widget

## Description
A jQuery UI widget to read text content of a UI element. The speech synthesis
happens on a [MARY](http://mary.dfki.de/) backend installation.

## Dependencies
* jQuery 1.5+
* jQuery UI 1.7+
* MARY

## Usage
$(".tts")
.ttswidget({
    language: "de",
    backendUri: "http://dev.iks-project.eu/mary",
    backendType: "MARY",
    iconUri: "./speaker.gif",
    gender: "male"
});

## Options
### language (optional)
The language for reading the text. MARY must support the language.

### backendUri (optional)
Backend base URI.

### iconClass
Defines the css class for the button icon. Default: `ui-icon-speaker`

### spinnerUri
Defines the uri to the spinner icon. Default: `css/spinner.gif`

### dialogTitle
Default: `TTS widget`

### buttonLabel
You can define the label on the widget button. Although this is hidden, it might 
be read out loud by a screen reader. Default: `Speak`

### backendType (optional)
Implemented for [MARY](http://mary.dfki.de/), but easily adaptable for other 
backends as well. Default: "MARY"

### gender
`male` or `female`.

## Development
To edit the coffeescript and do instant compilation I use the following command:

    $ coffee -w -c ttswidgecoffee

This keeps watching the file for changes and shows compilation errors as well.
