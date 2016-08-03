FROM debian:jessie

ENV RAILS_ENV $RAILS_ENV
ENV DATABASE_URL $DATABASE_URL

# install dependencies
RUN apt-get update -qq
RUN apt-get install -y build-essential patch libssl-dev libreadline-dev git-core wget curl

# postgresql
RUN apt-get install -y postgresql-common libpq-dev

# nokogiri
RUN apt-get install -y libxslt-dev libxml2-dev zlib1g-dev liblzma-dev

# ruby
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN ~/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
RUN echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN rbenv install 2.3.1
RUN rbenv global 2.3.1
RUN gem install bundler
RUN rbenv rehash

# build mttrs-api
ENV MTTRS_API /mttrs-api
RUN mkdir $MTTRS_API
COPY . $MTTRS_API
WORKDIR $MTTRS_API

# gems
RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc
RUN ./bin/bundle install --jobs 10 --deployment --without development test

RUN ./bin/rails assets:precompile
CMD ./bin/rails db:migrate && ./bin/rails s
