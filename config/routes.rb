Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  # Rotas da tela inicial
  get 'revenda_login', to: 'home#revenda_login'
  get 'webposto_login', to: 'home#webposto_login'
  post 'validate_cnpj', to: 'home#validate_cnpj'

  # Dashboards
  get 'revenda_dashboard', to: 'dashboards#revenda'
  get 'webposto_dashboard', to: 'dashboards#webposto'

  # Recursos para WebPosto
  resources :revendas do
    resources :tecnicos, except: [:show]
  end
  resources :users, except: [:show]
  resources :user_profiles, only: [:index]

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
