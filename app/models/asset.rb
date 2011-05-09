class Asset < ActiveRecord::Base
  belongs_to :storage_area
  belongs_to :map
  belongs_to :container, :class_name => "Asset"
  has_many :contained_assets, :class_name => "Asset", :foreign_key => :container_id
  
  acts_as_audited :except => [:created_at, :updated_at]
  
  #default_scope :order => :barcode
end