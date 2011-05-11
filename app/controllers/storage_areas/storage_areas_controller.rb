class StorageAreas::StorageAreasController < ApplicationController
 
  def index
    @storage_areas = StorageArea.all.paginate(:page => params[:page])
    respond_to do |format|
      format.html
    end
  end

  
  def show
    @storage_area = StorageArea.find(params[:id], :include => [:assets])
    @assets = @storage_area.assets.paginate(:page => params[:page])

    respond_to do |format|
      format.html
    end
  end
  
  def assets_spreadsheet
     storage_area = StorageArea.find(params[:id], :include => [:assets])
     
     send_data( AssetReport.generate(storage_area.assets), :type => "text/plain",
     :filename=>"assets_for_storage_area_#{storage_area.id}.csv",
     :disposition => 'attachment')
  end
  
end
