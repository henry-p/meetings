class SessionsController < ApplicationController
  skip_before_action :require_login, only: :create

  layout false

  def new
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  def create
    user_info = request.env["omniauth.auth"]['info']
    user_credentials = request.env["omniauth.auth"]['credentials']
    user = User.find_or_create_by(email: user_info['email'])
    user.update(image_path: user_info['image'], first_name: user_info['first_name'], last_name: user_info['last_name'], token: user_credentials['token'])

    client = OAuth2::Client.new(ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], :site => 'https://www.google.com')
    token = OAuth2::AccessToken.new(client, user_credentials['token'])

    user.load_contacts

    google_contacts_user = GoogleContactsApi::User.new(token)
    puts google_contacts_user.contacts.first

    # google_contacts_user.contacts.first.family_name LAST NAME
    # google_contacts_user.contacts.first.given_name FIRST NAME

    # google_contacts_user.contacts.first.full_name
    # google_contacts_user.contacts.first.pirmary_email
  

    session[:user_id] = user.id

    redirect_to profile_path
  end
end
