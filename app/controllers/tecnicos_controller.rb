class TecnicosController < ApplicationController
  before_action :set_revenda
  before_action :set_tecnico, only: [:show, :edit, :update, :destroy]
  before_action :check_admin_access, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @tecnicos = @revenda.tecnicos.active
  end

  def show
  end

  def show
  end

  def new
    @tecnico = @revenda.tecnicos.build
  end

  def create
    @tecnico = @revenda.tecnicos.build(tecnico_params)
    
    if @tecnico.save
      redirect_to revenda_tecnico_path(@revenda, @tecnico), notice: 'Técnico criado com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tecnico.update(tecnico_params)
      redirect_to revenda_tecnico_path(@revenda, @tecnico), notice: 'Técnico atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @tecnico.update(active: false)
    redirect_to revenda_tecnicos_path(@revenda), notice: 'Técnico inativado com sucesso.'
  end

  private

  def set_revenda
    @revenda = Revenda.find(params[:revenda_id])
  end

  def set_tecnico
    @tecnico = @revenda.tecnicos.find(params[:id])
  end

  def check_admin_access
    if session[:access_type] == 'revenda'
      redirect_to root_path, alert: 'Acesso negado.' unless current_tecnico&.administrador?
    end
  end

  def tecnico_params
    params.require(:tecnico).permit(:name, :email, :telefone, :username, :password, 
                                   :password_confirmation, :funcao, :perfil_acesso, 
                                   :especialista, :active)
  end
end