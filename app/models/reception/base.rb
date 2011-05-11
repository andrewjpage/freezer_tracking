# only checks into storage area not into container
class Reception::Base
  include ActiveModel::Validations
  include Reception::Validations
  include Reception::Assets
  
  attr_reader :user_barcode, :storage_area_barcode, :asset_barcodes
  
  def initialize(attributes = {})
    @user_barcode = attributes[:user_barcode]
    @storage_area_barcode = attributes[:storage_area_barcode]
    @asset_barcodes = attributes[:asset_barcodes]
  end
  
  def source_barcodes
    @source_barcodes ||= split_barcodes(self.asset_barcodes)
  end
  
  def split_barcodes(barcodes_string)
    return [] if barcodes_string.blank?
    barcodes_string.split(/\W/)
  end
  
  def user_login
    @user_name ||= UserBarcode::UserBarcode.find_username_from_barcode(self.user_barcode)
  end
  
  def storage_area
    @storage_area ||= StorageArea.find_by_barcode(storage_area_barcode)
  end
  
  def container
    @container ||= Asset.find_by_barcode(storage_area_barcode)
  end
  
  def check_in?
    return false if storage_area_barcode.blank?
    true
  end
  
  
  def save
    assets.each do |asset|
      asset.update_attributes!(:storage_area => storage_area, :container => container, :user_login => user_login)
    end
  end
  
end

