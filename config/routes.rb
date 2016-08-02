Rails.application.routes.draw do
  devise_for :users
  resources :events

  root 'events#index'

  namespace :api, defaults: {format: :json} do 
    scope module: :v1 do
      resources :events, only: [:index, :show, :update, :create, :destroy]
    end
  end
end
