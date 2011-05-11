module Reception::Assets
  def find_assets
    source_barcodes.map{ |barcode| Asset.find_or_create_by_barcode(:barcode => barcode) }
  end

  def assets
    @assets ||= find_assets
  end

end