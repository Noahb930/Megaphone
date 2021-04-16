# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_15_212131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "beliefs", force: :cascade do |t|
    t.string "description"
    t.integer "representative_id"
    t.integer "issue_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bill_issues", force: :cascade do |t|
    t.integer "bill_id"
    t.integer "issue_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bills", force: :cascade do |t|
    t.string "number"
    t.string "name"
    t.string "status"
    t.string "session"
    t.string "summary"
    t.string "url"
    t.boolean "endorsed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "location"
  end

  create_table "committees", force: :cascade do |t|
    t.string "name"
    t.integer "filer_id"
    t.integer "representative_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contributions", force: :cascade do |t|
    t.integer "amount"
    t.integer "lobbyist_id"
    t.integer "representative_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "date"
  end

  create_table "email_templates", force: :cascade do |t|
    t.string "subject"
    t.string "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.boolean "is_active"
  end

  create_table "issues", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lobbyists", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "filer_id"
    t.string "fec_committee_ids", array: true
  end

  create_table "offices", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "zipcode"
    t.string "phone"
    t.string "fax"
    t.integer "representative_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "state"
  end

  create_table "recipiants", force: :cascade do |t|
    t.integer "representative_id"
    t.integer "email_template_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "representatives", force: :cascade do |t|
    t.string "name"
    t.string "district"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.string "party"
    t.string "rating"
    t.string "img"
    t.string "profession"
    t.string "url"
    t.string "fec_id"
  end

  create_table "votes", force: :cascade do |t|
    t.string "stance"
    t.integer "bill_id"
    t.integer "representative_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "beliefs", "issues"
  add_foreign_key "beliefs", "representatives"
  add_foreign_key "bill_issues", "bills"
  add_foreign_key "bill_issues", "issues"
  add_foreign_key "committees", "representatives"
  add_foreign_key "contributions", "lobbyists"
  add_foreign_key "contributions", "representatives"
  add_foreign_key "offices", "representatives"
  add_foreign_key "recipiants", "email_templates"
  add_foreign_key "recipiants", "representatives"
  add_foreign_key "votes", "bills"
  add_foreign_key "votes", "representatives"
end
