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

ActiveRecord::Schema.define(version: 2020_02_22_080010) do

  create_table "main", primary_key: "SERVERID", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "LANGUAGE", null: false
    t.string "PREFIX", null: false
  end

  create_table "support", primary_key: "SERVERID", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "CHANNEL", null: false
    t.bigint "ROLE", null: false
    t.bigint "NOTIFICATION", null: false
  end

  create_table "uno", primary_key: "SERVERID", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "THEME", null: false
    t.bigint "CATEGORY"
  end

end
