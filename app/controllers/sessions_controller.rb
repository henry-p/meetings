class SessionsController < ApplicationController
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
    user.update(image_path: user_info['image'], first_name: user_info['first_name'], last_name: user_info['last_name'])

    session[:user_id] = user.id
    session[:token] = user_credentials['token']

    redirect_to profile_path
  end
end
