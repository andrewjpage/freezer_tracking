class Freezer < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 200
  belongs_to :building_area
  has_many :storage_areas
  has_many :assets, :through => :storage_areas
  
  validates_presence_of :name
  
  acts_as_audited :except => [:created_at, :updated_at]
  
  scope :for_search_query, lambda { |search_terms| { :conditions => [ 'name IN (?)', search_terms ] } }
  
  default_scope :order => :name
end
