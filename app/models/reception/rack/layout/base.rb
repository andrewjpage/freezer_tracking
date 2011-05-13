class Reception::Rack::Layout::Base
  include ActiveModel::Validations
  include Reception::Rack::Layout::Parser
  include Reception::Rack::Layout::Validations
  
  attr_reader :uploaded_file
  
  def initialize(attributes = {})
    @uploaded_file = attributes[:file]
  end
  
  def file
    @file ||= self.uploaded_file.read
  end
  
  def location_to_barcodes
    @location_to_barcodes ||= parse_spreadsheet(file)
  end
  
end
