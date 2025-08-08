class AddAprovadoToAudits < ActiveRecord::Migration[8.0]
  def change
    add_column :audits, :aprovado, :boolean, default: false, null: false
  end
end
