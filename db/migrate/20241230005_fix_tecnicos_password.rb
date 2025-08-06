class FixTecnicosPassword < ActiveRecord::Migration[8.0]
  def change
    remove_column :tecnicos, :password, :string
    add_column :tecnicos, :password_digest, :string, null: false
  end
end