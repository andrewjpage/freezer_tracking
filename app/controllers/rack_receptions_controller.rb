class RackReceptionsController < ApplicationController
  def index
    @reception = Reception::Rack::Base.new
  end
  
  def create
    @reception = Reception::Rack::Base.new(params[:reception])

    respond_to do |format|
      if @reception.valid?
        @reception.save
        format.html { redirect_to( rack_receptions_path, :notice => 'Uploaded rack') }
      else
        format.html { redirect_to( rack_receptions_path, :notice => @reception.errors.full_messages.first) }
      end
    end
  end
  
  
end