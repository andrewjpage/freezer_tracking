class BuildingAreas::BuildingAreasController < ApplicationController
 
  def index
    @building_areas = BuildingArea.all.paginate :page => params[:page]
    respond_to do |format|
      format.html
    end
  end

  
  def show
    @building_area = BuildingArea.find(params[:id], :include => [:freezers])
    @freezers = @building_area.freezers.paginate(:page => params[:page])

    respond_to do |format|
      format.html
    end
  end
  
  def assets_spreadsheet
     building_area = BuildingArea.find(params[:id])
     
     send_data( AssetReport.generate(building_area.assets), :type => "text/plain",
     :filename=>"assets_for_building_area_#{building_area.id}.csv",
     :disposition => 'attachment')
  end
  
end
