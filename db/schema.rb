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

ActiveRecord::Schema.define(version: 2020_06_03_210737) do

  create_table "beliefs", force: :cascade do |t|
    t.string "description"
    t.string "representative_id"
    t.string "issue_id"
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
    t.string "shorthand"
    t.string "status"
    t.string "session"
    t.string "summary"
    t.string "url"
    t.boolean "suppourts_gun_control"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "donations", force: :cascade do |t|
    t.integer "amount"
    t.integer "lobbyist_id"
    t.integer "representative_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "emails", force: :cascade do |t|
    t.string "subject"
    t.string "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "initiative_id"
  end

  create_table "initiative_issues", force: :cascade do |t|
    t.integer "initiative_id"
    t.integer "issue_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "initiatives", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.integer "email_id"
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
  add_foreign_key "donations", "lobbyists"
  add_foreign_key "donations", "representatives"
  add_foreign_key "emails", "initiatives"
  add_foreign_key "initiative_issues", "initiatives"
  add_foreign_key "initiative_issues", "issues"
  add_foreign_key "offices", "representatives"
  add_foreign_key "recipiants", "emails"
  add_foreign_key "recipiants", "representatives"
  add_foreign_key "votes", "bills"
  add_foreign_key "votes", "representatives"
end
