class Tecnico < ApplicationRecord
  FUNCOES = %w[supervisor rh suporte desenvolvedor analista plantao dba comercial financeiro outros].freeze
  PERFIS_ACESSO = %w[administrador tecnico].freeze

  belongs_to :revenda
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :telefone, presence: true, uniqueness: true
  validates :funcao, inclusion: { in: FUNCOES }
  validates :perfil_acesso, inclusion: { in: PERFIS_ACESSO }
  validates :username, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :especialistas, -> { where(especialista: true) }
  scope :administradores, -> { where(perfil_acesso: 'administrador') }
  scope :tecnicos, -> { where(perfil_acesso: 'tecnico') }

  def administrador?
    perfil_acesso == 'administrador'
  end

  def tecnico?
    perfil_acesso == 'tecnico'
  end

  def funcao_humanized
    I18n.t(\"tecnicos.funcoes.#{funcao}\", default: funcao.humanize)
  end

  def can_access_other_tecnicos?
    administrador?
  end
end