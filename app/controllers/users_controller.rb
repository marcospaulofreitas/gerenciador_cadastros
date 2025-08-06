class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.includes(:user_profile, :revenda).active.order(:name)
  end

  def new
    @user = User.new
    @user_profiles = UserProfile.active
    @revendas = Revenda.active.order(:nome_fantasia)
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to users_path, notice: 'Usuário criado com sucesso.'
    else
      @user_profiles = UserProfile.active
      @revendas = Revenda.active.order(:nome_fantasia)
      render :new
    end
  end

  def edit
    @user_profiles = UserProfile.active
    @revendas = Revenda.active.order(:nome_fantasia)
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'Usuário atualizado com sucesso.'
    else
      @user_profiles = UserProfile.active
      @revendas = Revenda.active.order(:nome_fantasia)
      render :edit
    end
  end

  def destroy
    @user.update(active: false)
    redirect_to users_path, notice: 'Usuário desativado com sucesso.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :login, :password, :password_confirmation,
                                :user_profile_id, :revenda_id)
  end
end