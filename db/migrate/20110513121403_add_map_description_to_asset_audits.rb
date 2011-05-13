class AddMapDescriptionToAssetAudits < ActiveRecord::Migration
  def self.up
    add_column :asset_audits, :map_description, :string
  end

  def self.down
    remove_column :asset_audits, :map_description
  end
end