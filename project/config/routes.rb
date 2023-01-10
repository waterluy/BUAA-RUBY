Rails.application.routes.draw do
  # resources :comments
    
  resources :collects
  resources :orders do
    collection do
      post 'change_status'
    end
  end
  resources :cart_items
  resources :carts
  resources :sizes
  resources :colors
  resources :categories
  resources :products do
    resources :comments
  end
  

  
  resources :users do
    collection do
      get 'login'
      post 'do_login'
      get 'logout'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "products#index"
end
