# syntax = docker/dockerfile:1.1-experimental
FROM ruby:3.3.0-alpine
MAINTAINER Ryan Lue <hello@ryanlue.com>

WORKDIR /app
COPY . /app

# system libraries for nio4r
RUN apk add --no-cache --update \
    build-base \
    && gem update bundler \
    && bundle config set without 'development' \
    && bundle install

EXPOSE 9292
CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:9292", "-e", "production", "config.ru"]
