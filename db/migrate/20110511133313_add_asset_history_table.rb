class AddAssetHistoryTable < ActiveRecord::Migration
  def self.up
    create_table :asset_audits, :force => true do |t|
      t.integer :asset_id
      t.string :container_barcode
      t.string :storage_area_name
      t.string :freezer_name
      t.string :building_area_name
      t.string :user_login
      t.string :action
      t.timestamps
    end
    add_index :asset_audits, :asset_id
  end

  def self.down
    drop_table :asset_audits
  end
end