Rails.application.routes.draw do
  root to: 'pages#home'

  get '/switch_locale/:locale', to: 'application#switch_locale', as: :switch_locale

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
    get 'privacy_policy_modal', to: 'users/omniauth_callbacks#show_privacy_policy'
    post 'accept_privacy_policy', to: 'users/omniauth_callbacks#accept_privacy_policy'
  end

  namespace :admin do
    resources :users, only: %i[index edit update]
    resources :resources, only: %i[index edit update]
    resources :logs, only: [:index]
    resources :resource_types, only: [:new, :create]
  end

  get 'profile', to: 'users#show', as: 'user_profile'

  resources :users, only: %i[index show]
  
  get 'dashboards/show', to: 'dashboards#show', as: :dashboard_show
  get 'profile/edit', to: 'users#edit', as: 'edit_user_profile'
  patch 'profile', to: 'users#update', as: 'update_user_profile'

  get 'home', to: 'pages#home'
  get 'help', to: 'pages#help'
  get 'documentation', to: 'pages#documentation'

  resources :resources, only: [:index, :new, :create, :show]
  
  get 'controlpanel/home', to: 'control_panel#home', as: :control_panel_home
  get 'controlpanel/promote/:id', to: 'control_panel#promote', as: :control_panel_promote
  get 'controlpanel/demote/:id', to: 'control_panel#demote', as: :control_panel_demote
end
