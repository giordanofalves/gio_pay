Rails.application.routes.draw do
  root "merchants#index"

  resources :merchants, only: [:index, :show] do
    get :chart_data, on: :member
  end
end
