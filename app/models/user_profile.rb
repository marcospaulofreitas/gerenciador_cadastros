class UserProfile < ApplicationRecord
  PROFILES = %w[administrador gerente_contas basico revenda_admin revenda_tecnico].freeze

  has_many :users, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :name, inclusion: { in: PROFILES }

  scope :active, -> { where(active: true) }

  def self.administrador
    find_by(name: 'administrador')
  end

  def self.gerente_contas
    find_by(name: 'gerente_contas')
  end

  def self.basico
    find_by(name: 'basico')
  end

  def administrador?
    name == 'administrador'
  end

  def gerente_contas?
    name == 'gerente_contas'
  end

  def basico?
    name == 'basico'
  end
end