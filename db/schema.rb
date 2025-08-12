# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_11_000001) do
  create_table "audits", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tecnico_id"
    t.string "auditable_type", null: false
    t.integer "auditable_id", null: false
    t.string "action"
    t.text "field_changes"
    t.string "ip_address"
    t.string "user_agent"
    t.string "performed_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "aprovado", default: false, null: false
    t.index ["action"], name: "index_audits_on_action"
    t.index ["auditable_id"], name: "index_audits_on_auditable_id"
    t.index ["auditable_type", "auditable_id"], name: "index_audits_on_auditable"
    t.index ["auditable_type"], name: "index_audits_on_auditable_type"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["tecnico_id"], name: "index_audits_on_tecnico_id"
    t.index ["user_id"], name: "index_audits_on_user_id"
  end

  create_table "revendas", force: :cascade do |t|
    t.string "cnpj", null: false
    t.string "razao_social", null: false
    t.string "nome_fantasia", null: false
    t.string "tipo_contato", null: false
    t.string "telefone_suporte", null: false
    t.string "email_suporte", null: false
    t.string "responsavel", null: false
    t.string "cep", null: false
    t.string "logradouro", null: false
    t.string "numero", null: false
    t.string "complemento"
    t.string "bairro", null: false
    t.string "cidade", null: false
    t.string "uf", limit: 2, null: false
    t.string "classificacao", null: false
    t.integer "gerente_contas_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cnpj"], name: "index_revendas_on_cnpj", unique: true
    t.index ["gerente_contas_id"], name: "index_revendas_on_gerente_contas_id"
  end

  create_table "tecnicos", force: :cascade do |t|
    t.integer "revenda_id", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "telefone", null: false
    t.string "funcao", null: false
    t.boolean "especialista", default: false, null: false
    t.string "perfil_acesso", null: false
    t.string "username", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password"
    t.datetime "remember_created_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.index ["email"], name: "index_tecnicos_on_email", unique: true
    t.index ["reset_password_token"], name: "index_tecnicos_on_reset_password_token", unique: true
    t.index ["revenda_id"], name: "index_tecnicos_on_revenda_id"
    t.index ["telefone"], name: "index_tecnicos_on_telefone", unique: true
    t.index ["username"], name: "index_tecnicos_on_username", unique: true
  end

  create_table "user_profiles", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_user_profiles_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "login", null: false
    t.integer "user_profile_id", null: false
    t.integer "revenda_id"
    t.boolean "active", default: true, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login"], name: "index_users_on_login", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["revenda_id"], name: "index_users_on_revenda_id"
    t.index ["user_profile_id"], name: "index_users_on_user_profile_id"
  end

  add_foreign_key "audits", "tecnicos"
  add_foreign_key "audits", "users"
  add_foreign_key "revendas", "users", column: "gerente_contas_id"
  add_foreign_key "tecnicos", "revendas"
  add_foreign_key "users", "revendas"
  add_foreign_key "users", "user_profiles"
end
