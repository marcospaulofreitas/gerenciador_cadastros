class DashboardsController < ApplicationController
  skip_before_action :authenticate_user_or_tecnico!, only: [:revenda]
  
  def webposto
    unless session[:access_type] == 'webposto' && user_signed_in?
      redirect_to root_path
      return
    end
    
    @user = current_user
    @revendas_count = Revenda.where(active: true).count
    @tecnicos_count = Tecnico.where(active: true).count
    @users_count = User.where(active: true).count
    @pendencias_count = Audit.pendentes.by_tecnicos.count
    @audits = filter_audits
    @recent_audits = @audits&.limit(10) || []
  end
  
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
  
  private
  
  def filter_audits
    audits = Audit.includes(:user, :tecnico, :auditable).recent
    
    audits = audits.where(user_id: params[:user_id]) if params[:user_id].present?
    audits = audits.where(auditable_type: params[:auditable_type]) if params[:auditable_type].present?
    audits = audits.where(action: params[:action]) if params[:action].present?
    
    if params[:date_from].present?
      audits = audits.where('created_at >= ?', Date.parse(params[:date_from]).beginning_of_day)
    end
    
    if params[:date_to].present?
      audits = audits.where('created_at <= ?', Date.parse(params[:date_to]).end_of_day)
    end
    
    audits
  end
end