class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!, unless: :devise_controller_or_home?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :login, :user_profile_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :login])
  end

  def after_sign_in_path_for(resource)
    # Limpa tipo de acesso anterior
    if params[:access_type] == 'webposto'
      session[:access_type] = 'webposto'
      session[:revenda_id] = nil
    end
    
    if session[:revenda_id].present? && session[:access_type] == 'revenda'
      revenda_dashboard_path
    elsif session[:access_type] == 'webposto'
      webposto_dashboard_path
    else
      root_path
    end
  end

  def current_revenda
    @current_revenda ||= Revenda.find(session[:revenda_id]) if session[:revenda_id]
  end
  helper_method :current_revenda

  private

  def devise_controller_or_home?
    devise_controller? || controller_name == 'home'
  end
end