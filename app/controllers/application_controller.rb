class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!, except: [:index, :revenda_login, :webposto_login, :validate_cnpj]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_authorization

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :login, :user_profile_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :login])
  end

  def after_sign_in_path_for(resource)
    if session[:revenda_id].present?
      revenda_dashboard_path
    else
      webposto_dashboard_path
    end
  end

  def current_revenda
    @current_revenda ||= Revenda.find(session[:revenda_id]) if session[:revenda_id]
  end
  helper_method :current_revenda

  private

  def check_authorization
    return unless user_signed_in?
    return if controller_name == 'home' || devise_controller?
    
    # WebPosto dashboard - apenas administradores
    if controller_name == 'dashboards' && action_name == 'webposto'
      redirect_to root_path unless current_user.administrador?
    end
    
    # Revenda dashboard - apenas com revenda na sessão
    if controller_name == 'dashboards' && action_name == 'revenda'
      redirect_to root_path unless current_revenda
    end
  end
end