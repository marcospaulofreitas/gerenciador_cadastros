class RevendasController < ApplicationController
  before_action :set_revenda, only: [ :show, :edit, :update, :destroy, :toggle_status ]

  def index
    @revendas = filter_revendas
    @gerentes = User.gerentes_contas.order(:name)

    if request.xhr?
      render partial: "table", locals: { revendas: @revendas }, layout: false
    end
  end

  def show
  end

  def new
    @revenda = Revenda.new
  end

  def create
    @revenda = Revenda.new(revenda_params)

    if @revenda.save
      redirect_to @revenda, notice: "Revenda criada com sucesso."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @revenda.update(revenda_params)
      redirect_to @revenda, notice: "Revenda atualizada com sucesso."
    else
      render :edit
    end
  end

  def destroy
    @revenda.update(active: false)
    redirect_to revendas_path, notice: "Revenda inativada com sucesso."
  end

  def toggle_status
    new_status = !@revenda.active
    @revenda.update_column(:active, new_status)

    message = new_status ? "Revenda ativada com sucesso." : "Revenda desativada com sucesso."

    respond_to do |format|
      format.html { redirect_to revendas_path, notice: message }
      format.json { render json: { success: true, message: message } }
    end
  end

  private

  def set_revenda
    @revenda = Revenda.find(params[:id])
  end

  def filter_revendas
    revendas = Revenda.includes(:gerente_contas, :tecnicos)

    # Filtro por status
    case params[:status]
    when "ativas"
      revendas = revendas.where(active: true)
    when "inativas"
      revendas = revendas.where(active: false)
    else
      revendas = revendas # todas
    end

    # Filtro por gerente de contas
    if params[:gerente].present?
      revendas = revendas.where(gerente_contas_id: params[:gerente])
    end

    # Filtro por busca (nome ou CNPJ)
    if params[:search].present?
      search_term = params[:search].strip

      # Busca por nome fantasia (case insensitive)
      nome_condition = "LOWER(nome_fantasia) LIKE LOWER(?)"

      # Busca por CNPJ (remove formatação)
      cnpj_numbers = search_term.gsub(/\D/, "")
      if cnpj_numbers.present?
        cnpj_condition = "REPLACE(REPLACE(REPLACE(cnpj, '.', ''), '/', ''), '-', '') LIKE ?"
        revendas = revendas.where("(#{nome_condition}) OR (#{cnpj_condition})", "%#{search_term}%", "%#{cnpj_numbers}%")
      else
        revendas = revendas.where(nome_condition, "%#{search_term}%")
      end
    end

    revendas.order(:nome_fantasia)
  end

  def normalize_string(str)
    str.tr("ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
           "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz")
  end

  def revenda_params
    params.require(:revenda).permit(:nome_fantasia, :razao_social, :cnpj, :tipo_contato,
                                   :telefone_suporte, :email_suporte, :responsavel, :cep,
                                   :logradouro, :numero, :complemento, :bairro, :cidade,
                                   :uf, :classificacao, :gerente_contas_id, :active)
  end
end
