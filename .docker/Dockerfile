# FROM ruby:2.3.1
FROM ubuntu:16.04

# install dependencies
RUN apt-get update -qq
RUN apt-get install -y build-essential wget curl
RUN apt-get install -y ruby ruby-dev ruby-bundler

# postgresql setup
RUN sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
RUN wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
RUN apt-get install -y postgresql-common libpq-dev

# build api
ENV MTTRS_API /mttrs-api
RUN mkdir $MTTRS_API
COPY . $MTTRS_API
WORKDIR $MTTRS_API
RUN gem install bundler
RUN bundle install --jobs 10 --deployment --quiet --without development test

# # EXPOSE 80
# # EXPOSE 443

# # CMD nginx -g "daemon off;"
CMD bundle exec rails s
