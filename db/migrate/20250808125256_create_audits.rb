class CreateAudits < ActiveRecord::Migration[8.0]
  def change
    create_table :audits do |t|
      t.references :user, null: true, foreign_key: true
      t.references :tecnico, null: true, foreign_key: true
      t.references :auditable, polymorphic: true, null: false
      t.string :action
      t.text :field_changes
      t.string :ip_address
      t.string :user_agent
      t.string :performed_by

      t.timestamps
    end
  end
end
