# config/routes.rb
Rails.application.routes.draw do
  root 'homepage#index'
  get '/feeds' => 'feeds#index'

  # USERS
  resources :users, only: [:create, :show]

  # SESSIONS
  resources :sessions, only: [:create, :destroy]
  get '/authenticated', to: 'sessions#authenticated'
  delete '/sessions', to: 'sessions#destroy'  # Added to define DELETE /sessions

  # TWEETS
  resources :tweets, only: [:create, :index, :show, :destroy]
  get '/users/:username/tweets', to: 'tweets#index_by_user'

  # Redirect all other paths to index page, which will be taken over by AngularJS
  get '*path' => 'homepage#index'
end

