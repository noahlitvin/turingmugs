Rails.application.routes.draw do
  resources :connectors
  resources :logs

  root 'connectors#index'
end
