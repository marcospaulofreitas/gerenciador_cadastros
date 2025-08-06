class TecnicosController < ApplicationController
  before_action :set_revenda
  before_action :set_tecnico, only: [:edit, :update, :destroy]

  def index
    @tecnicos = @revenda.tecnicos.active.order(:name)
  end

  def new
    @tecnico = @revenda.tecnicos.build
  end

  def create
    @tecnico = @revenda.tecnicos.build(tecnico_params)
    
    if @tecnico.save
      redirect_to revenda_tecnicos_path(@revenda), notice: 'Técnico criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tecnico.update(tecnico_params)
      redirect_to revenda_tecnicos_path(@revenda), notice: 'Técnico atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @tecnico.update(active: false)
    redirect_to revenda_tecnicos_path(@revenda), notice: 'Técnico desativado com sucesso.'
  end

  private

  def set_revenda
    @revenda = Revenda.find(params[:revenda_id])
  end

  def set_tecnico
    @tecnico = @revenda.tecnicos.find(params[:id])
  end

  def tecnico_params
    params.require(:tecnico).permit(:name, :email, :telefone, :funcao, :especialista,
                                   :perfil_acesso, :username, :password, :password_confirmation)
  end
end