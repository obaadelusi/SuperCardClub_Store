Rails.application.routes.draw do
  get 'home/index'
  get '/pages/:slug', to: 'pages#show', as: :page_by_slug

  devise_for :customers, controllers: {
    sessions: 'customers/sessions',
    registrations: 'customers/registrations'
  }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'home#index'
  resources :pages
  resources :characters
  resources :races
  resources :alignments
  resources :publishers

  resources :orders, only: [:index, :create]
  resources :checkout, only: [:index, :create]
  scope "/checkout" do
    # get "", to: "checkout#index", as: "checkout_index"
    # post "create", to: "checkout#create", as: "checkout_create"
    get "success", to: "checkout#success", as: "checkout_success"
    get "cancel", to: "checkout#cancel", as: "checkout_cancel"
  end

  resources :cart, only: [:index, :create, :destroy]
  post '/update_cart_item', to: 'cart#update_cart_item', as: 'update_cart_item'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
