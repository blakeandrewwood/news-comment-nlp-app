# News Comment NLP App

This application is a prototype of a web app that contains a smart discussion form.

## Key Features

- Live updates

- NLP topic processing

- Provieds related news based on discussion

The application utilizes Phoenix channels to provide live comment updates.

As the discussion grows on the page, we use NLP API from Aylien to process
comments and pickup on what is being discussed.

As topics grow, we then query Bing news API for related articles and display
above the discussion.

## Requirements

- Elixir v1.5.2
- Phoenix v1.3.0
- PostgresSQL

## Running

`mix deps.get`

`mix ecto.create`

`mix ecto.migrate`

`mix run priv/repo/seeds.exs`

`mix phx.server`

Go to `localhost:4000`

## Live updating

If you open up several windows, and create a comment, you can experience live
updates as comments are published.

## Resouces

http://phoenixframework.org/

https://aylien.com/text-api/

https://azure.microsoft.com/en-us/services/cognitive-services/bing-news-search-api/