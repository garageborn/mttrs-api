# FROM ruby:2.3.1
FROM ubuntu:16.04

RUN apt-get update -qq
RUN apt-get install -y build-essential
RUN apt-get install -y ruby ruby-dev ruby-bundler

# build api
ENV MTTRS_API /mttrs-api
RUN mkdir $MTTRS_API
COPY ../ $MTTRS_API
WORKDIR $MTTRS_API
RUN bundle install --jobs 10 --deployment --quiet --without development test

# EXPOSE 80
# EXPOSE 443

# CMD nginx -g "daemon off;"
CMD bundle exec rails s
