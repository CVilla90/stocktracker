# Rails\portfolio\config\routes.rb

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :investment_portfolios, only: [:index, :show, :create, :destroy] do
      get 'profit', on: :member, to: 'investment_portfolios#profit'
    end

    resources :stocks, only: [:index, :show, :create]
  end
end
