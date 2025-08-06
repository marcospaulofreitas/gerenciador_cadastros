class HomeController < ApplicationController
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

  def validate_cnpj
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
      session[:revenda_id] = revenda.id
      session[:access_type] = 'revenda'
      render json: { success: true, redirect_url: new_user_session_path(revenda: true) }
    else
      render json: { error: 'CNPJ não encontrado ou revenda inativa' }, status: :not_found
    end
  end

  private

  def sanitize_cnpj(cnpj)
    return '' if cnpj.blank?
    cnpj.gsub(/\D/, '')
  end

  def valid_cnpj_format?(cnpj)
    cnpj.length == 14 && cnpj.match?(/\A\d{14}\z/)
  end
end