Rails.application.routes.draw do
  resources :beers
  resources :breweries
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'breweries#index'
  resources :ratings, only: [:index, :new, :create, :destroy]
end
