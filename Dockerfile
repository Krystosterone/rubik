FROM ruby:2.7.6

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install -y nodejs yarn

RUN curl --output /usr/local/bin/phantomjs https://s3.amazonaws.com/circle-downloads/phantomjs-2.1.1
RUN chmod 755 /usr/local/bin/phantomjs

RUN mkdir /rubik
WORKDIR /rubik

COPY Gemfile /rubik/Gemfile
COPY Gemfile.lock /rubik/Gemfile.lock
RUN bundle install --jobs 5

COPY package.json /rubik/package.json
COPY yarn.lock /rubik/yarn.lock
RUN yarn install --ignore-engines

COPY . /rubik
