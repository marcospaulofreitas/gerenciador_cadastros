Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "devise/sessions" }, path: "webposto", path_names: {
    sign_in: "login",
    sign_out: "logout"
  }

  devise_for :tecnicos, controllers: { sessions: "devise/tecnicos/sessions" }, path: "revenda", path_names: {
    sign_in: "login",
    sign_out: "logout"
  }

  root "home#index"

  # Rotas da tela inicial - redirecionamentos
  get "revenda_login", to: redirect("/revenda/login")
  get "webposto_login", to: redirect("/webposto/login")
  post "validate_cnpj", to: "home#validate_cnpj"
  post "validate_cnpj_name", to: "home#validate_cnpj_name"

  # Dashboards
  get "revenda_dashboard", to: "dashboards#revenda"
  get "webposto_dashboard", to: "dashboards#webposto"

  # Recursos para WebPosto
  resources :revendas do
    member do
      patch :toggle_status
    end
    resources :tecnicos do
      member do
        patch :toggle_status
      end
    end
  end
  resources :users, except: [ :show ]
  resources :user_profiles, only: [ :index ]
  resources :tecnicos_globais, path: "tecnicos", only: [ :index ] do
    member do
      patch :toggle_status
    end
  end
  resources :relatorios, only: [ :index ] do
    collection do
      get :export_revendas
      get :export_tecnicos
      get :export_usuarios
    end
  end
  resources :audits, only: [ :index ] do
    member do
      patch :approve
    end
    collection do
      patch :approve_all
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
