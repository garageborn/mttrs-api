FROM ruby:2.3.3-slim

# install dependencies
RUN apt-get update -qq && apt-get install --fix-missing -y \
  build-essential \
  cron \
  git-core \
  libbz2-dev \
  libcurl4-openssl-dev \
  libpq-dev \
  libssl-dev \
  locales \
  nodejs \
  postgresql-common \
  zlib1g-dev

# setup locale
run echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && dpkg-reconfigure --frontend=noninteractive locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# build mttrs-api
ENV MTTRS_API /mttrs-api
RUN mkdir $MTTRS_API
COPY . $MTTRS_API
WORKDIR $MTTRS_API

RUN ./bin/bundle install --jobs 10 --without development test
