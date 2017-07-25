# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170721122554) do

  create_table "aliquots", force: :cascade do |t|
    t.integer "fragment_size"
    t.decimal "concentration", precision: 18, scale: 8
    t.integer "qc_state"
    t.integer "sample_id"
    t.integer "tube_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sample_id"], name: "index_aliquots_on_sample_id"
    t.index ["tube_id"], name: "index_aliquots_on_tube_id"
  end

  create_table "libraries", force: :cascade do |t|
    t.string "kit_number"
    t.string "ligase_batch_number"
    t.decimal "volume", precision: 18, scale: 8
    t.integer "work_order_id"
    t.integer "tube_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tube_id"], name: "index_libraries_on_tube_id"
    t.index ["work_order_id"], name: "index_libraries_on_work_order_id"
  end

  create_table "samples", force: :cascade do |t|
    t.string "name"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tubes", force: :cascade do |t|
    t.string "barcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "work_orders", force: :cascade do |t|
    t.integer "state", default: 0
    t.string "uuid"
    t.integer "aliquot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aliquot_id"], name: "index_work_orders_on_aliquot_id"
  end

end
