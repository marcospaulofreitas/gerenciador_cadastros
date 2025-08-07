class DashboardsController < ApplicationController
  skip_before_action :authenticate_user_or_tecnico!, only: [:revenda]
  
  def revenda
    # Debug da sessão
    Rails.logger.info "=== DEBUG DASHBOARD REVENDA ==="
    Rails.logger.info "Access type: #{session[:access_type]}"
    Rails.logger.info "Tecnico ID: #{session[:tecnico_id]}"
    Rails.logger.info "Revenda ID: #{session[:revenda_id]}"
    Rails.logger.info "Tecnico signed in: #{tecnico_signed_in?}"
    
    unless session[:access_type] == 'revenda' && (session[:tecnico_id].present? || tecnico_signed_in?)
      Rails.logger.info "Redirecionando para root - sessão inválida"
      redirect_to root_path
      return
    end
    
    @tecnico = current_tecnico
    @revenda = current_revenda
    @tecnicos = @revenda.tecnicos.active if @revenda
  end

  def webposto
    unless session[:access_type] == 'webposto' && user_signed_in?
      redirect_to root_path
      return
    end
    
    @user = current_user
  end
end