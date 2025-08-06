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

  def administrador?
    user_profile&.administrador?
  end

  def gerente_contas?
    user_profile&.gerente_contas?
  end

  def basico?
    user_profile&.basico?
  end

  def full_access?
    administrador? || gerente_contas?
  end

  def can_manage_revenda?(revenda)
    return true if administrador?
    return false unless gerente_contas?
    
    managed_revendas.include?(revenda)
  end

  private

  def gerente_contas_must_have_revenda
    return unless gerente_contas? && revenda.blank?
    
    errors.add(:revenda, 'deve ser selecionada para Gerente de Contas')
  end
end