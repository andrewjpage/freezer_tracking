class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def admin_login_required
    # TODO add authentication
  end
  
  
end
