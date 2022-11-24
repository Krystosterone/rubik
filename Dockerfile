FROM ruby:3.1.2

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

RUN apt-get install -y poppler-utils

RUN mkdir /rubik

WORKDIR /rubik

COPY Gemfile /rubik/Gemfile
COPY Gemfile.lock /rubik/Gemfile.lock
RUN bundle install

COPY package.json /rubik/package.json
RUN yarn install --ignore-engines

COPY . /rubik

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "-C", "config/puma.rb"]
