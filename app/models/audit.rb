class Audit < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :tecnico, optional: true
  belongs_to :auditable, polymorphic: true

  validates :action, presence: true
  validates :performed_by, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :limit_recent, ->(limit = 10) { recent.limit(limit) }
  scope :pendentes, -> { where(aprovado: false) }
  scope :aprovadas, -> { where(aprovado: true) }
  scope :by_tecnicos, -> { where.not(tecnico_id: nil) }

  def performer
    user || tecnico
  end

  def performer_name
    if user
      "#{user.name} (#{user.user_profile&.name || 'Sem perfil'})"
    elsif tecnico
      "#{tecnico.name} (#{tecnico.perfil_acesso} - #{tecnico.revenda&.nome_fantasia || 'Sem revenda'})"
    else
      performed_by
    end
  end

  def changes_summary
    return "Nenhuma alteração" if field_changes.blank?

    begin
      changes = JSON.parse(field_changes)
      changes.map do |field, values|
        "#{field}: #{values[0]} → #{values[1]}"
      end.join(", ")
    rescue JSON::ParserError
      field_changes
    end
  end

  def action_description
    case action
    when "create" then "Criação"
    when "update" then "Atualização"
    when "destroy" then "Inativação"
    else action.humanize
    end
  end

  def pendente?
    !aprovado?
  end

  def aprovar!
    update!(aprovado: true)
  end

  def feito_por_tecnico?
    tecnico_id.present?
  end
end
