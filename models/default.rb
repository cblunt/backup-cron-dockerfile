# encoding: utf-8

Backup::Model.new(:default, 'Backup the application database') do
  database PostgreSQL do |db|
    db.name = ENV['POSTGRES_DB']
    db.username = ENV['POSTGRES_USER']
    db.password = ENV['POSTGRES_PASSWORD']
    db.host = 'db'
    # db.port = ENV['POSTGRES_PORT']
  end

  compress_with Gzip

  encrypt_with OpenSSL do |encryption|
    encryption.password = ENV['BACKUP_ENCRYPTION_PASSWORD']
    encryption.base64 = true
    encryption.salt = true
  end

  store_with S3 do |s3|
    s3.access_key_id      = ENV['S3_ACCESS_KEY_ID']
    s3.secret_access_key  = ENV['S3_SECRET_ACCESS_KEY']
    s3.region             = ENV['S3_REGION']
    s3.bucket             = ENV['S3_BUCKET_NAME']
    s3.path               = ENV['S3_PATH']
    s3.keep               = ENV['S3_KEEP_DAYS']
  end

  # notify_by Slack do |slack|
  #   slack.on_success = true
  #   slack.on_warning = true
  #   slack.on_failure = true

    # The incoming webhook url
    # https://hooks.slack.com/services/xxxxxxxx/xxxxxxxxx/xxxxxxxxxx
    # slack.webhook_url = 'https://hooks.slack.com/services/xxxxxxxx/xxxxxxxxx/xxxxxxxxxx'

    ##
    # Optional
    #
    # The channel to which messages will be sent
    # slack.channel = 'notifications'
    #
    # The username to display along with the notification
    # slack.username = 'my_username'
  # end

  notify_by Mail do |mail|
    mail.on_success           = false
    mail.on_warning           = true
    mail.on_failure           = true

    mail.from                 = ENV['MAIL_FROM']
    mail.to                   = ENV['MAIL_TO']
    mail.address              = ENV['SMTP_HOST']
    mail.port                 = 587
    mail.domain               = ENV['SMTP_DOMAIN']
    mail.user_name            = ENV['SMTP_USERNAME']
    mail.password             = ENV['SMTP_PASSWORD']
    mail.authentication       = 'plain'
    mail.encryption           = :starttls
   end
 end
