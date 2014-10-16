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

    user.load_contacts

    session[:user_id] = user.id

    redirect_to profile_path
  end
end
