class HomeController < ApplicationController
  before_action :redirect_if_authenticated, only: [:index]
  
  def index
    # Tela inicial com botões Revenda e WebPosto
  end

  def revenda_login
    # Modal para solicitar CNPJ da revenda
  end

  def webposto_login
    # Redireciona para home já que agora usa modal
    redirect_to root_path
  end

  def validate_cnpj_name
    cnpj = sanitize_cnpj(params[:cnpj])
    
    if cnpj.blank?
      render json: { error: 'CNPJ é obrigatório' }, status: :unprocessable_entity
      return
    end

    unless valid_cnpj_format?(cnpj)
      render json: { error: 'CNPJ inválido' }, status: :unprocessable_entity
      return
    end

    revenda = Revenda.active.find_by(cnpj: cnpj)
    
    if revenda
      render json: { success: true, revenda_name: revenda.nome_fantasia }
    else
      render json: { error: 'CNPJ não cadastrado em nosso sistema' }, status: :not_found
    end
  end

  private
  
  def redirect_if_authenticated
    if user_signed_in? && session[:access_type] == 'webposto'
      flash[:info] = 'Você já está logado no sistema. Para acessar a tela inicial, faça logout primeiro.'
      redirect_to webposto_dashboard_path
    elsif tecnico_signed_in? && session[:access_type] == 'revenda'
      flash[:info] = 'Você já está logado no sistema. Para acessar a tela inicial, faça logout primeiro.'
      redirect_to revenda_dashboard_path
    elsif session[:access_type].present?
      # Limpar sessão inválida
      session.clear
    end
  end

  def sanitize_cnpj(cnpj)
    return '' if cnpj.blank?
    cnpj.gsub(/\D/, '')
  end

  def valid_cnpj_format?(cnpj)
    cnpj.length == 14 && cnpj.match?(/\A\d{14}\z/)
  end
end