Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'auth/login', to: 'authentication#login', as: :authentication

  resources :beers, only: [:index, :show]
  post 'beers/:id/set_favorite' => 'beers#set_favorite', as: :set_favorite_beer
end
