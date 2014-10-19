desc "This task is called by the Heroku scheduler add-on"
task :update_tokens => :environment do
  puts "Updating tokens..."
  User.all.each do |user|
    if user.refresh_token
      user.refresh_access_token
    end
  end
  puts "done."
end