class Freezers::FreezersController < ApplicationController
 
  def index
    @freezers = Freezer.all.paginate(:page => params[:page])
    respond_to do |format|
      format.html
    end
  end

  
  def show
    @freezer = Freezer.find(params[:id], :include => [:storage_areas])
    @storage_areas = @freezer.storage_areas.paginate(:page => params[:page])

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
