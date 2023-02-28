FROM ruby:2.7.6

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get update && apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

RUN apt-get install -y poppler-utils

ENV RAILS_ENV="production"
ENV NODE_ENV="production"

RUN mkdir -p /var/www/app

WORKDIR /var/www/app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --jobs 4 --retry 5 --without development test

COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn install --production --frozen-lockfile

COPY . .

RUN export $(grep -v '^#' .env | xargs -d '\n') && \
    SECRET_KEY_BASE=placeholder rails assets:precompile

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "-C", "config/puma.rb"]
