FROM ruby:2.3.1

# ARG RAILS_ENV=production
# ARG DATABASE_URL

ENV RAILS_ENV $RAILS_ENV
ENV DATABASE_URL $DATABASE_URL

# install dependencies
RUN apt-get update -qq
RUN apt-get install -y build-essential wget curl ruby postgresql-common libpq-dev

# build mttrs-api
ENV MTTRS_API /mttrs-api
RUN mkdir $MTTRS_API
COPY . $MTTRS_API
WORKDIR $MTTRS_API

RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
RUN gem install bundler
RUN bundle install --jobs 10 --deployment --quiet --without development test

CMD bundle exec rake db:migrate && bundle exec rails s
