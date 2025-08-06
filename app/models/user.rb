class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :user_profile
  belongs_to :revenda, optional: true
  has_many :managed_revendas, class_name: 'Revenda', foreign_key: 'gerente_contas_id', dependent: :nullify

  validates :name, presence: true
  validates :login, presence: true, uniqueness: true
  validates :user_profile_id, presence: true
  validate :gerente_contas_must_have_revenda

  scope :active, -> { where(active: true) }
  scope :administradores, -> { joins(:user_profile).where(user_profiles: { name: 'administrador' }) }
  scope :gerentes_contas, -> { joins(:user_profile).where(user_profiles: { name: 'gerente_contas' }) }
  scope :basicos, -> { joins(:user_profile).where(user_profiles: { name: 'basico' }) }

  def webposto_admin?
    user_profile&.name == 'administrador'
  end

  def webposto_gerente?
    user_profile&.name == 'gerente_contas'
  end

  def webposto_basico?
    user_profile&.name == 'basico'
  end

  def revenda_admin?
    user_profile&.name == 'revenda_admin'
  end

  def revenda_tecnico?
    user_profile&.name == 'revenda_tecnico'
  end

  def full_access?
    webposto_admin? || webposto_gerente?
  end

  def can_manage_revenda?(revenda)
    return true if webposto_admin?
    return false unless webposto_gerente?
    
    managed_revendas.include?(revenda)
  end

  private

  def gerente_contas_must_have_revenda
    return unless webposto_gerente? && revenda.blank?
    
    errors.add(:revenda, 'deve ser selecionada para Gerente de Contas')
  end
end