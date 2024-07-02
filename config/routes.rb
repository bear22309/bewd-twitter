Rails.application.routes.draw do
  root 'homepage#index'
  get '/feeds' => 'feeds#index'

# USERS
resources :users

# SESSIONS
resources :sessions, only: [:new, :create, :destroy]

# TWEETS
resources :tweets

  # Redirect all other paths to index page, which will be taken over by AngularJS
  get '*path' => 'homepage#index'
end
