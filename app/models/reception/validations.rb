module Reception::Validations
  def self.included(base)
    base.class_eval do
      validate :user_login_exists
      validate :storage_area_or_container_exists, :if => :check_in?
      validates_presence_of :asset_barcodes
      validates_presence_of :user_barcode
    end
  end

  def user_login_exists
    errors.add(:user_barcode, "must be valid") if user_login.nil?
  end
  
  def storage_area_or_container_exists
    errors.add(:storage_area_barcode, "must be valid") if storage_area.nil? && container.nil?
  end
  
  
end
