class Asset < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 384
  
  belongs_to :storage_area
  belongs_to :map
  belongs_to :container, :class_name => "Asset"
  has_many :contained_assets, :class_name => "Asset", :foreign_key => :container_id
  has_many :asset_audits
  
  validates_presence_of :barcode
  validates_uniqueness_of :barcode
  
  attr_accessor :user_login

  acts_as_audited :except => [:created_at, :updated_at]

  before_save :decode_to_sanger_barcode, :if => :barcode_changed?
  after_save :audit_change
  
  scope :for_search_query, lambda { |search_terms| { :conditions => [ 'barcode IN (?) OR decoded_barcode_number in (?)', search_terms, search_terms ] } }
  
  
  def decode_to_sanger_barcode
    return unless Barcode.valid_ean13_barcode?(barcode)
    prefix_number, self.decoded_barcode_number, _ = Barcode.split_barcode(barcode)
    self.decoded_prefix = Barcode.prefix_to_human(prefix_number)
  end
  
  
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