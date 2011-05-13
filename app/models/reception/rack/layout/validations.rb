module Reception::Rack::Layout::Validations
  def self.included(base)
    base.class_eval do
      validates_presence_of :uploaded_file
      validate :file_format
      validate :one_barcode_per_location
      validate :no_duplicated_barcodes
    end
  end

  def file_format
    begin
      location_to_barcodes
    rescue
      invalid_format_error
    end
  end

  def one_barcode_per_location
    begin
      location_to_barcodes.each do |location, barcodes|
        if barcodes.size > 1
          errors.add(:uploaded_file, "must have only one barcode per location")
          return
        end
      end
    rescue NoMethodError
      invalid_format_error
    end
  end
  
  def no_duplicated_barcodes
    begin
      barcodes = location_to_barcodes.values.flatten
      errors.add(:uploaded_file, "must not have duplicated barcodes") if barcodes.size != barcodes.uniq.size
    rescue NoMethodError
      invalid_format_error
    end
  end
  
  def invalid_format_error
    errors.add(:uploaded_file, "must be a valid format")
  end
  
end
