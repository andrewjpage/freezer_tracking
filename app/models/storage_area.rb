class StorageArea < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 200
  belongs_to :freezer
  has_many :assets
  
  acts_as_audited :except => [:created_at, :updated_at]

  validates_presence_of :barcode
  validates_presence_of :name
  validates_uniqueness_of :barcode
  
  default_scope :order => :name
  
  scope :for_search_query, lambda { |search_terms| { :conditions => [ 'name IN (?) OR barcode IN (?)', search_terms, search_terms ] } }
  
  def prefix
    'SA'
  end
  
  def full_location
    "#{name}, #{freezer.try(:name)}, #{freezer.try(:building_area).try(:name)}"
  end
end