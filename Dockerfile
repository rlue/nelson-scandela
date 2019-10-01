FROM ruby:2.7-rc-alpine
MAINTAINER Ryan Lue <hello@ryanlue.com>

WORKDIR /app
COPY . /app

RUN bundle install

EXPOSE 4567
CMD ["ruby", "app.rb"]
