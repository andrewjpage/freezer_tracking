module Reception::Standard::Validations
  def self.included(base)
    base.class_eval do
      validate :storage_area_or_container_exists, :if => :check_in?
      validates_presence_of :asset_barcodes
    end
  end

  def storage_area_or_container_exists
    errors.add(:storage_area_barcode, "must be valid") if storage_area.nil? && container.nil?
  end
  
end
