Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], {
    access_type: 'offline',
    prompt: 'consent',
    scope:['https://www.googleapis.com/auth/userinfo.email', 'https://www.googleapis.com/auth/contacts.readonly', 'https://www.googleapis.com/auth/calendar', 'https://www.googleapis.com/auth/userinfo.profile'],
    redirect_uri:ENV['REDIRECT_URI']
  }

  OmniAuth.config.on_failure = UsersController.action(:show)
end