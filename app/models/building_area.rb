class BuildingArea < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 200
  has_many :freezers
  acts_as_audited :except => [:created_at, :updated_at]
  
  default_scope :order => :name
 
  def assets
    # TODO replace with single query
    freezers.map(&:assets).flatten
  end
  
end
