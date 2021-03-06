# CapKom Wizard 
A tool for creating a user profile for a platform for users with cognitive disabilities.

## Goals
* The wizard is made to be the profile creating "entry test" for a community portal for art enabling collaboration for
people with cognitive difficulties.

## URI parameters
* `returnuri` defines that in the last step (goodbye), if the profile is complete, the browser redirects to the given uri.
* `saveprofileuri` URI param to set JSONP endpoint for saving the profile.
* `hidestages` as an URL parameter. Loading the page with `?hidestages=theme,read` loads the wizard without the named stages.

## Dependencies
* jQuery + jQuery UI 1.9m5 - Basic UI widget set providing in-browser Accessibility, Themeability and Usability.
* Backbone.js - A model-view-controller framework for the client-side.
* Underscore.js - Javascript 1.9 added functionalities in older browsers.
* Using Font Awesome - http://fortawesome.github.com/Font-Awesome

## Development
Run the following command to keep compiling the coffeescript into javascript. It needs coffeescript installed to run.

    cake watch


## Documentation
To generate documentation automatically run the following command. It needs docco installed.

    docco src/*.coffee lib/ttswidget/ttswidget.coffee lib/capkomsymbolwidget/capkomsymbolwidget.coffee

## License
CapKom Wizard is free software under the MIT License.

## Copyright
Author(s): Szaby Grünwald, Salzburg Research
Developed for the [CapKom Project](http://cap-kom.utilo.eu/)
The Capkom Symbolset under /symbols/capkom is owned by [Utilo KG](http://www.utilo.eu/) and not freely usable.
