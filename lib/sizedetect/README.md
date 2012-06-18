# Size detect widget

## Description
This widget is a play for detecting the ideal symbol size for a person. It measures coordination skills of clicking
on a symbol. The symbol size is big in the beginning and becomes smaller and smaller after each level. The sizes depend
on the screen size and the speed of the player. The game begins with a size that's at least `maxSize` specified in
the options and ends at the latest when the measured symbol size became smaller then the `minSize`.

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
