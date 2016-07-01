set :output, '/var/log/cron.log'

# Inherit all ENV variables
ENV.each { |k, v| env(k, v) }

set :job_template, nil

job_type :backup, 'cd /root/Backup && backup perform --trigger :task :output'

every 1.day, at: '9:00pm' do
  backup 'default'
end
