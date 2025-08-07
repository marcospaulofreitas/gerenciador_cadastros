class RevendasController < ApplicationController
  before_action :set_revenda, only: [:show, :edit, :update, :destroy]
  
  def index
    @revendas = Revenda.active.includes(:gerente_contas)
  end

  def show
  end

  def new
    @revenda = Revenda.new
  end

  def create
    @revenda = Revenda.new(revenda_params)
    
    if @revenda.save
      redirect_to @revenda, notice: 'Revenda criada com sucesso.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @revenda.update(revenda_params)
      redirect_to @revenda, notice: 'Revenda atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @revenda.update(active: false)
    redirect_to revendas_path, notice: 'Revenda inativada com sucesso.'
  end

  private

  def set_revenda
    @revenda = Revenda.find(params[:id])
  end

  def revenda_params
    params.require(:revenda).permit(:nome_fantasia, :razao_social, :cnpj, :endereco, 
                                   :cidade, :uf, :cep, :telefone, :email, :classificacao,
                                   :gerente_contas_id, :active)
  end
end