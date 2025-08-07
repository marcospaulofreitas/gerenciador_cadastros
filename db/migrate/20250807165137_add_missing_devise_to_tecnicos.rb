class AddMissingDeviseToTecnicos < ActiveRecord::Migration[8.0]
  def change
    add_column :tecnicos, :reset_password_token, :string
    add_column :tecnicos, :reset_password_sent_at, :datetime
  end
end
