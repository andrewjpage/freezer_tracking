class Reception::Rack::Base < Reception::Base
  include Reception::Rack::Validations
  
  attr_reader :rack_layout_file, :rack_barcode
  
  def initialize(attributes = {})
    super(attributes)
    @rack_layout_file = attributes[:rack_layout_file]
    @rack_barcode = attributes[:rack_barcode]
  end
  
  def container
    @container ||= Asset.find_or_create_by_barcode(:barcode => self.rack_barcode)
  end
  
  def rack_layout
    @rack_layout ||= Reception::Rack::Layout::Base.new(:file => rack_layout_file)
  end
  
  def save
    rack_layout.location_to_barcodes.each do |map, barcodes| 
      Asset.find_or_create_by_barcode(:barcode => barcodes.first).update_attributes!(:storage_area => nil, :map => map, :container => container, :user_login => user_login)
    end
    
    container.update_attributes!(:dirty_layout => false) if container.dirty_layout
    
    true
  end
  
end