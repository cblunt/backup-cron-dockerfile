## Check your configuration

To check your backup configuration, set your environment variables in a file `.env`, then:

    $ dk run --rm -t --env-file=.env cblunt/backup-cron backup check

## Running standalone

    $ dk run --rm -t --env-file=.env --link db:db cblunt/backup-cron backup perform -t default

## Docker Compose

    # docker-compose.yml (v1)
    backup:
      image: cblunt/backup-cron

      environment:
        - POSTGRES_DB=my-app-db
        - POSTGRES_USER=postgres
        - POSTGRES_PASSWORD=secret123

        - BACKUP_ENCRYPTION_PASSWORD=something-really-random

        - S3_ACCESS_KEY_ID=access-key-id
        - S3_SECRET_ACCESS_KEY=secret-access-key
        - S3_REGION=eu-west-1
        - S3_BUCKET_NAME=your-bucket
        - S3_PATH=my-app/db/
        - S3_KEEP_DAYS=90

        - MAIL_FROM=no-reply@your-domain.com
        - MAIL_TO=notifications@your-domain.com
        - SMTP_HOST=smtp.sendgrid.net
        - SMTP_DOMAIN=your-domain.com
        - SMTP_USERNAME=sendgrid-user
        - SMTP_PASSWORD=sendgrid-password

      volumes:
        - ./backup_models:/home/backup/Backup/models
        - ./schedule.rb:/home/backup/Backup/schedule.rb # Optional. Default is to run backup `default` at 9pm every day.

      links:
        - db

    db:
      image: postgres:latest
      environment:
        - POSTGRES_DB=my-app-db
        - POSTGRES_USER=postgres
        - POSTGRES_PASSWORD=secret123

      # ...
