RentalCats::Application.routes.draw do

  resources :cats do
    resources :cat_rental_requests, only: [:new, :create, :index]
  end

  resources :users, only: [:new, :create, :show]

  post "/cat_rental_request/:id/approve", to: "cat_rental_requests#approve", as: "request_approve"
  post "/cat_rental_request/:id/deny", to: "cat_rental_requests#deny", as: "request_deny"

  resources :sessions

  # verb "/cats/:id/cat_rental_request/:id/deny", to: "controller#action", as: "helper"
  # get "/favorites", to: "users#favorites", as: "aslkdfjk"


end
