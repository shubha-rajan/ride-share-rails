Rails.application.routes.draw do
  root "homepages#index"

  resources :trips, except: [:index]

  resources :drivers do
    resources :trips, only: [:index]
  end
  post '/drivers/:id/change_availability', to: 'drivers#change_availability', as: "change_availability_driver"

  resources :passengers do
    resources :trips, only: [:index, :create]
  end
end
