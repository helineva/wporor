Rails.application.routes.draw do
  resources :memberships
  resources :beerclubs
  resources :users do
    post 'toggle_state', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'breweries#index'
  resources :ratings, only: [:index, :new, :create, :destroy]
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]
  post 'places', to:'places#search'
  resources :styles
  get 'beerlist', to:'beers#list'
  get 'brewerylist', to:'breweries#list'
end
