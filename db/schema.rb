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

ActiveRecord::Schema[7.0].define(version: 2023_02_27_090441) do
  create_table "configs", force: :cascade do |t|
    t.string "url"
    t.string "apikey"
  end

  create_table "currencies", id: false, force: :cascade do |t|
    t.string "code", null: false
    t.string "desc", null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true
  end

  create_table "rates", id: false, force: :cascade do |t|
    t.date "date", default: "2023-02-11", null: false
    t.decimal "rate", precision: 20, scale: 10, null: false
    t.string "base", null: false
    t.string "to", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "rates", "currencies", column: "base", primary_key: "code", on_delete: :cascade
  add_foreign_key "rates", "currencies", column: "to", primary_key: "code", on_delete: :cascade
end
