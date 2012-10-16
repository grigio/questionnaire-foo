# Questionnaire Foo

_Questionnaire Foo_ is a simple WYSIWYG survey system for hackers which save the schema and the results as plain prettified JSON. It use Sinatra, Backbone, Coffeescript and Twitter Bootstrap


## Installation

```
bundle install
cp .env.example .env # customize as you like it
foreman start
# rackup is an alternative server start but it doesn't support Sinatra reloading
```

## Setup and customization

If You want You can override some variables
You need initialize some variables in the file .env

```
ruby -e 'require "bcrypt"; puts BCrypt::Password.create("Insert password and get crypted passwd with salt")'
$2a$10$OF/0CvbM6FV2.86wui3cKO1JrtzzF.JPxMxCsCFThDFsCDdBdtISy
```

## Credits

* Luigi Maselli (http://grigio.org)
* Sarah Pinder (https://github.com/rspinder/questionnaire)

## LICENSE

AS-IS