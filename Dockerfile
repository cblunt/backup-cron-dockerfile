FROM cblunt/alpine-linux-ruby:2.3.1

# Set timezone
RUN apk add --update tzdata && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

# Get the latest Postgres client
RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    apk --update add "postgresql@edge<9.6" "postgresql-contrib@edge<9.6" ruby-dev tar

ADD Gemfile .
ADD Gemfile.lock .

# Install gems
RUN apk add --virtual build-dependencies build-base libxml2-dev libxslt-dev \
      &&  bundle config build.nokogiri --use-system-libraries \
      &&  bundle install --jobs=4

RUN adduser -S backup
USER backup

RUN mkdir -p /home/backup/Backup
WORKDIR /home/backup/Backup

COPY config.rb .
COPY schedule.rb .

ADD models/default.rb /home/backup/Backup/models/default.rb

VOLUME ['/home/backup/Backup/models']

CMD '/usr/local/bin/backup'
