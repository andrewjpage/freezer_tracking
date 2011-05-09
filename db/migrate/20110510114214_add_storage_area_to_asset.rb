class AddStorageAreaToAsset < ActiveRecord::Migration
  def self.up
    remove_column :assets, :container_type
    add_column :assets, :storage_area_id, :integer
    add_column :assets, :dirty_layout, :boolean, :default => false
    
    add_index :assets, :storage_area_id
    add_index :assets, :dirty_layout
  end

  def self.down
  end
end
