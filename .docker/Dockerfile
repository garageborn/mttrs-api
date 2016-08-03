FROM ruby:2.3.1

ENV RAILS_ENV $RAILS_ENV
ENV DATABASE_URL $DATABASE_URL

# install dependencies
RUN apt-get update -qq
RUN apt-get install -y build-essential wget curl

# postgresql
RUN apt-get install -y postgresql-common libpq-dev

# nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# build mttrs-api
ENV MTTRS_API /mttrs-api
RUN mkdir $MTTRS_API
COPY . $MTTRS_API
WORKDIR $MTTRS_API

RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
RUN gem install bundler
RUN bundle install --jobs 10 --deployment --quiet --without development test

RUN bundle exec rails assets:precompile
CMD bundle exec rails db:migrate && bundle exec rails s
