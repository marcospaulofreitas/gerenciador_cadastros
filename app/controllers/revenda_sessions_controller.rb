class RevendaSessionsController < ApplicationController
  def create
    cnpj = sanitize_cnpj(params[:cnpj])
    revenda = Revenda.find_by(cnpj: cnpj)

    if revenda&.active?
      session[:access_type] = "revenda"
      session[:revenda_id] = revenda.id
      redirect_to revenda_dashboard_path
    else
      flash[:alert] = "CNPJ não encontrado ou revenda inativa."
      redirect_to root_path
    end
  end
end
