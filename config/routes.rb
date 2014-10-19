Rails.application.routes.draw do
  root 'home#index'

  get "/auth/google_oauth2/callback" => "sessions#create", as: :create_session
  delete "/logout" => "sessions#destroy", as: "logout"

  get "/profile" => "users#show", as: :profile

  resources :meetings, except: :index do
    resources :agenda_topics do
      resources :conclusions
      resources :votes, only: :create
    end

    resources :actionables do
      resources :responsibilities, except: [:edit, :update]
    end

    get "/invited" => "meetings#check_invited"
  end
  
  get "/contacts" => "meetings#contacts"

  match "/meetings/:id/update_notes" => "meetings#update_notes", as: :update_notes, via: :PATCH
end
