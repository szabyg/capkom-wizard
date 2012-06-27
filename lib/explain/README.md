# Explain function

## Description
This interaction widget explains a button or function and can trigger the next step to start.

Capkom.explain
    read: "This will be read"
    show: "This will be shown. <button>Testknopf</button>"
    script: (element) ->
      jQuery(element).find('button').button();
, ->
    alert "this should be shown after reading the text."


## Dependencies
* jQuery 1.5+
* jQuery UI 1.7+

## Usage
jQuery("#play-area").sizedetect({
});

## Options
### maxSize
The maximum symbol size.

### minSize
The minimum symbol size that can be tested.


## Development
To edit the coffeescript and do instant compilation I use the following command:

    $ coffee -w -c sizedetect.coffee
