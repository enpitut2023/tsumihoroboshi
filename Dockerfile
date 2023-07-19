FROM ruby:3.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm

RUN npm install -g yarn

RUN mkdir /myapp_enpit

WORKDIR /myapp_enpit

COPY Gemfile /myapp_enpit/Gemfile
COPY Gemfile.lock /myapp_enpit/Gemfile.lock

RUN bundle install

COPY . /myapp_enpit