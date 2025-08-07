class Devise::Tecnicos::SessionsController < Devise::SessionsController
  def new
    self.resource = resource_class.new
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  def create
    Rails.logger.info "=== TECNICOS SESSION CREATE ==="
    Rails.logger.info "Params: #{params.inspect}"
    
    cnpj = params[:tecnico]&.delete(:cnpj)
    Rails.logger.info "CNPJ: #{cnpj}"
    
    if cnpj.present?
      sanitized_cnpj = cnpj.gsub(/\D/, '')
      Rails.logger.info "CNPJ sanitizado: #{sanitized_cnpj}"
      
      revenda = Revenda.active.find_by(cnpj: sanitized_cnpj)
      Rails.logger.info "Revenda encontrada: #{revenda ? revenda.nome_fantasia : 'Não encontrada'}"
      
      unless revenda
        Rails.logger.info "ERRO: CNPJ não encontrado"
        flash.now[:alert] = 'CNPJ não encontrado'
        self.resource = resource_class.new
        render :new
        return
      end
      
      # Buscar técnico por username na revenda
      username = params[:tecnico][:username]
      password = params[:tecnico][:password]
      Rails.logger.info "Username: #{username}"
      
      tecnico = Tecnico.active.find_by(username: username, revenda: revenda)
      Rails.logger.info "Técnico encontrado: #{tecnico ? tecnico.username : 'Não encontrado'}"
      
      if tecnico&.valid_password?(password)
        Rails.logger.info "SUCESSO: Login válido"
        session[:revenda_id] = revenda.id
        session[:tecnico_id] = tecnico.id
        session[:access_type] = 'revenda'
        set_flash_message!(:notice, :signed_in)
        sign_in(:tecnico, tecnico)
        redirect_to revenda_dashboard_path
        return
      else
        Rails.logger.info "ERRO: Login ou senha incorretos"
        flash.now[:alert] = 'CNPJ, Login ou senha estão incorretos'
        self.resource = resource_class.new
        render :new
        return
      end
    else
      Rails.logger.info "ERRO: CNPJ obrigatório"
      flash.now[:alert] = 'CNPJ é obrigatório'
      self.resource = resource_class.new
      render :new
      return
    end
  end

  def destroy
    signed_out = sign_out(resource_name)
    session.clear
    set_flash_message! :notice, :signed_out if signed_out
    redirect_to root_path
  end

  protected

  def sign_in_params
    params.require(:tecnico).permit(:username, :password, :remember_me, :cnpj)
  end
end