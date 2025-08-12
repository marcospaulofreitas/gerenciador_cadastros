class AddSecurityIndexes < ActiveRecord::Migration[8.0]
  def change
    # Índices para auditoria (performance)
    add_index :audits, :auditable_type unless index_exists?(:audits, :auditable_type)
    add_index :audits, :auditable_id unless index_exists?(:audits, :auditable_id)
    add_index :audits, :action unless index_exists?(:audits, :action)
    add_index :audits, :created_at unless index_exists?(:audits, :created_at)

    # Índice único para reset_password_token dos técnicos
    add_index :tecnicos, :reset_password_token, unique: true unless index_exists?(:tecnicos, :reset_password_token)

    # Índice único para email dos técnicos
    add_index :tecnicos, :email, unique: true unless index_exists?(:tecnicos, :email)
  end
end
