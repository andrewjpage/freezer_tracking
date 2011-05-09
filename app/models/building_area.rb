class BuildingArea < ActiveRecord::Base
  has_many :freezers
  acts_as_audited :except => [:created_at, :updated_at]
  
  default_scope :order => :name
 
  def assets
    freezers.map(&:assets).flatten
  end
 
  
end
