class Revenda < ApplicationRecord
  include Auditable

  CLASSIFICACOES = %w[diamante ouro prata bronze branca].freeze

  belongs_to :gerente_contas, class_name: "User", foreign_key: "gerente_contas_id"
  has_many :tecnicos, dependent: :destroy
  has_many :users, dependent: :nullify

  validates :cnpj, presence: true, uniqueness: true
  validates :razao_social, presence: true
  validates :nome_fantasia, presence: true
  validates :telefone_suporte, presence: true
  validates :email_suporte, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :responsavel, presence: true
  validates :cep, presence: true, format: { with: /\A\d{5}-\d{3}\z/, message: "deve estar no formato 00000-000" }
  validates :logradouro, presence: true
  validates :numero, presence: true
  validates :bairro, presence: true
  validates :cidade, presence: true
  validates :uf, presence: true, length: { is: 2 }
  validates :classificacao, inclusion: { in: CLASSIFICACOES }
  validates :gerente_contas_id, presence: true
  validate :cnpj_must_be_valid
  validate :telefone_format_must_be_valid

  scope :active, -> { where(active: true) }
  scope :by_classificacao, ->(classificacao) { where(classificacao: classificacao) }

  def endereco_completo
    "#{logradouro}, #{numero}#{complemento.present? ? ", #{complemento}" : ''} - #{bairro}, #{cidade}/#{uf} - CEP: #{cep}"
  end

  def cnpj_formatted
    return cnpj unless cnpj.present?

    cnpj.gsub(/\D/, "").gsub(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, '\1.\2.\3/\4-\5')
  end

  private

  def cnpj_must_be_valid
    return if cnpj.blank?

    # Usar gem cpf_cnpj para validação completa
    unless CNPJ.valid?(cnpj)
      errors.add(:cnpj, "não é válido")
    end
  end

  def telefone_format_must_be_valid
    return if telefone_suporte.blank?

    # Aceita formatos: (00) 00000-0000, (00) 0000-0000, 0000-000-0000
    valid_formats = [
      /\A\(\d{2}\) \d{5}-\d{4}\z/, # Celular
      /\A\(\d{2}\) \d{4}-\d{4}\z/,  # Fixo
      /\A\d{4}-\d{3}-\d{4}\z/      # 0800
    ]
    
    unless valid_formats.any? { |format| telefone_suporte.match?(format) }
      errors.add(:telefone_suporte, "deve estar em um formato válido: (00) 00000-0000, (00) 0000-0000 ou 0000-000-0000")
    end
  end
end
