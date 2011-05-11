class Asset < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 384
  
  belongs_to :storage_area
  belongs_to :map
  belongs_to :container, :class_name => "Asset"
  has_many :contained_assets, :class_name => "Asset", :foreign_key => :container_id
  has_many :asset_audits
  
  attr_accessor :user_login

  acts_as_audited :except => [:created_at, :updated_at]

  after_save :audit_change
  
  def audit_change
    action = 'Check in'
    action = 'Check out' if storage_area.nil? && container.nil?
    
    self.asset_audits.create!(
      :container_barcode => container.try(:barcode), 
      :storage_area_name => storage_area.try(:name),
      :freezer_name => storage_area.try(:freezer).try(:name),
      :building_area_name => storage_area.try(:freezer).try(:building_area).try(:name),
      :user_login => user_login,
      :action => action
      )
    
    
  end
  
end