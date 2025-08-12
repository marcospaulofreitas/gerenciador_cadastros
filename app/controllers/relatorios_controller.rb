class RelatoriosController < ApplicationController
  def index
    @revendas_count = Revenda.count
    @tecnicos_count = Tecnico.count
    @usuarios_count = User.count
    @audits_count = Audit.count
  end

  def export_revendas
    @revendas = Revenda.includes(:gerente_contas, :tecnicos).order(:nome_fantasia)
    
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"revendas_#{Date.current.strftime('%Y%m%d')}.csv\""
        headers['Content-Type'] = 'text/csv'
      end
    end
  end

  def export_tecnicos
    @tecnicos = Tecnico.includes(:revenda).order(:name)
    
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"tecnicos_#{Date.current.strftime('%Y%m%d')}.csv\""
        headers['Content-Type'] = 'text/csv'
      end
    end
  end

  def export_usuarios
    @usuarios = User.includes(:user_profile).order(:name)
    
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"usuarios_#{Date.current.strftime('%Y%m%d')}.csv\""
        headers['Content-Type'] = 'text/csv'
      end
    end
  end
end