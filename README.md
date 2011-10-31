# CapKom Wizard 
A tool for creating a user profile for a platform for users with cognitive disabilities.

## Goals
* The wizard is made to be the profile creating "entry test" for a community portal for art enabling collaboration for people with cognitive difficulties.


## Dependencies
* jQuery + jQuery UI 1.9m5 - Basic UI widget set providing in-browser Accessibility, Themeability and Usability.
* Backbone.js - A model-view-controller framework for the client-side.
* Underscore.js - Javascript 1.9 added functionalities in older browsers.

## Development
Run the following command to keep compiling the coffeescript into javascript. It needs coffeescript installed to run.
coffee -c -w -o lib src/*.coffee

To generate documentation automatically run the following command. It needs docco installed.
docco src/*.coffee

## Documentation
Install and run docco for compiling the documentation like this:
docco src/*.coffee

## License
CapKom Wizard is free software under the MIT License.

## Copyright
Author(s): Szaby Grünwald, Salzburg Research
Developed for the [CapKom Project](http://cap-kom.utilo.eu/)
