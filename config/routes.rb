Rails.application.routes.draw do
  root "homepages#index"

  resources :trips
  resources :drivers
  resources :passengers
end
