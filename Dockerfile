# syntax = docker/dockerfile:1.1-experimental
FROM ruby:3.3.0-alpine
MAINTAINER Ryan Lue <hello@ryanlue.com>

WORKDIR /app
COPY . /app

# All gems are pure Ruby, so no build-base.
RUN gem update bundler \
    && bundle config set without 'development' \
    && bundle install

EXPOSE 9292
CMD ["bundle", "exec", "rackup", "--server", "webrick", "--env", "production", "--host", "0.0.0.0", "--port", "9292", "config.ru"]
