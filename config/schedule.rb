# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, :development
env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']
set :output, { :error => "log/error.log", :standard => 'log/cron.log' }

every 1.day do
   runner "Task.new.get_latest"
   runner "puts 'Cron done!'"
end

every 5.minute do
   runner "puts 'Cron test!'"
end