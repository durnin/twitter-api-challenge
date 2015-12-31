# Twitter Api Challenge

Twitter Api Challenge is an application to test Api connection with Twitter for The Water Scrooge team.

It's a testing app. made on Ruby on Rails using OOP techniques, with an authentication layer, use of Twitter RESTful API and made to deploy on Heroku.

## Design

Authentication layer was made using **Devise** only with basic configuration and **confirmable** option. A **User** model was created for this purpose.
A **secrets.yml** file was used for all secret configurations and most of them where placed as environment variables.

For Twitter API consuming, the well tested **twitter gem** was used. The decision was made based on the stability on the gem and not re-inventing the wheel.
This gem was configured as a global variable initialized under rails initializers directory. Like with devise all secrets needed to connect are configured under **secrets.yml**.

A non ActiveRecord model (**TweetWrapper**) was created to centralize the API calls, handling exceptions of API calls and caching the Tweets data.

This model has 2 public methods, a class method **fetch_tweets_by_screen_name** for fetching the tweet data and an instance method **get_embed_html** to get the tweet data to print on the view.

This model also stores the tweet data and the code needed to embed the object to show it the same way as twitter does. The javascript needed for this is loaded a single time (**tweets.coffee**) on the layout (so calls to the API for oembed exclude the javascript code to optimize loading times).

Exception handling was made printing the errors to the user and also logging the error on the server (could be upgraded to log on bugsnag, sentry or another bug tracker).

Caching was made using low level Rails caching using Memory Store (could be upgraded to memcached or other) and it's configured at application level (**application.rb**), but this could be changed to environment level if needed.

A single controller and a single view were made to handle the twitter search.

A visitor controller was made for the landing page.

Views were developed using haml and basic bootstrap.

Tests were made using RSpec, Capybara and FactoryGirl. Tests for both user authentication and twitter search were made (user model and features for twitter and user authentication).

## Local environment setup

The following environment variables need to be configured in order for the application to fully work:

**MANDRILL_USERNAME**: Mandrill address for sending mail (for confirmation email).
**MANDRILL_APIKEY**: Mandrill API key for sending mail (for confirmation email).
**TWITTER_CONSUMER_KEY**: Twitter API consumer key.
**TWITTER_CONSUMER_SECRET**: Twitter API consumer secret.
**TWITTER_ACCESS_TOKEN**: Twitter API access token.
**TWITTER_ACCESS_SECRET**: Twitter API access secret.
**ADMIN_EMAIL**: Administrator's email address for signing in.
**ADMIN_PASSWORD**: Administrator's password for signing in.
**DOMAIN_NAME**: Required for sending mail. Give an app name or use a custom domain (for confirmation email).

## Deployment on Heroku

Use **app.json.example** as an example to deploy the app.

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Running tests

To run tests as noted on **secrets.yml** the following environment variables need to be configured:

**TWITTER_CONSUMER_KEY**: Twitter API consumer key.
**TWITTER_CONSUMER_SECRET**: Twitter API consumer secret.
**TWITTER_ACCESS_TOKEN**: Twitter API access token.
**TWITTER_ACCESS_SECRET**: Twitter API access secret.

To run all the tests run:

$ rspec

## Versions

This application requires:

- Ruby 2.2.2
- Rails 4.2.5
