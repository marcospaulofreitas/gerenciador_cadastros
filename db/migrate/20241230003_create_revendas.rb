class CreateRevendas < ActiveRecord::Migration[8.0]
  def change
    create_table :revendas do |t|
      t.string :cnpj, null: false
      t.string :razao_social, null: false
      t.string :nome_fantasia, null: false
      t.string :tipo_contato, null: false
      t.string :telefone_suporte, null: false
      t.string :email_suporte, null: false
      t.string :responsavel, null: false
      t.string :cep, null: false
      t.string :logradouro, null: false
      t.string :numero, null: false
      t.string :complemento
      t.string :bairro, null: false
      t.string :cidade, null: false
      t.string :uf, null: false, limit: 2
      t.string :classificacao, null: false
      t.references :gerente_contas, null: false, foreign_key: { to_table: :users }
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :revendas, :cnpj, unique: true
  end
end
