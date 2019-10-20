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

  resources :users

  resources :categories

  resources :badges

  resources :votes, only: [:create]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy', as: :log_out

  root 'posts#index', page: 1
end
