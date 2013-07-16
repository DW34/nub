# Nub

The nub of an idea. This is a Rails app that we can clone when we want to do a hack. It includes the stuff we pretty much always seem to need so that we can cut down on boilerplate stuff and get to the core of the hack quicker.

## Models

* Person - the "user", but we like to call them people
* PersonMeta - some basic recording of visitor metadata
* Identity - a method the person uses to authenticate (they could have more than one)
* Role - what they're allowed to do

## Things we use

* Devise + Omniauth/Twitter for auth
* Cancan + Rolify for permissions
* Compass + Susy + Makeshift baseline SASS for styles
* Resque for background jobs
* Memcache + Dalli for caching
* Mandrill for transactional emails

## Analytics + third party APIs

* Intercom for speaking to users
* Mixpanel
* Google Analytics

# Setup

* Clone this repo.
* Create a new postgres database - `createdb some_app_development --user postgres`
* Create a database YAML file - copy config/database.yml.example
* Create a .env file based on .env.example
* Add a Twitter app on http://dev.twitter.com and put the credentials in .env
* Start the app with `foreman start -f Procfile.dev`
