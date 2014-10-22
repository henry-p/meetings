Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  root 'home#index'

  get "/auth/google_oauth2/callback" => "sessions#create", as: :create_session
  delete "/logout" => "sessions#destroy", as: "logout"

  get "/profile" => "users#show", as: :profile
  get "/profile/contacts" => "users#contacts"
  get "/profile/archive" => "users#archive"

  get "/contacts/start_job" => "users#init_contacts_load"
  get "/contacts/job_status" => "users#check_on_contacts_loading"

  resources :meetings, except: :index do
    resources :invites, only: :destroy
    resources :agenda_topics do
      resources :conclusions
      resources :votes, only: :create
    end

    resources :actionables do
      resources :responsibilities, except: [:edit, :update]
    end

    get "/invited" => "meetings#check_invited"
    get "/attendees" => "meetings#attendees"
  end

  match "/meetings/:id/update_notes" => "meetings#update_notes", as: :update_notes, via: :PATCH

  match ':not_found' => 'home#index', :constraints => { :not_found => /.*/ }, via: [:get, :post]
end