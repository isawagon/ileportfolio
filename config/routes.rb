Rails.application.routes.draw do
  devise_for :users
  root          to: "pages#home"
  get "about",  to: "pages#about", as: :about

  resources :portfolios, only: %i[new create index] do
    resources :coins, only: %i[new create show]
    resources :transactions, only: %i[new create index]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
