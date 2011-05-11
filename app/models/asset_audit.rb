class AssetAudit < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 200
  belongs_to :asset
end
