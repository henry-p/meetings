desc "This task is called by the Heroku scheduler add-on"
task :update_tokens => :environment do
  puts "Updating tokens..."
  puts "done."
end