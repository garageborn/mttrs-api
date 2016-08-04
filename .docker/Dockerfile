FROM ruby:2.3.1-slim

ENV RAILS_ENV $RAILS_ENV
ENV DATABASE_URL $DATABASE_URL

# install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  git-core \
  postgresql-common \
  libpq-dev

# build mttrs-api
ENV MTTRS_API /mttrs-api
RUN mkdir $MTTRS_API
# COPY . $MTTRS_API
RUN git clone -b master git@github.com:garageborn/mttrs-api.git $MTTRS_API

WORKDIR $MTTRS_API

RUN ./bin/bundle install --jobs 10 --without development test
# RUN ./bin/rails assets:precompile
# CMD ./bin/rails db:migrate && ./bin/rails s
