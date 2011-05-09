class StorageArea < ActiveRecord::Base
  belongs_to :freezer
  has_many :assets
  
  acts_as_audited :except => [:created_at, :updated_at]
  
  default_scope :order => :name
  
  def prefix
    'SA'
  end
end