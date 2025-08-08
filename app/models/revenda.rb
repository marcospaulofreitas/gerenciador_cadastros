class Revenda < ApplicationRecord
  include Auditable
  
  CLASSIFICACOES = %w[diamante ouro prata bronze branca].freeze
  TIPOS_CONTATO = %w[celular fixo 0800].freeze

  belongs_to :gerente_contas, class_name: 'User', foreign_key: 'gerente_contas_id'
  has_many :tecnicos, dependent: :destroy
  has_many :users, dependent: :nullify

  validates :cnpj, presence: true, uniqueness: true
  validates :razao_social, presence: true
  validates :nome_fantasia, presence: true
  validates :tipo_contato, inclusion: { in: TIPOS_CONTATO }
  validates :telefone_suporte, presence: true
  validates :email_suporte, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :responsavel, presence: true
  validates :cep, presence: true
  validates :logradouro, presence: true
  validates :numero, presence: true
  validates :bairro, presence: true
  validates :cidade, presence: true
  validates :uf, presence: true, length: { is: 2 }
  validates :classificacao, inclusion: { in: CLASSIFICACOES }
  validates :gerente_contas_id, presence: true
  validate :cnpj_must_be_valid

  scope :active, -> { where(active: true) }
  scope :by_classificacao, ->(classificacao) { where(classificacao: classificacao) }

  def endereco_completo
    "#{logradouro}, #{numero}#{complemento.present? ? ", #{complemento}" : ''} - #{bairro}, #{cidade}/#{uf} - CEP: #{cep}"
  end

  def cnpj_formatted
    return cnpj unless cnpj.present?
    
    cnpj.gsub(/\D/, '').gsub(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, '\1.\2.\3/\4-\5')
  end

  private

  def cnpj_must_be_valid
    return if cnpj.blank?
    
    # Validação básica de formato CNPJ
    cnpj_numbers = cnpj.gsub(/\D/, '')
    unless cnpj_numbers.length == 14
      errors.add(:cnpj, 'deve ter 14 dígitos')
    end
  end
end