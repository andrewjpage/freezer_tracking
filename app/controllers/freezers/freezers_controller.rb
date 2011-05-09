class Freezers::FreezersController < ApplicationController
 
  def index
    @freezers = Freezer.all
    respond_to do |format|
      format.html
    end
  end

  
  def show
    @freezer = Freezer.find(params[:id], :include => [:storage_areas])

    respond_to do |format|
      format.html
    end
  end
  
  def assets_spreadsheet
     freezer = Freezer.find(params[:id], :include => [:storage_areas])
     
     send_data( AssetReport.generate(freezer.assets), :type => "text/plain",
     :filename=>"assets_for_freezer_#{freezer.id}.csv",
     :disposition => 'attachment')
  end
  
end
