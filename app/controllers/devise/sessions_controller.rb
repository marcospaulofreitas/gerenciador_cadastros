class Devise::SessionsController < DeviseController
  prepend_before_action :require_no_authentication, only: [:new, :create]
  prepend_before_action :allow_params_authentication!, only: :create

  prepend_before_action(only: [:create, :destroy]) { request.env["devise.skip_timeout"] = true }

  def new
    self.resource = resource_class.new
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource))
  end

  def create
    access_type = params[:access_type]
    
    if access_type == 'webposto'
      # webPosto usa tabela User
      params[:user][:login] = params[:user][:email]
      
      begin
        self.resource = warden.authenticate!(auth_options)
        session[:access_type] = 'webposto'
        session[:revenda_id] = nil
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        redirect_to webposto_dashboard_path
        return
      rescue Warden::NotAuthenticated
        flash.now[:alert] = 'E-mail ou senha inválidos'
        self.resource = resource_class.new(sign_in_params)
        render :new
        return
      end
      
    elsif access_type == 'revenda'
      # Revenda usa controller específico - redirecionar
      redirect_to revenda_login_path
      return
    end
    
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    redirect_to root_path
  end

  def destroy
    if session[:access_type] == 'webposto'
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message! :notice, :signed_out if signed_out
    else
      flash[:notice] = 'Logout efetuado com sucesso!'
    end
    
    session.clear
    yield if block_given?
    redirect_to root_path
  end

  protected

  def sign_in_params
    devise_parameter_sanitizer.sanitize(:sign_in)
  end

  def serialize_options(resource)
    methods = resource_class.authentication_keys.dup
    methods = methods.keys if methods.is_a?(Hash)
    methods << :password if resource.respond_to?(:password)
    { methods: methods, only: [:password] }
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end

  def translation_scope
    'devise.sessions'
  end
end