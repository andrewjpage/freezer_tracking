class AssetReport 
  def self.headers
    ["Barcode", "Decoded prefix", "Decoded barcode number", "Container", "Storage area", "Freezer", "Building area", "Number of contained assets", "Map"]
  end
  
  def self.generate(assets)
    csv_string = CSV.generate( :row_sep => "\r\n") do |csv|
      csv << headers
      assets.each do |asset|
        csv << [asset.barcode, 
          asset.decoded_prefix,
          asset.decoded_barcode_number,
          asset.container.try(:barcode), 
          asset.storage_area.try(:name), 
          asset.storage_area.try(:freezer).try(:name),
          asset.storage_area.try(:freezer).try(:building_area).try(:name),
          asset.contained_assets.count,
          asset.map.try(:description)
          ]
      end
    end
  end
end
