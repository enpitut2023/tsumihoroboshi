# ベースイメージをRuby 3.0に設定します。
FROM ruby:3.0

# 必要なパッケージをインストールします。
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Node.jsをインストールします。
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs

# Yarnをインストールします。
RUN npm install -g yarn

# アプリケーションのディレクトリを作成します。
RUN mkdir /myapp_enpit
WORKDIR /myapp_enpit

# GemfileとGemfile.lockをコピーして、bundlerでインストールします。
COPY Gemfile /myapp_enpit/Gemfile
COPY Gemfile.lock /myapp_enpit/Gemfile.lock
RUN bundle install

# アプリケーションのソースコードをコピーします。
COPY . /myapp_enpit