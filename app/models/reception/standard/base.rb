class Reception::Standard::Base < Reception::Base
  include Reception::Standard::Validations
  include Reception::Standard::Asset
  
  attr_reader :storage_area_barcode, :asset_barcodes
  
  def initialize(attributes = {})
    super(attributes)
    @storage_area_barcode = attributes[:storage_area_barcode]
    @asset_barcodes = attributes[:asset_barcodes]
  end
  
  def container
    @container ||= Asset.find_by_barcode(storage_area_barcode)
  end
  
  def check_in?
    return false if storage_area_barcode.blank?
    true
  end
  
  def storage_area
    @storage_area ||= StorageArea.find_by_barcode(storage_area_barcode)
  end
  
  def source_barcodes
    @source_barcodes ||= split_barcodes(self.asset_barcodes)
  end
  
  def split_barcodes(barcodes_string)
    return [] if barcodes_string.blank?
    barcodes_string.split(/\W/)
  end
  
end

