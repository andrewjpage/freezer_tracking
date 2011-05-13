module Reception::Standard::Asset
  def find_assets
    source_barcodes.map{ |barcode| Asset.find_or_create_by_barcode(:barcode => barcode) }
  end
  
  def assets
    @assets ||= find_assets
  end
  
  def save
    assets.each do |asset|
      asset.update_attributes!(:storage_area => storage_area, :container => container, :user_login => user_login)
    end
    
    true
  end
end
