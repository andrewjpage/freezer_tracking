class CreateInitialTables < ActiveRecord::Migration
  def self.up
    
    create_table "assets", :force => true do |t|
      t.string   "container_type"
      t.integer  "container_id"
      t.string   "barcode"
      t.string   "decoded_prefix"
      t.integer  "decoded_barcode_number"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "map_id"
    end

    add_index "assets", ["barcode"], :name => "index_assets_on_barcode"
    add_index "assets", ["decoded_barcode_number"], :name => "index_assets_on_decoded_barcode_number"
    add_index "assets", ["container_id"]
    add_index "assets", ["container_type"]

    create_table "audits", :force => true do |t|
      t.integer  "auditable_id"
      t.string   "auditable_type"
      t.integer  "user_id"
      t.string   "user_type"
      t.string   "username"
      t.string   "action"
      t.text     "changes"
      t.integer  "version",        :default => 0
      t.datetime "created_at"
    end

    add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
    add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
    add_index "audits", ["user_id", "user_type"], :name => "user_index"

    create_table "building_areas", :force => true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

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

    create_table "freezers", :force => true do |t|
      t.string   "name"
      t.integer  "building_area_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "freezers", ["building_area_id"], :name => "index_freezers_on_building_area_id"

  end

  def self.down
  end
end
