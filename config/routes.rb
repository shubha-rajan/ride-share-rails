Rails.application.routes.draw do
  root "homepages#index"

  resources :trips, except: [:index]

  resources :drivers do
    resources :trips, only: [:index]
  end

  resources :passengers do
    resources :trips, only: [:index, :create]
  end
end
