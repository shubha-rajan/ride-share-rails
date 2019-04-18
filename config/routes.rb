Rails.application.routes.draw do
  root "homepages#index"

  resources :trips

  resources :drivers do
    resources :trips, only: [:index]
  end

  resources :passengers do
    resources :trips, only: [:index, :create]
  end
end
