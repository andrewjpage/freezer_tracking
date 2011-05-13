module Reception::User
  def self.included(base)
    base.class_eval do
      attr_reader :user_barcode

      validate :user_login_exists
      validates_presence_of :user_barcode
    end
  end
  
  def initialize(attributes = {})
    @user_barcode = attributes[:user_barcode]
  end

  def user_login_exists
    errors.add(:user_barcode, "must be valid") if user_login.nil?
  end

  def user_login
    @user_name ||= UserBarcode::UserBarcode.find_username_from_barcode(self.user_barcode)
  end

end
