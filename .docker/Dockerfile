FROM ruby:2.3.1

ENV RAILS_ENV $RAILS_ENV
ENV DATABASE_URL $DATABASE_URL

# install dependencies
RUN apt-get update -qq
RUN apt-get install -y build-essential patch wget curl

# postgresql
RUN apt-get install -y postgresql-common libpq-dev

# nokogiri
RUN apt-get install -y libxslt-dev libxml2-dev zlib1g-dev liblzma-dev

# build mttrs-api
ENV MTTRS_API /mttrs-api
RUN mkdir $MTTRS_API
COPY . $MTTRS_API
WORKDIR $MTTRS_API

# gems
RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
RUN ./bin/bundle install --jobs 10 --deployment --without development test

RUN RAILS_ENV=$RAILS_ENV ./bin/rails assets:precompile
CMD ./bin/rails db:migrate && ./bin/rails s
