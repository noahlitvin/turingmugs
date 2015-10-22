Rails.application.routes.draw do
  resources :connectors
  resources :logs

  root 'connectors#index'
  post '/inbound', to: 'connectors#inbound'

end