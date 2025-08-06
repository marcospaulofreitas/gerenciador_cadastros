class DeviseCreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :name,               null: false
      t.string :login,              null: false
      t.references :user_profile,   null: false, foreign_key: true
      t.references :revenda,        null: true, foreign_key: true
      t.boolean :active,            default: true, null: false

      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :login,                unique: true
    add_index :users, :reset_password_token, unique: true
  end
end