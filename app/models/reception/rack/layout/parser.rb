module Reception::Rack::Layout::Parser

  def parse_spreadsheet(spreadsheet_data)
    map_to_barcodes = {}
    CSV.parse(spreadsheet_data) do |row|
      map, barcode = parse_row(row)
      if map_to_barcodes[map]
        map_to_barcodes[map] << barcode
      else
        map_to_barcodes[map] = [barcode]
      end
    end
    map_to_barcodes
  end

  def parse_row(row)
    return nil if row.blank?
    map_description, barcode = row
    map = Map.find_or_create_by_description( :description => map_description )

    [map, barcode.strip]
  end
end
