class Devise::Tecnicos::SessionsController < Devise::SessionsController
  before_action :redirect_if_authenticated, only: [:new]
  
  def new
    self.resource = resource_class.new
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  def create
    cnpj = params[:tecnico]&.delete(:cnpj)
    
    if cnpj.present?
      sanitized_cnpj = cnpj.gsub(/\D/, '')
      revenda = Revenda.active.find_by(cnpj: sanitized_cnpj)
      
      unless revenda
        flash.now[:alert] = 'CNPJ não encontrado'
        self.resource = resource_class.new
        respond_to do |format|
          format.html { render :new }
          format.turbo_stream { render :new }
        end
        return
      end
      
      username = params[:tecnico][:username]
      password = params[:tecnico][:password]
      tecnico = Tecnico.active.find_by(username: username, revenda: revenda)
      
      if tecnico&.valid_password?(password)
        session[:revenda_id] = revenda.id
        session[:tecnico_id] = tecnico.id
        session[:access_type] = 'revenda'
        set_flash_message!(:notice, :signed_in)
        sign_in(:tecnico, tecnico)
        redirect_to revenda_dashboard_path
        return
      else
        flash.now[:alert] = 'CNPJ, Login ou senha estão incorretos'
        self.resource = resource_class.new
        respond_to do |format|
          format.html { render :new }
          format.turbo_stream { render :new }
        end
        return
      end
    else
      flash.now[:alert] = 'CNPJ é obrigatório'
      self.resource = resource_class.new
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render :new }
      end
      return
    end
  end

  def destroy
    signed_out = sign_out(resource_name)
    session.clear
    flash[:notice] = 'Logout efetuado com sucesso!'
    redirect_to root_path
  end

  protected

  def sign_in_params
    params.require(:tecnico).permit(:username, :password, :remember_me, :cnpj)
  end
  
  private
  
  def redirect_if_authenticated
    if user_signed_in? && session[:access_type] == 'webposto'
      flash[:info] = 'Você já está logado no sistema. Para acessar a tela inicial, faça logout primeiro.'
      redirect_to webposto_dashboard_path
    elsif tecnico_signed_in? && session[:access_type] == 'revenda'
      flash[:info] = 'Você já está logado no sistema. Para acessar a tela inicial, faça logout primeiro.'
      redirect_to revenda_dashboard_path
    end
  end
end