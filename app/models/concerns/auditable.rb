module Auditable
  extend ActiveSupport::Concern

  included do
    has_many :audits, as: :auditable, dependent: :destroy
    after_create :audit_create
    after_update :audit_update, if: :saved_changes?
    after_destroy :audit_destroy
  end

  private

  def audit_create
    create_audit_record('create')
  end

  def audit_update
    return unless saved_changes.any?
    filtered_changes = saved_changes.except('updated_at', 'encrypted_password', 'remember_created_at')
    return if filtered_changes.empty?
    
    create_audit_record('update', filtered_changes)
  end

  def audit_destroy
    create_audit_record('destroy')
  end

  def create_audit_record(action, changes = {})
    current_user = get_current_user
    current_tecnico = get_current_tecnico
    
    # Alterações de técnicos ficam pendentes, de usuários webposto são aprovadas
    aprovado = current_tecnico.nil?
    
    audits.create!(
      user: current_user,
      tecnico: current_tecnico,
      action: action,
      field_changes: changes.to_json,
      ip_address: get_current_ip,
      user_agent: get_current_user_agent,
      performed_by: get_performer_name(current_user, current_tecnico),
      aprovado: aprovado
    )
  rescue => e
    Rails.logger.error "Erro ao criar audit: #{e.message}"
  end

  def get_current_user
    return nil unless defined?(Current) && Current.respond_to?(:user)
    Current.user
  end

  def get_current_tecnico
    return nil unless defined?(Current) && Current.respond_to?(:tecnico)
    Current.tecnico
  end

  def get_current_ip
    return nil unless defined?(Current) && Current.respond_to?(:ip_address)
    Current.ip_address
  end

  def get_current_user_agent
    return nil unless defined?(Current) && Current.respond_to?(:user_agent)
    Current.user_agent
  end

  def get_performer_name(user, tecnico)
    if user
      user.name
    elsif tecnico
      tecnico.name
    else
      'Sistema'
    end
  end
end