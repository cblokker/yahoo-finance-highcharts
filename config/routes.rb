Rails.application.routes.draw do
  get 'preview', to: 'stocks#index'
  resources :stocks

  root 'stocks#index'
end
