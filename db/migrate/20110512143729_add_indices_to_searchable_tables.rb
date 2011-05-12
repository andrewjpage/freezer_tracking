class AddIndicesToSearchableTables < ActiveRecord::Migration
  def self.up
    add_index :building_areas, :name
    add_index :freezers, :name
    add_index :storage_areas, :name
  end

  def self.down
    remove_index :storage_areas, :name
    remove_index :freezers, :name
    remove_index :building_areas, :name
    mind
  end
end