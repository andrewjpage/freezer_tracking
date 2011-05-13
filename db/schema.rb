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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110513121403) do

  create_table "asset_audits", :force => true do |t|
    t.integer  "asset_id"
    t.string   "container_barcode"
    t.string   "storage_area_name"
    t.string   "freezer_name"
    t.string   "building_area_name"
    t.string   "user_login"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "map_description"
  end

  add_index "asset_audits", ["asset_id"], :name => "index_asset_audits_on_asset_id"

  create_table "assets", :force => true do |t|
    t.integer  "container_id"
    t.string   "barcode"
    t.string   "decoded_prefix"
    t.integer  "decoded_barcode_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "map_id"
    t.integer  "storage_area_id"
    t.boolean  "dirty_layout",           :default => false
  end

  add_index "assets", ["barcode"], :name => "index_assets_on_barcode"
  add_index "assets", ["container_id"], :name => "index_assets_on_container_id"
  add_index "assets", ["decoded_barcode_number"], :name => "index_assets_on_decoded_barcode_number"
  add_index "assets", ["dirty_layout"], :name => "index_assets_on_dirty_layout"
  add_index "assets", ["storage_area_id"], :name => "index_assets_on_storage_area_id"

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "association_id"
    t.string   "association_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",          :default => 0
    t.string   "comment"
    t.string   "remote_address"
    t.datetime "created_at"
  end

  add_index "audits", ["association_id", "association_type"], :name => "association_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "building_areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "building_areas", ["name"], :name => "index_building_areas_on_name"

  create_table "freezers", :force => true do |t|
    t.string   "name"
    t.integer  "building_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "freezers", ["building_area_id"], :name => "index_freezers_on_building_area_id"
  add_index "freezers", ["name"], :name => "index_freezers_on_name"

  create_table "maps", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "maps", ["description"], :name => "index_maps_on_description"

  create_table "storage_areas", :force => true do |t|
    t.string   "name"
    t.integer  "freezer_id"
    t.string   "barcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "storage_areas", ["barcode"], :name => "index_storage_areas_on_barcode"
  add_index "storage_areas", ["freezer_id"], :name => "index_storage_areas_on_freezer_id"
  add_index "storage_areas", ["name"], :name => "index_storage_areas_on_name"

end
