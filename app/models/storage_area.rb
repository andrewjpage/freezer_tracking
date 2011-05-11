class StorageArea < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 200
  belongs_to :freezer
  has_many :assets
  
  acts_as_audited :except => [:created_at, :updated_at]
  
  default_scope :order => :name
  
  def prefix
    'SA'
  end
end