class RevendasController < ApplicationController
  before_action :set_revenda, only: [:show, :edit, :update, :destroy]

  def index
    @revendas = Revenda.includes(:gerente_contas).active.order(:nome_fantasia)
  end

  def show
  end

  def new
    @revenda = Revenda.new
    @gerentes_contas = User.gerentes_contas.active
  end

  def create
    @revenda = Revenda.new(revenda_params)
    
    if @revenda.save
      redirect_to @revenda, notice: 'Revenda criada com sucesso.'
    else
      @gerentes_contas = User.gerentes_contas.active
      render :new
    end
  end

  def edit
    @gerentes_contas = User.gerentes_contas.active
  end

  def update
    if @revenda.update(revenda_params)
      redirect_to @revenda, notice: 'Revenda atualizada com sucesso.'
    else
      @gerentes_contas = User.gerentes_contas.active
      render :edit
    end
  end

  def destroy
    @revenda.update(active: false)
    redirect_to revendas_path, notice: 'Revenda desativada com sucesso.'
  end

  private

  def set_revenda
    @revenda = Revenda.find(params[:id])
  end

  def revenda_params
    params.require(:revenda).permit(:cnpj, :razao_social, :nome_fantasia, :tipo_contato,
                                   :telefone_suporte, :email_suporte, :responsavel,
                                   :cep, :logradouro, :numero, :complemento, :bairro,
                                   :cidade, :uf, :classificacao, :gerente_contas_id)
  end
end