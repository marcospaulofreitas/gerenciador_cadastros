class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :authenticate_user_or_tecnico!, unless: :public_action?
  before_action :check_revenda_access, if: :revenda_access?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :cnpj, :access_type])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :login, :user_profile_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :login])
  end

  def after_sign_in_path_for(resource)
    if session[:access_type] == 'webposto'
      return webposto_dashboard_path
    elsif session[:access_type] == 'revenda'
      return revenda_dashboard_path
    else
      return root_path
    end
  end
  
  private
  
  def sanitize_cnpj(cnpj)
    return '' if cnpj.blank?
    cnpj.gsub(/\D/, '')
  end

  def current_revenda
    @current_revenda ||= Revenda.find(session[:revenda_id]) if session[:revenda_id]
  end
  helper_method :current_revenda
  
  def current_tecnico
    @current_tecnico ||= Tecnico.find(session[:tecnico_id]) if session[:tecnico_id]
  end
  helper_method :current_tecnico

  private

  def public_action?
    devise_controller? || (controller_name == 'home' && action_name == 'index') || (controller_name == 'home' && action_name == 'validate_cnpj_name') || revenda_access?
  end
  
  def revenda_access?
    session[:access_type] == 'revenda' && session[:tecnico_id].present?
  end
  
  def check_revenda_access
    redirect_to root_path unless session[:tecnico_id].present?
  end
  
  def authenticate_user_or_tecnico!
    return if revenda_access? # Já autenticado como técnico
    return if user_signed_in?  # Já autenticado como usuário
    
    # Redirecionar para tela inicial se não autenticado
    redirect_to root_path, alert: 'Para continuar, efetue login.'
  end
  
  def authenticate_user!
    redirect_to root_path, alert: 'Para continuar, efetue login.' unless user_signed_in?
  end
end