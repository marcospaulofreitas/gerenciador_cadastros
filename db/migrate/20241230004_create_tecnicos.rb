class CreateTecnicos < ActiveRecord::Migration[8.0]
  def change
    create_table :tecnicos do |t|
      t.references :revenda, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :telefone, null: false
      t.string :funcao, null: false
      t.boolean :especialista, default: false, null: false
      t.string :perfil_acesso, null: false
      t.string :username, null: false
      t.string :password, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :tecnicos, :telefone, unique: true
    add_index :tecnicos, :username, unique: true
  end
end