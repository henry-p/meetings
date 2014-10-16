Rails.application.routes.draw do

  root 'home#index'
  get "/auth/google_oauth2/callback" => "sessions#create"
  resources :sessions, only: :destroy

  get "/profile" => "users#show", as: :profile

  resources :meetings do
    resources :agenda_topics do
      resources :conclusions
      resources :votes, only: :create
    end

    resources :actionables do
      resources :responsibilities, except: [:edit, :update]
    end
  end
end
