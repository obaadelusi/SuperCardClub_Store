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

ActiveRecord::Schema[7.1].define(version: 2024_04_05_203850) do
  create_table "alignments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.integer "stat_combat"
    t.integer "stat_durability"
    t.integer "stat_intelligence"
    t.integer "stat_power"
    t.integer "stat_speed"
    t.integer "stat_strength"
    t.integer "publisher_id", null: false
    t.integer "alignment_id", null: false
    t.integer "race_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alignment_id"], name: "index_characters_on_alignment_id"
    t.index ["publisher_id"], name: "index_characters_on_publisher_id"
    t.index ["race_id"], name: "index_characters_on_race_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "characters", "alignments"
  add_foreign_key "characters", "publishers"
  add_foreign_key "characters", "races"
end
