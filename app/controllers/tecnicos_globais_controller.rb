class TecnicosGlobaisController < ApplicationController
  before_action :set_tecnico, only: [:toggle_status]
  
  def index
    @tecnicos = filter_tecnicos
    @revendas = Revenda.active.order(:nome_fantasia)
    
    if request.xhr?
      render partial: 'table', locals: { tecnicos: @tecnicos }, layout: false
    end
  end

  def toggle_status
    new_status = !@tecnico.active
    @tecnico.update_column(:active, new_status)
    
    message = new_status ? 'Técnico ativado com sucesso.' : 'Técnico desativado com sucesso.'
    
    respond_to do |format|
      format.html { redirect_to tecnicos_globais_path, notice: message }
      format.json { render json: { success: true, message: message } }
    end
  end

  private

  def set_tecnico
    @tecnico = Tecnico.find(params[:id])
  end

  def filter_tecnicos
    tecnicos = Tecnico.includes(:revenda)
    
    # Filtro por status
    case params[:status]
    when 'ativos'
      tecnicos = tecnicos.where(active: true)
    when 'inativos'
      tecnicos = tecnicos.where(active: false)
    else
      tecnicos = tecnicos # todos
    end
    
    # Filtro por revenda
    if params[:revenda].present?
      tecnicos = tecnicos.where(revenda_id: params[:revenda])
    end
    
    # Filtro por busca (nome ou email)
    if params[:search].present?
      search_term = params[:search].strip
      tecnicos = tecnicos.where("LOWER(name) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?)", 
                               "%#{search_term}%", "%#{search_term}%")
    end
    
    tecnicos.order(:name)
  end
end