class AddDeviseToTecnicos < ActiveRecord::Migration[8.0]
  def change
    add_column :tecnicos, :encrypted_password, :string
    add_column :tecnicos, :remember_created_at, :datetime
    add_column :tecnicos, :current_sign_in_at, :datetime
    add_column :tecnicos, :last_sign_in_at, :datetime
    add_column :tecnicos, :current_sign_in_ip, :string
    add_column :tecnicos, :last_sign_in_ip, :string
  end
end
