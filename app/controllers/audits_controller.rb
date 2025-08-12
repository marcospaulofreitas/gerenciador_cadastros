class AuditsController < ApplicationController
  before_action :ensure_webposto_user

  def index
    @audits = Audit.includes(:user, :tecnico, :auditable)
                   .pendentes
                   .by_tecnicos
                   .recent
                   .limit(50)
  end

  def approve
    @audit = Audit.find(params[:id])

    if @audit.feito_por_tecnico? && @audit.pendente?
      @audit.aprovar!
      flash[:notice] = "Alteração aprovada com sucesso!"
    else
      flash[:alert] = "Não é possível aprovar esta alteração."
    end

    redirect_back(fallback_location: audits_path)
  end

  def approve_all
    count = Audit.pendentes.by_tecnicos.update_all(aprovado: true)
    flash[:notice] = "#{count} alterações aprovadas com sucesso!"
    redirect_to audits_path
  end

  private

  def ensure_webposto_user
    unless user_signed_in? && session[:access_type] == "webposto"
      redirect_to root_path, alert: "Acesso negado."
    end
  end
end
