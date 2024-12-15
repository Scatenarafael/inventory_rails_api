Rails.application.routes.draw do
  resources :users, param: :_username
  resources :rooms, :sectors, :categories, :items
  post "/auth/login", to: "authentication#login"
  get "/*a", to: "application#not_found"
end
