Rails.application.routes.draw do
  root to: 'dashboards#show'

  

  get '/switch_locale/:locale', to: 'application#switch_locale', as: :switch_locale

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end

  get 'profile', to: 'users#show', as: 'user_profile'

  resources :users, only: [:index, :show]
end
