class RemovePasswordDigestFromTecnicos < ActiveRecord::Migration[8.0]
  def change
    remove_column :tecnicos, :password_digest, :string
  end
end
