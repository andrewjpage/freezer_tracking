module Reception::Rack::Validations
  def self.included(base)
    base.class_eval do
      validates_presence_of :rack_barcode
      validates_presence_of :rack_layout_file
      validate :format_of_rack_layout_file
    end
  end

  def format_of_rack_layout_file
    unless rack_layout.valid?
      save_errors_to_base(rack_layout.errors)
    end
  end
  
  def save_errors_to_base(object_errors)
    object_errors.each do |key, message|
      self.errors.add(key, message)
    end
  end
  
end
