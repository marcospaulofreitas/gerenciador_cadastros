class DashboardsController < ApplicationController
  def revenda
    redirect_to root_path unless current_revenda
    @revenda = current_revenda
    @tecnicos = @revenda.tecnicos.active
  end

  def webposto
    redirect_to root_path if current_revenda
    @revendas_count = Revenda.active.count
    @tecnicos_count = Tecnico.active.count
    @users_count = User.active.count
  end
end