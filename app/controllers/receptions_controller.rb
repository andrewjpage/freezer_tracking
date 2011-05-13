class ReceptionsController < ApplicationController
  
  def index
    @reception = Reception::Standard::Base.new
  end
  
  def create
    @reception = Reception::Standard::Base.new(params[:reception])

    respond_to do |format|
      if @reception.valid?
        @reception.save
        format.html { redirect_to( receptions_path, :notice => 'Updated assets') }
      else
        format.html { redirect_to( receptions_path, :notice => @reception.errors.full_messages.first) }
      end
    end
  end
  
  
end