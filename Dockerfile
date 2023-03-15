FROM ruby:2.7.6

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y \
        nodejs \
        poppler-utils \
        yarn

RUN mkdir -p /var/www/app

WORKDIR /var/www/app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 4 --retry 5

COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn install

COPY . .

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]