Rails.application.routes.draw do
  resources :posts do
    resources :comments, only: [:create]
  end

  resources :users

  resources :categories

  resources :badges

  resources :votes, only: [:create]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy', as: :log_out
  post '/api/posts', to: 'posts#create_from_api'
  get '/gists', to: 'gists#index'
  post '/gists', to: 'gists#search'

  root 'posts#index', page: 1

end
