class Freezer < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 200
  belongs_to :building_area
  has_many :storage_areas
  has_many :assets, :through => :storage_areas
  
  acts_as_audited :except => [:created_at, :updated_at]
  
  default_scope :order => :name
end
