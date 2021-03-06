class SessionsController < ApplicationController
  skip_before_action :require_login, only: :create
  rescue_from ActionController::InvalidAuthenticityToken, :with => :redirect_to_root

  layout false

  def destroy
    current_user.logout
    session.clear  
    redirect_to root_url
  end

  def create
    user_info = request.env["omniauth.auth"]['info']
    user_credentials = request.env["omniauth.auth"]['credentials']

    user = User.find_or_create_by(email: CanonicalEmails::GMail.transform(user_info['email']).address.downcase)
    user.update(
      image_path: user_info['image'], 
      first_name: user_info['first_name'], 
      last_name: user_info['last_name'], 
      token: user_credentials['token'], 
      refresh_token: user_credentials['refresh_token'],
      token_expires_at: user_credentials['expires_at']
      )

    session[:user_id] = user.id
    redirect_to profile_path 
  end

  private

  def redirect_to_root
    redirect_to root_path
  end
end



