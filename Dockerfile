FROM cblunt/alpine-linux-ruby:2.3.1

# Set timezone
RUN apk add --update tzdata && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

# Packages for the application and gems
RUN apk --update add postgresql-client ruby-dev vim postgresql-client

ADD Gemfile .
ADD Gemfile.lock .

# Install gems
RUN apk add --virtual build-dependencies build-base libxml2-dev libxslt-dev \
      &&  bundle config build.nokogiri --use-system-libraries \
      &&  bundle install --jobs=4 \
      &&  apk del build-dependencies

RUN adduser -S backup
USER backup

RUN mkdir -p /home/backup/Backup
WORKDIR /home/backup/Backup

COPY config.rb .

VOLUME ['/home/backup/Backup/models']

ENTRYPOINT '/usr/local/bundle/bin/backup'
