class Freezer < ActiveRecord::Base
  belongs_to :building_area
  has_many :storage_areas
  has_many :assets, :through => :storage_areas
  
  acts_as_audited :except => [:created_at, :updated_at]
  
  default_scope :order => :name
end
