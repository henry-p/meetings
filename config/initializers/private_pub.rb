require "private_pub"

PrivatePub.config[:secret_token] = ENV['FAYE_TOKEN']
PrivatePub.config[:server] = "http://meetingappserver.herokuapp.com/faye/faye" 

if Rails.env.production?
  PrivatePub.config[:signature_expiration] = 3600
end