Rails.application.routes.draw do
  root 'sessions#new'
  get "/auth/google_oauth2/callback" => "sessions#create"
end
