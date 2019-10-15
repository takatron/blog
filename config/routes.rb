Rails.application.routes.draw do
  # get '/posts', to: 'posts#index'
  # get '/posts/new', to: 'posts#new'
  # post '/posts', to: 'posts#create'
  # get '/posts/:id', to: 'posts#show'
  # get '/posts/:id/edit', to: 'posts#edit'
  # post '/posts', to: 'posts#update'
  resources :posts do
    resources :comments, only: [:create]
  end

  # get '/users', to: 'users#index'
  # get '/users/new', to: 'users#new'
  # post '/users/', to: 'users#create'
  # get '/users/:id', to: 'users#show'
  # get '/users/:id/edit', to: 'users#edit'
  # post '/posts', to: 'users#update'
  resources :users

  resources :categories

  resources :badges

  resources :votes, only: [:create]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy', as: :log_out
end
