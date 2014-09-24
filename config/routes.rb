Rails.application.routes.draw do
  get  'signup', to: 'users#new'
  get  'login',  to: 'sessions#new', as: :login
  post 'login',  to: 'sessions#create'
  get  'logout', to: 'sessions#destroy', as: :logout

  resources :stocks
  resources :users

  root 'stocks#index'
end
